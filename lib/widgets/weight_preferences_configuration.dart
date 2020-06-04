import 'package:flutter/material.dart';
import 'package:weight_tracker/data/models/add_weight_helper.dart';
import 'package:weight_tracker/data/models/weight.dart';
import 'package:weight_tracker/screens/add_weight_screen.dart';
import 'package:weight_tracker/util/pair.dart';

import 'tile.dart';
import 'weight_date_tile.dart';

class WeightPreferencesConfiguration extends StatelessWidget {
  final Pair<double, DateTime> prefs;
  final String text;
  final AddWeightType addType;
  const WeightPreferencesConfiguration({
    @required this.prefs,
    @required this.text,
    @required this.addType,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Create a dummy weight data value
        WeightData temp = WeightData(
          null,
          weight: prefs.first,
          date: prefs.second,
        );

        Navigator.pushNamed(
          context,
          AddWeightScreen.routeName,
          arguments: AddWeightHelper(
            weightData: temp,
            addType: addType,
          ),
        );
      },
      child: Tile(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 12.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  text,
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  'Click to change it',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                )
              ],
            ),
            WeightDateTile(
              weight: prefs.first,
              date: prefs.second,
            )
          ],
        ),
      ),
    );
  }
}
