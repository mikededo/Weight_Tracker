import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weight_tracker/data/blocs/weight_counter_bloc/weight_counter_bloc.dart';
import 'package:weight_tracker/widgets/calendar.dart';
import 'package:weight_tracker/widgets/screen_header.dart';
import 'package:weight_tracker/widgets/weight_value_tile.dart';

import '../data/models/weight.dart';
import '../data/blocs/weight_bloc/weight_bloc.dart';

class AddWeightScreen extends StatefulWidget {
  static const String routeName = '/add_weight_screen.dart';
  final WeightData wd;

  AddWeightScreen({this.wd});

  @override
  _AddWeightScreenState createState() => _AddWeightScreenState();
}

class _AddWeightScreenState extends State<AddWeightScreen> {
  DateTime _selectedDate;

  Widget _buildCalendarCarousel(BuildContext context) {
    return Calendar(
      selectedDateTime: _selectedDate,
      onDayPressed: (DateTime date, _) {
        setState(() => _selectedDate = date);
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedDate = widget.wd == null ? DateTime.now() : widget.wd.date;
  }

  @override
  Widget build(BuildContext context) {
    WeightData inValue = widget.wd;
    return BlocProvider<WeightCounterBloc>(
      create: (_) => WeightCounterBloc(inValue == null ? null : inValue.weight),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ScreenHeader(text: 'New Weight'),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Date',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                      left: 8.0,
                      bottom: 8.0,
                      top: 14.0,
                    ),
                    child: _buildCalendarCarousel(context),
                  ),
                ),
                WeightValueTile(),
              ],
            ),
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton.extended(
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                inValue == null ? 'ADD WEIGHT' : 'UPDATE WEIGHT',
                style: GoogleFonts.workSans().copyWith(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            backgroundColor: Theme.of(context).accentColor,
            onPressed: () {
              double weight = BlocProvider.of<WeightCounterBloc>(context).state;

              WeightData wd = WeightData(
                inValue == null ? null : inValue.id,
                weight: weight,
                date: _selectedDate,
              );
              BlocProvider.of<WeightBloc>(context).add(
                inValue == null ? WeightAdded(wd) : WeightUpdated(wd),
              );

              Navigator.of(context).pop();
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
