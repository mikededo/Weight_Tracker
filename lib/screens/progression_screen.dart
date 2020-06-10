import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/data/blocs/chart_display_bloc/chart_button_bloc.dart';
import 'package:weight_tracker/data/models/weight.dart';
import 'package:weight_tracker/widgets/user_statistics.dart';
import 'package:weight_tracker/widgets/tile.dart';
import 'package:weight_tracker/widgets/weight_db_bloc_builder.dart';
import 'package:weight_tracker/widgets/weight_line_chart.dart';

import '../widgets/default_page_layout.dart';
import '../widgets/screen_header.dart';

class ProgressionScreen extends StatelessWidget {
  static const String routeName = '/progression_string';

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

  int _calculateWeightStreak(List<WeightData> items) {
    DateTime lastDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    int count = 0;

    for (WeightData data in items) {
      if (data.date.difference(lastDate).inDays > 0 &&
          data.date.isAfter(lastDate)) {
        break;
      }

      DateTime temp = DateTime(
        data.date.year,
        data.date.month,
        data.date.day,
      );
      Duration diff = lastDate.difference(temp);

      if (count == 0) {
        if (diff.inDays == 0 || diff.inDays == 1 || diff.inDays == 2) {
          count++;
        } else {
          break;
        }
      } else {
        if (diff.inDays == 1) {
          count++;
        } else {
          break;
        }
      }

      lastDate = temp;
    }

    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultPageLayout(
        child: WeightDBBlocBuilder(
          onLoaded: (state) {
            int streak = _calculateWeightStreak(state.weightCollection);
            return BlocProvider<ChartButtonBloc>(
              create: (_) => ChartButtonBloc([0, 1, 2, 3]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ScreenHeader(
                    text: 'Progress',
                  ),
                  Tile(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    hasBackground: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Current Streak:',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          '${streak.toString()} ${_getIcon(streak)}',
                          style: Theme.of(context).textTheme.headline5,
                        )
                      ],
                    ),
                  ),
                  Text(
                    'Progress Chart',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Tile(
                    margin: const EdgeInsets.only(top: 12.0),
                    child: WeightLineChart(state.weightCollection),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'More Information',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12.0),
                    height: MediaQuery.of(context).size.height * 0.375,
                    child: UserStatistics(state.weightCollection),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
