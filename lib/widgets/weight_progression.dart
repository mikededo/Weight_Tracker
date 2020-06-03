import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weight_tracker/data/blocs/user_preferences_bloc/user_preferences_bloc.dart';
import 'package:weight_tracker/data/blocs/weight_db_bloc/weight_db_bloc.dart';
import 'package:weight_tracker/data/models/user_data.dart';
import 'package:weight_tracker/data/models/weight.dart';
import 'package:weight_tracker/screens/progression_screen.dart';
import 'package:weight_tracker/widgets/colored_progress_bar.dart';
import 'package:weight_tracker/widgets/tile.dart';
import 'package:weight_tracker/widgets/weight_date_tile.dart';

class WeightProgression extends StatelessWidget {
  final List<String> progressionText = [
    "Don't worry! It's the beginning!",
    "Keep it going!",
    "Nearly there! One last effort!",
  ];

  String _getProgressionText(double percentage) {
    if (percentage < 0.25) {
      return progressionText[0];
    } else if (percentage < 0.75) {
      return progressionText[1];
    } else {
      return progressionText[2];
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
            onTap: () =>
                Navigator.pushNamed(context, ProgressionScreen.routeName),
            child: Tile(
              height: MediaQuery.of(context).size.height * 0.15,
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
                    UserData prefs =
                        BlocProvider.of<UserPreferencesBloc>(context).state;

                    // Calculate the pecentage
                    double percentage = _getProgressValue(
                      weightData.last.weight,
                      weightData.first.weight,
                      prefs.weightGoal,
                    );
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            WeightDateTile(
                              weight: weightData.last.weight,
                              date: DateTime.now().subtract(
                                Duration(days: 27),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: weightData.first.weight
                                        .toStringAsFixed(1),
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                  TextSpan(
                                    text: 'kg',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ],
                              ),
                            ),
                            WeightDateTile(
                              weight: prefs.weightGoal,
                              date: DateTime.now(),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              _getProgressionText(percentage),
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            SizedBox(height: 8.0),
                            ColoredProgressBar(percentage),
                          ],
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
          ),
        ],
      ),
    );
  }
}
