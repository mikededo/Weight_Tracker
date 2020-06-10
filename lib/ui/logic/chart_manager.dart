import 'package:intl/intl.dart';
import 'package:weight_tracker/data/models/weight.dart';
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

  //! DATE CONSTANTS
  static const weekDays = 7;
  static const monthDays = 31;
  static const sixMonthsDays = 186;
  static const oneYearDays = 365;

  /// Returns the all time first data
  WeightData get firstData => _controller.firstData;

  /// Returns the all time last data
  WeightData get lastData => _controller.lastData;

  /// Returns the total data length
  int get dataLength => _controller.dataLength;

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
  double maxXValue(ChartState state) {
    switch (state) {
      case ChartState.OneWeek:
        return (weekDays - 1).toDouble();
      case ChartState.OneMonth:
        return (monthDays - 1).toDouble();
      case ChartState.SixMonths:
        return (sixMonthsDays - 1).toDouble();
      default:
        return (oneYearDays - 1).toDouble();
    }
  }

  /// Returns the date difference between the first and last
  /// item of the state data in days
  int dayDifference(ChartState state) {
    switch (state) {
      case ChartState.OneMonth:
        return (_controller.oneMonthData.first.first -
                _controller.oneMonthData.last.first)
            .floor();
      case ChartState.SixMonths:
        return (_controller.sixMonthsData.first.first -
                _controller.sixMonthsData.last.first)
            .floor();
      case ChartState.OneYear:
        return (_controller.oneYearData.first.first -
                _controller.oneYearData.last.first)
            .floor();
      default:
        return weekDays;
    }
  }

  //! Y TITLE MANAGEMENT
  bool oneMonthVerticalLine(ChartState state, double value) {
    if (dayDifference(state) <= monthDays / 2) {
      return value % 3 == 0;
    } else {
      return value % 5 == 0;
    }
  }

  bool sixMonthsVerticalLine(ChartState state, double value) {
    int diff = dayDifference(state);

    // All cases
    if (diff <= weekDays) {
      return true;
    } else if (diff <= monthDays) {
      return oneMonthVerticalLine(state, value);
    } else {
      if (diff <= sixMonthsDays / 4) {
        return value % 5 == 0;
      } else if (diff <= sixMonthsDays / 2) {
        return value % 15 == 0;
      } else if (diff <= sixMonthsDays * 0.75) {
        return value % 17 == 0;
      } else {
        return value % 30 == 0;
      }
    }
  }

  bool oneYearVerticalLine(ChartState state, double value) {
    int diff = dayDifference(state);

    // All cases
    if (diff < sixMonthsDays) {
      return sixMonthsVerticalLine(state, value);
    } else {
      if (diff < oneYearDays * 0.625) {
        return value % 32 == 0;
      } else if (diff < oneYearDays * 0.75) {
        return value % 40 == 0;
      } else if (diff < oneYearDays * 0.825) {
        return value % 50 == 0;
      } else {
        return value % 60 == 0;
      }
    }
  }

  /// Returns the y axis values to display coming from the graph itself
  String getYAxisTitles(ChartState state, double value) {

    switch (state) {
      case ChartState.OneWeek:
        return _oneWeekYTitle(value);
      case ChartState.OneMonth:
        return _oneMonthYTitle(state, value);
      case ChartState.SixMonths:
        return _sixMonthYTitle(state, value);
      default:
        return _oneYearYTitle(state, value);
    }
  }

  /// Returns the y value when the state is [OneWeek]
  String _oneWeekYTitle(double value) {
    // DateTime.now() would work as well
    DateTime timestamp = _controller.todayDate.subtract(
      Duration(
        days: (weekDays - value - 1).floor(),
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
  String _oneMonthYTitle(ChartState state, double value) {
    DateTime timestamp = _controller.todayDate.subtract(
      Duration(
        days: (monthDays - value - 1).floor(),
      ),
    );
    return oneMonthVerticalLine(state, value) ? DateFormat('d/M').format(timestamp) : null;
  }

  /// Returns the y value when the state is [OneMonth]
  String _sixMonthYTitle(ChartState state, double value) {
    DateTime timestamp = _controller.todayDate.subtract(
      Duration(
        days: (sixMonthsDays - value - 1).floor(),
      ),
    );
    return sixMonthsVerticalLine(state, value)
        ? DateFormat('MMM').format(timestamp)
        : null;
  }

  /// Returns the y value when the state is [OneMonth]
  String _oneYearYTitle(ChartState state, double value) {
    DateTime timestamp = _controller.todayDate.subtract(
      Duration(
        days: (oneYearDays - value - 1).floor(),
      ),
    );
    return oneYearVerticalLine(state, value)
          ? DateFormat('MMM').format(timestamp)
          : null;
  }
}
