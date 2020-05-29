import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weight_tracker/data.dart';

class WeightLineChart extends StatelessWidget {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  LineChartData _buildChartData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff72719b),
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1';
              case 4:
                return '4';
              case 8:
                return '8';
              case 12:
                return '12';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff5a646e),
            fontSize: 12.0,
          ),
          getTitles: (value) {
            if (value == Data.minWeight().floorToDouble() - 1) {
              return '${Data.minWeight().floorToDouble().toInt()} kg';
            } else if (value == Data.maxWeight().floorToDouble() + 1) {
              return '${Data.maxWeight().floorToDouble().toInt()} kg';
            }
            return '';
          },
          reservedSize: 32.0,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          left: BorderSide(
            color: const Color(0xff37434d),
            width: 1,
          ),
        ),
      ),
      minX: Data.minMonth,
      maxX: Data.maxMonth,
      minY: Data.minWeight().floorToDouble() - 2,
      maxY: Data.maxWeight().floorToDouble() + 2,
      lineBarsData: _weightData(),
    );
  }

  List<LineChartBarData> _weightData() {
    List<FlSpot> _list = [];
    for (int i = 0; i < Data.length; i++) {
      _list.add(
        FlSpot(Data.pairOf(i).s, Data.pairOf(i).f),
      );
    }

    final LineChartBarData weightData = LineChartBarData(
      spots: _list,
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
      child: LineChart(
        _buildChartData(),
        swapAnimationDuration: const Duration(milliseconds: 250),
      ),
    );
  }
}
