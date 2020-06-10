import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weight_tracker/data/blocs/chart_display_bloc/chart_button_bloc.dart';
import 'package:weight_tracker/data/blocs/user_preferences_bloc/user_preferences_bloc.dart';
import 'package:weight_tracker/data/models/weight.dart';
import 'package:weight_tracker/ui/logic/chart_data_controller.dart';
import 'package:weight_tracker/ui/logic/chart_manager.dart';
import 'package:weight_tracker/util/util.dart';
import 'package:weight_tracker/widgets/configuration_tile.dart';

class UserStatistics extends StatefulWidget {
  final List<WeightData> state;
  final ChartManager manager;

  UserStatistics(this.state)
      : manager = ChartManager(ChartDataController(state));

  @override
  _UserStatisticsState createState() =>
      _UserStatisticsState();
}

class _UserStatisticsState extends State<UserStatistics> {
  final List<String> _streakIcons = [
    '❄️',
    '🔥',
    '💯',
  ];

  String _getIcon(int streak) {
    if (streak >= 0 && streak < 7) {
      return _streakIcons[0];
    } else if (streak == 100) {
      return _streakIcons[2];
    } else {
      return _streakIcons[1];
    }
  }

  String _stringFromState(ChartState state) {
    switch (state) {
      case ChartState.OneWeek:
        return 'One Week';
      case ChartState.OneMonth:
        return 'One Month';
      case ChartState.SixMonths:
        return 'Six Months';
      default:
        return 'One Year';
    }
  }

  String _getHighestStreakValue() {
    int count = 1;
    int maxCount = -1;
    List<WeightData> items = widget.state;
    for (int i = 0; i < items.length - 1; i++) {
      if (items[i].date.difference(items[i + 1].date).inDays <= 1) {
        count++;
      } else {
        if (count > maxCount) {
          maxCount = count;
          count = 1;
        }
      }
    }

    return '${maxCount.toString()} ${_getIcon(maxCount)}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartButtonBloc, int>(
      builder: (_, state) {
        bool metric =
            BlocProvider.of<UserPreferencesBloc>(context).state.areMetric;
        ChartState chartState = ChartState.values[state];
        ChartManager manager = widget.manager;
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: <Widget>[
              ConfigurationTile(
                title: 'Max Weight',
                subtitle: '${_stringFromState(chartState)} Period',
                trailing: Text(
                  metric
                      ? UnitConverter.kgToStringRich(
                          manager.maxValue(chartState),
                        )
                      : UnitConverter.lbsToStringRich(
                          UnitConverter.kgToLbs(manager.maxValue(chartState)),
                        ),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              ConfigurationTile(
                title: 'Min Weight',
                subtitle: '${_stringFromState(chartState)} Period',
                trailing: Text(
                  metric
                      ? UnitConverter.kgToStringRich(
                          manager.minValue(chartState),
                        )
                      : UnitConverter.lbsToStringRich(
                          UnitConverter.kgToLbs(manager.minValue(chartState)),
                        ),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              ConfigurationTile(
                title: 'First Weight Added',
                subtitle:
                    DateFormat('dd/MM/yyyy').format(manager.firstData.date),
                trailing: Text(
                  metric
                      ? UnitConverter.kgToStringRich(
                          manager.firstData.weight,
                        )
                      : UnitConverter.lbsToStringRich(
                          UnitConverter.kgToLbs(manager.firstData.weight),
                        ),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              ConfigurationTile(
                title: 'Last Weight Added',
                subtitle:
                    DateFormat('dd/MM/yyyy').format(manager.lastData.date),
                trailing: Text(
                  metric
                      ? UnitConverter.kgToStringRich(
                          manager.lastData.weight,
                        )
                      : UnitConverter.lbsToStringRich(
                          UnitConverter.kgToLbs(manager.lastData.weight),
                        ),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              ConfigurationTile(
                title: 'Highest Streak',
                trailing: Text(
                  _getHighestStreakValue(),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              ConfigurationTile(
                title: 'Total Data',
                trailing: Text(
                  manager.dataLength.toString(),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
