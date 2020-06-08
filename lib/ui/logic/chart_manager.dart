import 'package:intl/intl.dart';
import 'package:weight_tracker/ui/logic/chart_data_controller.dart';
import 'package:weight_tracker/util/pair.dart';
import 'package:weight_tracker/util/util.dart';

enum ChartState {
  OneWeek,
  OneMonth,
  SixMonths,
  OneYear,
}

class ChartManager {
  /// Controller that will handle the data management
  final ChartDataController _controller;

  ChartManager(this._controller);

  /// Returns the data of the current state parsed for the graph
  List<Pair<double, double>> stateData(ChartState state) {
    switch (state) {
      case ChartState.OneWeek:
        return _controller.lastSevenDaysData;
      case ChartState.OneMonth:
        return _controller.oneMonthData;
      case ChartState.SixMonths:
        return _controller.sixMonthsData;
      default:
        return _controller.oneYearData;
    }
  }

  /// Returns the max value of the current graph state
  double maxValue(ChartState state) {
    double max;
    switch (state) {
      case ChartState.OneWeek:
        max = _controller.lastSevenDaysMaxWeight.second;
        break;
      case ChartState.OneMonth:
        max = _controller.oneMonthMaxWeight.second;
        break;
      case ChartState.SixMonths:
        max = _controller.sixMonthsMaxWeight.second;
        break;
      case ChartState.OneYear:
        max = _controller.oneYearMaxWeight.second;
        break;
    }

    return UnitConverter.doubleToFixedDecimals(max, 1);
  }

  /// Returns the min value of the current graph state
  double minValue(ChartState state) {
    double min;
    switch (state) {
      case ChartState.OneWeek:
        min = _controller.lastSevenDaysMinWeight.second;
        break;
      case ChartState.OneMonth:
        min = _controller.oneMonthMinWeight.second;
        break;
      case ChartState.SixMonths:
        min = _controller.sixMonthsMinWeight.second;
        break;
      case ChartState.OneYear:
        min = _controller.oneYearMinWeight.second;
        break;
    }

    return UnitConverter.doubleToFixedDecimals(min, 1);
  }

  /// Returns the difference between the min and the max value
  /// of the current graph state divided by 2
  double minMaxDiff(ChartState state) =>
      (maxValue(state) - minValue(state)) / 2;

  /// Returns the current graph state data length
  double totalDays(ChartState state) {
    switch (state) {
      case ChartState.OneWeek:
        return 6;
      case ChartState.OneMonth:
        return 30;
      case ChartState.SixMonths:
        return 186;
      default:
        return 365;
    }
  }

  //! Y TITLE MANAGEMENT
  /// Returns the y axis values to display coming from the graph itself
  String getYAxisTitles(double value, ChartState state) {
    switch (state) {
      case ChartState.OneWeek:
        return _oneWeekYTitle(value);
      case ChartState.OneMonth:
        return _oneMonthYTitle(value);
      case ChartState.SixMonths:
        return _sixMonthYTitle(value);
      default:
        return _oneYearYTitle(value);
    }
  }

  /// Returns the y value when the state is [OneWeek]
  String _oneWeekYTitle(double value) {
    // DateTime.now() would work as well
    DateTime timestamp = _controller.todayDate.subtract(
      Duration(
        days: (6 - value).floor(),
      ),
    );
    return !(timestamp.isAtSameMomentAs(
              _controller.lastSevenDaysFirstDate,
            ) ||
            timestamp.isAtSameMomentAs(
              _controller.todayDate,
            ))
        ? DateFormat('d/M').format(timestamp)
        : null;
  }

  /// Returns the y value when the state is [OneMonth]
  String _oneMonthYTitle(double value) {
    DateTime timestamp = _controller.todayDate.subtract(
      Duration(
        days: (6 - value).floor(),
      ),
    );
    return (timestamp.day % 7 == 0)
        ? DateFormat('d/M').format(timestamp)
        : null;
  }

  /// Returns the y value when the state is [OneMonth]
  String _sixMonthYTitle(double value) {
    DateTime timestamp = _controller.todayDate.subtract(
      Duration(
        days: (6 - value).floor(),
      ),
    );
    return (timestamp.day % 16 == 0)
        ? DateFormat('MMM').format(timestamp)
        : null;
  }

  /// Returns the y value when the state is [OneMonth]
  String _oneYearYTitle(double value) {
    DateTime timestamp = _controller.todayDate.subtract(
      Duration(
        days: (6 - value).floor(),
      ),
    );
    return (timestamp.day == 15 && (timestamp.month % 4) == 0)
        ? DateFormat('MMM').format(timestamp)
        : null;
  }
}
