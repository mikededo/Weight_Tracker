import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weight_tracker/data/blocs/user_preferences_bloc/user_preferences_bloc.dart';
import 'package:weight_tracker/data/blocs/weight_db_bloc/weight_db_bloc.dart';
import 'package:weight_tracker/data/models/user_data.dart';
import 'package:weight_tracker/data/models/weight.dart';
import 'package:weight_tracker/widgets/colored_progress_bar.dart';
import 'package:weight_tracker/widgets/tile.dart';

class WeightProgression extends StatelessWidget {
  double _getProgressValue(
    double initialWeight,
    double lastWeight,
    double weightGoal,
  ) {
    double res;
    print('20. $initialWeight');
    print('21. $lastWeight');
    print('22. $weightGoal');

    if (weightGoal == lastWeight || initialWeight == weightGoal) {
      return 1;
    } else if (lastWeight > initialWeight && lastWeight > weightGoal) {
      return 1;
    } else if (lastWeight < initialWeight && lastWeight < weightGoal) {
      return 1;
    } else {
      res = ((lastWeight - initialWeight) / (weightGoal - initialWeight)).abs();
    }
    
    return (res * 100).ceilToDouble() / 100;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Progress',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              FlatButton(
                onPressed: () => print('pressed'),
                child: Text(
                  'See All',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          ),
          Tile(
            height: MediaQuery.of(context).size.height * 0.13,
            child: BlocBuilder<WeightDBBloc, WeightDBState>(
              builder: (context, state) {
                if (state is WeightDBLoadInProgress ||
                    state is WeightDBInitial) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is WeightDBLoadSuccess) {
                  if (state.weightCollection.isEmpty) {
                    return Center(
                      child: Text(
                        'Add a weight to check your progress!',
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  // Weight collection from state is not empty
                  final List<WeightData> weightData = state.weightCollection;
                  // User data has been loaded on start - prefs can't be deleted
                  // State is not empty
                  UserData prefs =
                      BlocProvider.of<UserPreferencesBloc>(context).state;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                '${weightData.last.weight.toStringAsFixed(1)}kg',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              SizedBox(height: 2.0),
                              Text(
                                DateFormat('d/M/yy').format(
                                  DateTime.now().subtract(
                                    Duration(days: 27),
                                  ),
                                ),
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: weightData.first.weight.toStringAsFixed(1),
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                TextSpan(
                                  text: 'kg',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                '${prefs.weightGoal}kg',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              SizedBox(height: 2.0),
                              Text(
                                DateFormat('d/M/yy').format(DateTime.now()),
                                style: Theme.of(context).textTheme.subtitle2,
                              )
                            ],
                          )
                        ],
                      ),
                      ColoredProgressBar(
                        _getProgressValue(
                          weightData.last.weight,
                          weightData.first.weight,
                          prefs.weightGoal,
                        ),
                      ),
                    ],
                  );
                } else {
                  // WeightBDLoadFailure
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
