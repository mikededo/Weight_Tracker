import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:weight_tracker/util/util.dart';
import 'package:weight_tracker/widgets/weight_db_bloc_builder.dart';

import '../data/models/chart_data_controller.dart';

class WeightLineChart extends StatelessWidget {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  LineChartData _buildChartData(ChartDataController dataController) {
    print(dataController.lastSevenDaysFirstDate.month.floorToDouble());
    print(dataController.lastSevenDaysLastDate.month.floorToDouble());
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
          getTitles: (value) {
            // Calculate value's day
            DateTime timestamp = dataController.lastSevenDaysLastDate.subtract(
              Duration(
                days: (6 - value).floor(),
              ),
            );

            return DateFormat('d/M').format(timestamp);
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff5a646e),
            fontSize: 12.0,
          ),
          interval: dataController.minMaxDiff * 2,
          getTitles: (value) {
            return value.toStringAsFixed(1);
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
      minY: UnitConverter.doubleToFixedDecimals(
        dataController.minWeight.second - dataController.minMaxDiff,
        1,
      ),
      maxY: UnitConverter.doubleToFixedDecimals(
        dataController.maxWeight.second + dataController.minMaxDiff,
        1,
      ),
      lineBarsData: _weightData(dataController),
    );
  }

  List<LineChartBarData> _weightData(ChartDataController dataController) {
    List<FlSpot> _list = dataController.lastSevenDays
        .map(
          (pair) => FlSpot(
            pair.first,
            pair.second,
          ),
        )
        .toList();

    final LineChartBarData weightData = LineChartBarData(
      spots: _list,
      isCurved: false,
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
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      child: WeightDBBlocBuilder(
        onLoaded: (state) {
          return LineChart(
            _buildChartData(ChartDataController(state.weightCollection)),
            swapAnimationDuration: const Duration(milliseconds: 250),
          );
        },
      ),
    );
  }
}
