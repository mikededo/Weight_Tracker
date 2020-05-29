import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:weight_tracker/data/models/weight.dart';
import 'package:weight_tracker/data/blocs/weight_bloc/weight_bloc.dart';
import 'package:weight_tracker/screens/add_weight_screen.dart';
import 'package:weight_tracker/util/util.dart';
import 'package:weight_tracker/widgets/tile.dart';

class HistoryTile extends StatelessWidget {
  final WeightData weightData;
  final WeightData prevWeightData;
  final bool extended;

  HistoryTile({
    @required this.weightData,
    @required this.prevWeightData,
    this.extended = false,
  });

  Widget _buildDiffText() {
    if (prevWeightData == null) {
      return Text('');
    }

    double diff = weightData.weight - prevWeightData.weight;

    if (diff == 0) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            FontAwesomeIcons.equals,
            size: 18.0,
            color: textGreyColor,
          ),
          SizedBox(width: 4.0),
          Text(
            '0.0',
            style: TextStyle(
              color: textGreyColor,
            ),
          ),
        ],
      );
    } else if (diff > 0) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.arrow_upward,
            size: 22.0,
            color: Colors.red,
          ),
          SizedBox(width: 4.0),
          Text(
            diff.toStringAsFixed(1),
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.arrow_downward,
            size: 22.0,
            color: Colors.green,
          ),
          SizedBox(width: 4.0),
          Text(
            diff.toStringAsFixed(1),
            style: TextStyle(
              color: Colors.green,
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(AddWeightScreen.routeName, arguments: weightData),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Tile(
              margin: const EdgeInsets.symmetric(
                vertical: 5.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          DateFormat.yMMMd().format(weightData.date),
                          style: TextStyle(
                            color: textGreyColor,
                          ),
                        ),
                      ),
                      _buildDiffText()
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.openSans(),
                      children: <TextSpan>[
                        TextSpan(
                          text: weightData.weight.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        TextSpan(
                          text: ' kg',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          extended
              ? Expanded(
                  flex: 1,
                  child: Tooltip(
                    message: 'Delete weight',
                    showDuration: Duration(milliseconds: 750),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      child: Icon(
                        FontAwesomeIcons.times,
                        color: Colors.red,
                      ),
                      onTap: () => BlocProvider.of<WeightBloc>(context).add(
                        WeightDeleted(weightData),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
