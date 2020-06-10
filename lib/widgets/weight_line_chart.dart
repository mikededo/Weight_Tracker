import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/data/blocs/chart_display_bloc/chart_button_bloc.dart';
import 'package:weight_tracker/data/blocs/user_preferences_bloc/user_preferences_bloc.dart';
import 'package:weight_tracker/util/util.dart';
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

  FlLine _verticalLinesFromState(ChartManager manager, double value) {
    bool getLine = false;
    switch (_currentState) {
      case ChartState.OneMonth:
        getLine = manager.oneMonthVerticalLine(_currentState, value);
        break;
      case ChartState.SixMonths:
        getLine = manager.sixMonthsVerticalLine(_currentState, value);
        break;
      case ChartState.OneYear:
        getLine = manager.oneYearVerticalLine(_currentState, value);
        break;
      default:
        return FlLine(
          color: Colors.white24,
          strokeWidth: .5,
        );
        break;
    }

    return getLine
        ? FlLine(
            color: Colors.white24,
            strokeWidth: .5,
          )
        : FlLine(color: Colors.transparent);
  }

  LineChartData _buildChartData(ChartManager manager) {
    // Check if it is in imperial
    bool metric = BlocProvider.of<UserPreferencesBloc>(context).state.areMetric;

    // Temp variables
    double minValue;
    double maxValue;

    // Check if we need to change the values
    if (!metric) {
      minValue = UnitConverter.kgToLbs(manager.minValue(_currentState)) -
          UnitConverter.kgToLbs(manager.minMaxDiff(_currentState));
      maxValue = UnitConverter.kgToLbs(manager.maxValue(_currentState)) +
          UnitConverter.kgToLbs(manager.minMaxDiff(_currentState));
    } else {
      minValue =
          manager.minValue(_currentState) - manager.minMaxDiff(_currentState);
      maxValue =
          manager.maxValue(_currentState) + manager.minMaxDiff(_currentState);
    }

    // Recap list information
    return LineChartData(
      clipToBorder: true,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingVerticalLine: (value) => _verticalLinesFromState(
          manager,
          value,
        ),
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white24,
            strokeWidth: .5,
          );
        },
        horizontalInterval: metric
            ? manager.minMaxDiff(_currentState)
            : UnitConverter.kgToLbs(manager.minMaxDiff(_currentState)),
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
          textStyle:
              Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 12.0),
          getTitles: (value) => manager.getYAxisTitles(_currentState, value),
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle:
              Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 12.0),
          interval: metric
              ? manager.minMaxDiff(_currentState)
              : UnitConverter.kgToLbs(manager.minMaxDiff(_currentState)),
          getTitles: (value) {
            return !(value == minValue || value == maxValue)
                ? value.toStringAsFixed(1)
                : null;
          },
          margin: 8.0,
          reservedSize: 28.0,
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
    // Check if it is in imperial
    bool metric = BlocProvider.of<UserPreferencesBloc>(context).state.areMetric;

    List<FlSpot> _list = manager.stateData(_currentState).map((pair) {
      return FlSpot(
        pair.first,
        metric
            ? pair.second
            : UnitConverter.doubleToFixedDecimals(
                UnitConverter.kgToLbs(pair.second),
                1,
              ),
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
        show: _currentState == ChartState.OneWeek ||
            _currentState == ChartState.OneMonth,
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
                      mainAxisAlignment: MainAxisAlignment.end,
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
