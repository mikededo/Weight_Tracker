import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/weight.dart';
import '../data/blocs/weight_bloc/weight_bloc.dart';
import '../screens/history_screen.dart';
import '../widgets/history_tile.dart';

class WeightHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (_, constraints) {
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: constraints.maxHeight * 0.15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'History',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      FlatButton(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(HistoryScreen.routeName),
                        child: Text(
                          'See All',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.05,
                ),
                Container(
                  height: constraints.maxHeight * 0.8,
                  child: BlocBuilder<WeightBloc, WeightState>(
                    builder: (context, state) {
                      print(state);
                      if (state is WeightLoadInProgress ||
                          state is WeightInitial) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is WeightLoadSuccess) {
                        // Get data list
                        List<WeightData> list = state.weightCollection;

                        if (list.isEmpty) {
                          return Center(
                            child: Text(
                              'Start adding a weight!',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          );
                        } else {
                          return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (_, index) {
                              if (index == list.length - 1) {
                                return HistoryTile(
                                  weightData: list[index],
                                  prevWeightData: null,
                                );
                              } else {
                                return HistoryTile(
                                  weightData: list[index],
                                  prevWeightData: list[index + 1],
                                );
                              }
                            },
                            itemCount: list.length < 7 ? list.length : 7,
                          );
                        }
                      } else {
                        // WeightLoadFailure
                        return Center(child: Text('Error on loading data'));
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
