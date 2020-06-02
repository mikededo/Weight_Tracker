import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/data/blocs/user_preferences_bloc/user_preferences_bloc.dart';
import 'package:weight_tracker/data/models/user_data.dart';

import '../data/database/user_shared_preferences.dart';
import '../data/blocs/weight_db_bloc/weight_db_bloc.dart';
import '../widgets/tile.dart';

class BMITile extends StatefulWidget {
  static const List<Color> _colors = [
    Color(0xFF3498DB),
    Color(0xFF2ECC71),
    Color(0xFFF5B041),
    Color(0xFFE74C3C),
  ];

  @override
  _BMITileState createState() => _BMITileState();
}

class _BMITileState extends State<BMITile> {
  final List<int> _ranges = [12, 20, 26];
  final List<String> _bmiResultsText = [
    "Underweight",
    "Healthy weight",
    "Overweight",
    "Obese"
  ];

  int _bmiResults(double bmiValue) {
    int bmi = bmiValue.toInt() - 6;
    if (bmi < _ranges[0]) {
      return 0;
    } else if (bmi < _ranges[1]) {
      return 1;
    } else if (bmi < _ranges[2]) {
      return 2;
    } else {
      return 3;
    }
  }

  TextSpan _buildBMIResults(double bmiValue) {
    int res = _bmiResults(bmiValue);
    return TextSpan(
      text: _bmiResultsText[res].toUpperCase(),
      style: TextStyle(
        color: BMITile._colors[res],
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  List<Widget> _buildBars(double bmiValue) {
    List<Widget> list = [];
    for (int i = 0; i < 50; i++) {
      Color c;
      if (i < _ranges[0]) {
        c = BMITile._colors[0];
      } else if (i < _ranges[1]) {
        c = BMITile._colors[1];
      } else if (i < _ranges[2]) {
        c = BMITile._colors[2];
      } else {
        c = BMITile._colors[3];
      }

      int bmi = bmiValue.toInt();

      list.add(
        Container(
          height: i == bmi - 6 ? 38.0 : 22.0,
          width: 2.5,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
      );
    }
    return list;
  }

  String _loadBMI(double bmiValue) {
    String res;

    if (bmiValue < 13) {
      res = '13.0';
    } else if (bmiValue > 63) {
      res = '63.0';
    } else {
      res = bmiValue.toStringAsFixed(2);
    }

    return res;
  }

  double _calculateBmiValue(double weight) {
    int height = BlocProvider.of<UserPreferencesBloc>(context).state.height;
    return (weight ?? 80.0) / pow(height / 100, 2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'BMI Calculator',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Tile(
            height: MediaQuery.of(context).size.height * 0.15,
            child: BlocBuilder<WeightDBBloc, WeightDBState>(
              builder: (context, state) {
                if (state is WeightDBLoadInProgress ||
                    state is WeightDBInitial) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is WeightDBLoadSuccess) {
                  if (state.weightCollection.isEmpty) {
                    return Center(
                      child: Text(
                        'The BMI will be calculated once\nyou add a weight!',
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    double latestWeight = state.weightCollection.first.weight;

                    return BlocBuilder<UserPreferencesBloc, UserData>(
                      builder: (context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: _loadBMI(
                                      _calculateBmiValue(latestWeight),
                                    ),
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                  TextSpan(text: '  '),
                                  _buildBMIResults(
                                    _calculateBmiValue(latestWeight),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: _buildBars(
                                _calculateBmiValue(latestWeight),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  // WeightDBLoadFailed
                  return Center(child: Text('Error loading data'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
