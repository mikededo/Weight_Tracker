import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:weight_tracker/data/models/weight.dart';
import 'package:weight_tracker/util/util.dart';
import 'package:weight_tracker/widgets/weight_db_bloc_builder.dart';

import '../data.dart';
import '../data/models/chart_data_controller.dart';

class WeightLineChart extends StatelessWidget {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  LineChartData _buildChartData(ChartDataController dataController) {
    // Recap list information
    return LineChartData(
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
            DateTime timestamp = DateTime.now().subtract(
              Duration(
                days: (dataController.length - value).floor(),
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
      minX: dataController.firstDate.month.floorToDouble() - 5,
      maxX: dataController.lastDate.month.floorToDouble(),
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

  List<LineChartBarData> _weightData(ChartDataController chartData) {
    List<FlSpot> _list = chartData.lastSevenDays
        .map(
          (pair) => FlSpot(
            pair.first,
            pair.second,
          ),
        )
        .toList();

    final LineChartBarData weightData = LineChartBarData(
      spots: _list.sublist(0, 7),
      isCurved: true,
      colors: gradientColors,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
        colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
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
