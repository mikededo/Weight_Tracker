import 'package:weight_tracker/data/models/weight.dart';
import 'package:weight_tracker/util/pair.dart';

import 'chart_data.dart';

class ChartDataController extends ChartData {
  bool _lastSevenDaysLoaded = false;
  bool _oneMonthLoaded = false;
  bool _twoMonthLoaded = false;
  bool _halfYearLoaded = false;
  bool _allTimeLoaded = false;

  ChartDataController(List<WeightData> data) : super(data);

  //!LOAD CHECKERS
  /// Checks if all time data has been loaded and if not it
  /// loads it
  void _checkAllTimeLoaded() {
    if (!_allTimeLoaded) {
      loadAllTimeData();
      _allTimeLoaded = true;
    }
  }

  /// Checks if last seven days data has been loaded and if
  /// not it loads it
  void _checkLastSevenDaysLoaded() {
    if (!_lastSevenDaysLoaded) {
      loadSevenDaysData();
      _lastSevenDaysLoaded = true;
    }
  }

  //! CORE FUNCTIONS
  /// Returns data length
  int get length {
    _checkAllTimeLoaded();
    return super.length;
  }

  /// Returns the data of the entire list parsed for the graph
  List<Pair<double, double>> get allTimeData {
    _checkAllTimeLoaded();
    return super.allTimeData;
  }

  /// Returns max weight and its index of the entire data
  Pair<int, double> get maxWeight {
    _checkAllTimeLoaded();
    return super.maxWeight;
  }

  /// Returns min weight and its index of the entire data
  Pair<int, double> get minWeight {
    _checkAllTimeLoaded();
    return super.minWeight;
  }

  /// Returns the weight difference between the max and min of the
  /// entire list
  double get minMaxDiff {
    _checkAllTimeLoaded();

    return super.minMaxDiff;
  }

  /// Returns the data of the last seven days parsed for the graph
  List<Pair<double, double>> get lastSevenDays {
    _checkLastSevenDaysLoaded();
    return super.lastSevenDays;
  }

  /// Returns the data of the max weight and its index relative to
  /// [lastSevenDays] list
  Pair<int, double> get lastSevenDaysMaxWeight {
    _checkLastSevenDaysLoaded();
    return super.lastSevenDaysMaxWeight;
  }

  /// Returns the data of the min weight and its index relative to
  /// [lastSevenDays] list
  Pair<int, double> get lastSevenDaysMinWeight {
    _checkLastSevenDaysLoaded();
    return super.lastSevenDaysMinWeight;
  }

  /// Returns the weight difference between the max and min of the
  /// entire list
  double get sevenDaysMinMaxDiff {
    _checkLastSevenDaysLoaded();
    return super.sevenDaysMinMaxDiff;
  }
}
