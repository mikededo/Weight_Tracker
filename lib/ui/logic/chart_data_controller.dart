import 'package:weight_tracker/data/models/weight.dart';
import 'package:weight_tracker/util/pair.dart';

import 'chart_data.dart';

class ChartDataController extends ChartData {
  bool _lastSevenDaysLoaded = false;
  bool _oneMonthLoaded = false;
  bool _sixMonthsLoaded = false;
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

  /// Checks if the last one month data has been loaded and 
  /// if not it loads it
  void _checkOneMonthLoaded() {
    if (!_oneMonthLoaded) {
      // loadOneMonthData();
      _oneMonthLoaded = true;
    }
  }

  /// Checks if the last six months data has been loaded and 
  /// if not it loads it
  void _checkSixMonthsLoaded() {
    if (!_sixMonthsLoaded) {
      // loadSixMonthsData();
      _sixMonthsLoaded = true;
    }
  }

  /// Checks if the last year data has been loaded and 
  /// if not it loads it
  void _checkOneYearLoaded() {
    if (!_sixMonthsLoaded) {
      // loadSixMonthsData();
      _sixMonthsLoaded = true;
    }
  }

  //! CORE FUNCTIONS
  /// Returns data length
  int get length {
    _checkAllTimeLoaded();
    return super.length;
  }

  //! ALL TIME
  /// Returns the data of the entire list parsed for the graph
  List<Pair<double, double>> get allTimeData {
    _checkAllTimeLoaded();
    return super.allTimeData;
  }

  /// Returns max weight and its index of the entire data
  Pair<int, double> get allTimeMaxWeight {
    _checkAllTimeLoaded();
    return super.allTimeMaxWeight;
  }

  /// Returns min weight and its index of the entire data
  Pair<int, double> get allTimeMinWeight {
    _checkAllTimeLoaded();
    return super.allTimeMinWeight;
  }

  /// Returns the weight difference between the max and min of the
  /// entire list
  double get allTimeMinMaxDiff {
    _checkAllTimeLoaded();
    return super.allTimeMinMaxDiff;
  }

  //! SEVEN DAYS
  /// Returns the data of the last seven days parsed for the graph
  List<Pair<double, double>> get lastSevenDaysData {
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
  double get lastSevenDaysMinMaxDiff {
    _checkLastSevenDaysLoaded();
    return super.lastSevenDaysMinMaxDiff;
  }

  //! ONE MONTH
  /// Returns the data of the last one month parsed for the graph
  List<Pair<double, double>> get oneMonthData {
    _checkOneMonthLoaded();
    return super.oneMonthData;
  }

  /// Returns the data of the max weight and its index relative to
  /// [oneMonthData] list
  Pair<int, double> get oneMonthMaxWeight {
    _checkOneMonthLoaded();
    return super.oneMonthMaxWeight;
  }

  /// Returns the data of the min weight and its index relative to
  /// [oneMonthData] list
  Pair<int, double> get oneMonthMinWeight {
    _checkOneMonthLoaded();
    return super.oneMonthMinWeight;
  }

  /// Returns the weight difference between the max and min of the
  /// [oneMonthData] list
  double get oneMonthMinMaxDiff {
    _checkOneMonthLoaded();
    return super.oneMonthMinMaxDiff;
  }

  //! SIX MONTHS
  /// Returns the data of the last six months parsed for the graph
  List<Pair<double, double>> get sixMonthsData {
    _checkSixMonthsLoaded();
    return super.sixMonthsData;
  }

  /// Returns the data of the max weight and its index relative to
  /// [sixMonthsData] list
  Pair<int, double> get sixMonthsMaxWeight {
    _checkSixMonthsLoaded();
    return super.sixMonthsMaxWeight;
  }

  /// Returns the data of the min weight and its index relative to
  /// [sixMonthsData] list
  Pair<int, double> get sixMonthsMinWeight {
    _checkSixMonthsLoaded();
    return super.sixMonthsMinWeight;
  }

  /// Returns the weight difference between the max and min of the
  /// [sixMonthsData] list
  double get sixMonthsMinMaxDiff {
    _checkSixMonthsLoaded();
    return super.sixMonthsMinMaxDiff;
  }

  //! ONE YEAR
  /// Returns the data of the last one year parsed for the graph
  List<Pair<double, double>> get oneYearData {
    _checkOneYearLoaded();
    return super.oneYearData;
  }

  /// Returns the data of the max weight and its index relative to
  /// [oneYearData] list
  Pair<int, double> get oneYearMaxWeight {
    _checkOneYearLoaded();
    return super.oneYearMaxWeight;
  }

  /// Returns the data of the min weight and its index relative to
  /// [oneYearData] list
  Pair<int, double> get oneYearMinWeight {
    _checkOneYearLoaded();
    return super.oneYearMinWeight;
  }

  /// Returns the weight difference between the max and min of the
  /// [oneYearData] list
  double get oneYearMinMaxDiff {
    _checkOneYearLoaded();
    return super.oneYearMinMaxDiff;
  }
}
