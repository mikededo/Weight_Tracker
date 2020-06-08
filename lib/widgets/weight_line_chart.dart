import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weight_tracker/widgets/chart_button.dart';
import 'package:weight_tracker/widgets/weight_db_bloc_builder.dart';

import '../ui/logic/chart_data_controller.dart';
import '../ui/logic/chart_manager.dart';

class WeightLineChart extends StatefulWidget {
  @override
  _WeightLineChartState createState() => _WeightLineChartState();
}

class _WeightLineChartState extends State<WeightLineChart> {
  List<Widget> _buildChangeGraphButtons() {
    return [
      ChartButton(
        text: '1 W',
        activeColor: Theme.of(context).accentColor,
        onTap: () => print('pressed'),
      ),
      ChartButton(
        text: '1 M',
        activeColor: Theme.of(context).accentColor,
        onTap: () => print('pressed'),
      ),
      ChartButton(
        text: '6 M',
        activeColor: Theme.of(context).accentColor,
        onTap: () => print('pressed'),
      ),
      ChartButton(
        text: '1 Y',
        activeColor: Theme.of(context).accentColor,
        onTap: () => print('pressed'),
      ),
    ];
  }

  LineChartData _buildChartData(ChartManager manager) {
    // Temp variables
    double minValue = manager.minValue - manager.minMaxDiff;
    double maxValue = manager.maxValue + manager.minMaxDiff;

    // Recap list information
    return LineChartData(
      clipToBorder: true,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white24,
            strokeWidth: .5,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white24,
            strokeWidth: .5,
          );
        },
        horizontalInterval: manager.minMaxDiff,
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
          getTitles: manager.getYAxisTitles,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff5a646e),
            fontSize: 12.0,
          ),
          interval: manager.minMaxDiff,
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
      minX: 0,
      maxX: 6,
      minY: minValue,
      maxY: maxValue,
      lineBarsData: _weightData(manager),
    );
  }

  List<LineChartBarData> _weightData(ChartManager manager) {
    List<FlSpot> _list = manager.stateData
        .map(
          (pair) => FlSpot(
            pair.first,
            pair.second,
          ),
        )
        .toList();

    final List<Color> gradientColors = [
      const Color(0xFFFDC830),
      const Color(0xFFF37335),
    ];

    final LineChartBarData weightData = LineChartBarData(
      spots: _list,
      isCurved: true,
      colors: gradientColors,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
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
                  _buildChartData(ChartManager(ChartDataController(state.weightCollection),),),
                  swapAnimationDuration: const Duration(milliseconds: 250),
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _buildChangeGraphButtons(),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
