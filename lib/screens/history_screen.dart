import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/weight.dart';
import '../data/blocs/weight_db_bloc/weight_db_bloc.dart';
import '../screens/add_weight_screen.dart';
import '../util/util.dart';
import '../widgets/history_tile.dart';
import '../widgets/screen_header.dart';

class HistoryScreen extends StatelessWidget {
  static const String routeName = '/history_screen';

  void _deleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          title: Text(
            'Delete all data',
            style: TextStyle(color: textWhiteColor),
          ),
          content: Text(
            'This action is irreversible. Are you sure?',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          contentPadding: const EdgeInsets.only(
            top: 8.0,
            left: 24.0,
            right: 24.0,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'YES',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: () {
                BlocProvider.of<WeightDBBloc>(context)
                    .add(WeightDBDeletedAll());
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'NO',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ScreenHeader(text: 'Weight history'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'All',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  FlatButton(
                    onPressed: () => _deleteAllDialog(context),
                    child: Text(
                      'Delete All',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<WeightDBBloc, WeightDBState>(
                  builder: (context, state) {
                    if (state is WeightDBLoadInProgress ||
                        state is WeightDBInitial) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is WeightDBLoadSuccess) {
                      /// Data already sorted
                      List<WeightData> list = state.weightCollection;

                      if (list.isEmpty) {
                        return Center(
                          child: Text(
                            'Start adding \na weight!',
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.center,
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
                                extended: true,
                              );
                            } else {
                              return HistoryTile(
                                weightData: list[index],
                                prevWeightData: list[index + 1],
                                extended: true,
                              );
                            }
                          },
                          itemCount: list.length,
                        );
                      }
                    } else {
                      return Center(child: Text('Failed loading data'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.pushNamed(context, AddWeightScreen.routeName),
        backgroundColor: Theme.of(context).accentColor,
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            'NEW WEIGHT',
            style: Theme.of(context).textTheme.button,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
