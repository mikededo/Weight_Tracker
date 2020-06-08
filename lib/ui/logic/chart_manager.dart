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

  /// Current State of the data, initialised as OneWeek
  ChartState _currentState;

  ChartManager(this._controller, [this._currentState = ChartState.OneWeek]);

  /// Changes the state
  set changeState(ChartState newState) => _currentState = newState;

  /// Returns the max value of the current graph state
  double get maxValue {
    double max;
    switch (_currentState) {
      case ChartState.OneWeek:
        max = _controller.lastSevenDaysMaxWeight.second;
        break;
      case ChartState.OneMonth:
        break;
      // max = _controller.onMonthMaxWeight.second;
      case ChartState.SixMonths:
        // max = _controller.sixMonthsMaxWeight.second;
        break;
      case ChartState.OneYear:
        max = _controller.allTimeMaxWeight.second;
        break;
    }

    return UnitConverter.doubleToFixedDecimals(max, 1);
  }

  /// Returns the min value of the current graph state
  double get minValue {
    double min;
    print(_currentState);
    switch (_currentState) {
      case ChartState.OneWeek:
        min = _controller.lastSevenDaysMinWeight.second;
        break;
      case ChartState.OneMonth:
        min = _controller.oneMonthMaxWeight.second;
        break;
      case ChartState.SixMonths:
        min = _controller.sixMonthsMaxWeight.second;
        break;
      case ChartState.OneYear:
        min = _controller.allTimeMinWeight.second;
        break;
    }

    return UnitConverter.doubleToFixedDecimals(min, 1);
  }

  /// Returns the difference between the min and the max value
  /// of the current graph state divided by 2
  double get minMaxDiff => (maxValue - minValue) / 2;

  /// Returns the data of the current state parsed for the graph
  List<Pair<double, double>> get stateData {
    switch (_currentState) {
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

  /// Returns the current graph state data length
  double get totalDays {
    switch (_currentState) {
      case ChartState.OneWeek:
        return 6;
      case ChartState.OneMonth:
        return 30;
      case ChartState.SixMonths:
        return 30.0 * 6;
      default:
        return 365;
    }
  }

  //! Y TITLE MANAGEMENT
  /// Returns the y axis values to display coming from the graph itself
  String getYAxisTitles(double value) {
    switch (_currentState) {
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
    return (timestamp.day == 7) ? DateFormat('d/M').format(timestamp) : null;
  }

  /// Returns the y value when the state is [OneMonth]
  String _sixMonthYTitle(double value) {
    DateTime timestamp = _controller.todayDate.subtract(
      Duration(
        days: (6 - value).floor(),
      ),
    );
    return (timestamp.day == 15) ? DateFormat('MMM').format(timestamp) : null;
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

/* 

 switch (_currentState) {
      case ChartState.OneWeek:
        break;
      case ChartState.OneMonth:
        break;
      case ChartState.SixMonths:
        break;
      case ChartState.OneYear:
        break;
    }
 */
