import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/data/blocs/chart_display_bloc/chart_button_bloc.dart';
import 'package:weight_tracker/widgets/chart_button.dart';
import 'package:weight_tracker/widgets/weight_db_bloc_builder.dart';

import '../ui/logic/chart_data_controller.dart';
import '../ui/logic/chart_manager.dart';

class WeightLineChart extends StatefulWidget {
  @override
  _WeightLineChartState createState() => _WeightLineChartState();
}

class _WeightLineChartState extends State<WeightLineChart> {
  ChartState _currentState = ChartState.OneWeek;
  final List<int> _buttonsIds = [0, 1, 2, 3];

  Widget _getChartButton({
    @required BuildContext context,
    @required int idIndex,
    @required String text,
  }) {
    return ChartButton(
      id: _buttonsIds[idIndex],
      text: text,
      activeColor: Theme.of(context).accentColor,
      onTap: () {
        setState(() => _currentState = ChartState.values[idIndex]);
        BlocProvider.of<ChartButtonBloc>(context).add(
          ChartButtonPressed(_buttonsIds[idIndex]),
        );
      },
    );
  }

  List<Widget> _buildChangeGraphButtons(
    BuildContext blocCtx,
  ) {
    // We have to create a new context since the bloc is created in
    // the same widget
    return [
      _getChartButton(
        context: blocCtx,
        idIndex: 0,
        text: '1 W',
      ),
      _getChartButton(
        context: blocCtx,
        idIndex: 1,
        text: '1 M',
      ),
      _getChartButton(
        context: blocCtx,
        idIndex: 2,
        text: '6 M',
      ),
      _getChartButton(
        context: blocCtx,
        idIndex: 3,
        text: '1 Y',
      ),
    ];
  }

  FlLine _verticalLinesFromState(double value) {
    switch (_currentState) {
      case ChartState.OneMonth:
        if (value % 5 == 0) {
          return FlLine(
            color: Colors.white24,
            strokeWidth: .5,
          );
        }
        break;
      case ChartState.SixMonths:
        if (value % 31 == 0) {
          return FlLine(
            color: Colors.white24,
            strokeWidth: .5,
          );
        }
        break;
      case ChartState.OneYear:
        if (value % 61 == 0) {
          return FlLine(
            color: Colors.white24,
            strokeWidth: .5,
          );
        }
        break;
      default:
        return FlLine(
          color: Colors.white24,
          strokeWidth: .5,
        );
        break;
    }

    return FlLine(color: Colors.transparent);
  }

  LineChartData _buildChartData(ChartManager manager) {
    // Temp variables
    double minValue =
        manager.minValue(_currentState) - manager.minMaxDiff(_currentState);
    double maxValue =
        manager.maxValue(_currentState) + manager.minMaxDiff(_currentState);

    // Recap list information
    return LineChartData(
      clipToBorder: true,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingVerticalLine: _verticalLinesFromState,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white24,
            strokeWidth: .5,
          );
        },
        horizontalInterval: manager.minMaxDiff(_currentState),
      ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          reservedSize: 12.0,
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff72719b),
            fontSize: 12.0,
          ),
          getTitles: (value) => manager.getYAxisTitles(value, _currentState),
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff5a646e),
            fontSize: 12.0,
          ),
          interval: manager.minMaxDiff(_currentState),
          getTitles: (value) {
            return !(value == minValue || value == maxValue)
                ? value.toStringAsFixed(1)
                : null;
          },
          reservedSize: 24.0,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: const Color(0xff5a646e),
          width: 1,
        ),
      ),
      minX: manager.stateData(_currentState).last.first,
      maxX: manager.maxXValue(_currentState),
      minY: minValue,
      maxY: maxValue,
      lineBarsData: _weightData(manager),
    );
  }

  List<LineChartBarData> _weightData(ChartManager manager) {
    List<FlSpot> _list = manager.stateData(_currentState).map((pair) {
      return FlSpot(
        pair.first,
        pair.second,
      );
    }).toList();

    final List<Color> gradientColors = [
      const Color(0xFFFDC830),
      const Color(0xFFF37335),
    ];

    final LineChartBarData weightData = LineChartBarData(
      spots: _list,
      isCurved: true,
      curveSmoothness: 0.2,
      colors: gradientColors,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: _currentState == ChartState.OneWeek || _currentState == ChartState.OneMonth,
        dotSize: 3.0,
      ),
      belowBarData: BarAreaData(
        show: true,
        colors: gradientColors.map((color) => color.withOpacity(0.15)).toList(),
      ),
    );
    return [weightData];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WeightDBBlocBuilder(
        onLoaded: (state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                child: Center(
                  child: Text(
                    'Weight Evolution',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: LineChart(
                  _buildChartData(
                    ChartManager(
                      ChartDataController(state.weightCollection),
                    ),
                  ),
                  swapAnimationDuration: Duration(milliseconds: 300),
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Container(
                child: BlocProvider<ChartButtonBloc>(
                  create: (_) => ChartButtonBloc(_buttonsIds),
                  child: Builder(
                    builder: (blocCtx) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _buildChangeGraphButtons(blocCtx),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
