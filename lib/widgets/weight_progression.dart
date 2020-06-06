import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/util/util.dart';
import 'package:weight_tracker/widgets/weight_db_bloc_builder.dart';

import '../data/blocs/user_preferences_bloc/user_preferences_bloc.dart';
import '../data/models/user_data.dart';
import '../data/models/weight.dart';
import '../screens/progression_screen.dart';
import '../widgets/colored_progress_bar.dart';
import '../widgets/tile.dart';
import '../widgets/weight_date_tile.dart';

class WeightProgression extends StatelessWidget {
  final List<String> progressionText = [
    "Don't worry! It's the beginning!",
    "Keep it going!",
    "Nearly there! One last effort!",
    "In the middle!",
    "You are a bit off!",
    "You are a bit low!",
  ];

  String _getPercentageText(double percentage) {
    if (percentage < 0.25) {
      return progressionText[0];
    } else if (percentage < 0.75) {
      return progressionText[1];
    } else {
      return progressionText[2];
    }
  }

  String _getProgressText(
    double initialWeight,
    double lastWeight,
    double weightGoal,
  ) {
    if (weightGoal == lastWeight || initialWeight == weightGoal) {
      return progressionText[3];
    } else if (lastWeight > initialWeight && lastWeight > weightGoal) {
      return progressionText[4];
    } else if (lastWeight < initialWeight && lastWeight < weightGoal) {
      return progressionText[5];
    } else {
      double res =
          ((lastWeight - initialWeight) / (weightGoal - initialWeight)).abs();
      return _getPercentageText(res);
    }
  }

  double _getProgressValue(
    double initialWeight,
    double lastWeight,
    double weightGoal,
  ) {
    double res;
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
          Text(
            'Progress',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(
              context,
              ProgressionScreen.routeName,
            ),
            child: Tile(
              height: MediaQuery.of(context).size.height * 0.15,
              child: WeightDBBlocBuilder(
                onLoaded: (state) {
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

                  return BlocBuilder<UserPreferencesBloc, UserData>(
                    builder: (context, UserData prefs) {
                      // We know state user data is not empty
                      double percentage = _getProgressValue(
                        prefs.initialWeight,
                        prefs.areImperial
                            ? UnitConverter.kgToLbs(
                                weightData.first.weight,
                              )
                            : weightData.first.weight,
                        prefs.goalWeight,
                      );

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              WeightDateTile(
                                weight: prefs.initialWeight,
                                date: prefs.initialDate,
                                unit: prefs.dataUnits,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: UnitConverter.kgLbsToString(
                                        prefs.dataUnits == Unit.Metric
                                            ? weightData.first.weight
                                            : UnitConverter.kgToLbs(
                                                weightData.first.weight,
                                              ),
                                      ),
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                    TextSpan(
                                      text: prefs.dataUnits == Unit.Metric
                                          ? 'kg'
                                          : 'lb',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ],
                                ),
                              ),
                              WeightDateTile(
                                weight: prefs.goalWeight,
                                date: prefs.goalDate,
                                unit: prefs.dataUnits,
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                _getProgressText(
                                  prefs.initialWeight,
                                  prefs.areImperial
                                      ? UnitConverter.kgToLbs(
                                          weightData.first.weight,
                                        )
                                      : weightData.first.weight,
                                  prefs.goalWeight,
                                ),
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              SizedBox(height: 8.0),
                              ColoredProgressBar(percentage),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
