import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weight_tracker/data/blocs/user_preferences_bloc/user_preferences_bloc.dart';
import 'package:weight_tracker/data/blocs/weight_db_bloc/weight_db_bloc.dart';
import 'package:weight_tracker/data/models/user_data.dart';
import 'package:weight_tracker/data/models/weight.dart';
import 'package:weight_tracker/widgets/tile.dart';

class WeightProgression extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.18,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Progress',
            style: Theme.of(context).textTheme.subtitle1,
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
                  final List<WeightData> data = state.weightCollection;
                  // User data has been loaded on start - prefs can't be deleted
                  // State is not empty 
                  UserData prefs = BlocProvider.of<UserPreferencesBloc>(context).state;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                '70kg',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              SizedBox(height: 2.0),
                              Text(
                                DateFormat('d-M-yy').format(
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
                                  text: data.last.weight.toString(),
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
                                DateFormat('d-M-yy').format(DateTime.now()),
                                style: Theme.of(context).textTheme.subtitle2,
                              )
                            ],
                          )
                        ],
                      ),
                      Stack(
                        children: <Widget>[
                          LayoutBuilder(
                            builder: (_, constraints) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                width: constraints.maxWidth,
                                height: 4.0,
                              );
                            },
                          ),
                          LayoutBuilder(
                            builder: (_, constraints) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                width: constraints.maxWidth,
                                height: 4,
                              );
                            },
                          ),
                          LayoutBuilder(
                            builder: (_, constraints) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                width: constraints.maxWidth * 0.5,
                                height: 4,
                              );
                            },
                          ),
                        ],
                      )
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
