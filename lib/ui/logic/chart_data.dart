import 'dart:collection';

import 'package:weight_tracker/data/models/weight.dart';
import 'package:weight_tracker/util/pair.dart';
import 'package:weight_tracker/util/util.dart';

class ChartData {
  /// Holds the data in a list
  List<WeightData> _data;

  /// Holds the weight data sorted by date
  Map<DateTime, WeightData> _dataMap;

  /// Entire data as chart data
  List<Pair<double, double>> _allTimeData;

  /// Max weight and its index of the entire list
  Pair<int, double> _allTimeMaxItem;

  /// Min weight and its index of the entire list
  Pair<int, double> _allTimeMinItem;

  /// Last seven days chart data
  List<Pair<double, double>> _lastSevenDaysData;

  /// Last seven days max weight and its index relative to [lastSevenDays] list
  Pair<int, double> _lastSevenDaysMaxWeight;

  /// Last seven days min weight and its index relative to [lastSevenDays] list
  Pair<int, double> _lastSevenDaysMinWeight;

  /// One month chart data
  List<Pair<double, double>> _oneMonthData;

  /// One month max weight and its index relative to [oneMonthData] list
  Pair<int, double> _oneMonthMaxWeight;

  /// One month min weight and its index relative to [oneMonthData] list
  Pair<int, double> _oneMonthMinWeight;

  /// Six months chart data
  List<Pair<double, double>> _sixMonthsData;

  /// Six months max weight and its index relative to [sixMonthsData] list
  Pair<int, double> _sixMonthsMaxWeight;

  /// Six months min weight and its index relative to [sixMonthsData] list
  Pair<int, double> _sixMonthsMinWeight;

  /// One year chart data
  List<Pair<double, double>> _oneYearData;

  /// One year max weight and its index relative to [oneYearData] list
  Pair<int, double> _oneYearMaxWeight;

  /// One year min weight and its index relative to [oneYearData] list
  Pair<int, double> _oneYearMinWeight;

  /// [data] Weight data
  ChartData(List<WeightData> data) {
    // Check nullability
    assert(data != null);

    // Add it to data
    _data = data;

    // Sort the data by days (closer first)
    _dataMap = SplayTreeMap<DateTime, WeightData>(
      (da, db) => db.compareTo(da),
    );

    for (int i = 0; i < data.length; i++) {
      _dataMap.putIfAbsent(
        data[i].date,
        () => data[i],
      );
    }
  }

  //! DATE CONSTANTS
  static const _weekDays = 7;
  static const _monthDays = 31;
  static const _sixMonthsDays = 186;
  static const _oneYearDays = 365;

  //! DATA LOADERS
  /// Calculates all the data needed to display the entire data to the chart
  /// only if this has not been set already
  void loadAllTimeData() {
    if (_allTimeData == null) {
      _allTimeData = _dataAsPairs();
      _allTimeMaxItem = _calculateMaxItem();
      _allTimeMinItem = _calculateMinItem();
    }
  }

  /// Calculates all the data needed to display a last seven days chart
  /// only if this has not been set already
  void loadSevenDaysData() {
    if (_lastSevenDaysData == null) {
      _lastSevenDaysData = _calculateLastSevenDaysData();
      _lastSevenDaysMaxWeight = _calculateSevenDaysMaxWeight();
      _lastSevenDaysMinWeight = _calculateSevenDaysMinWeight();
    }
  }

  /// Calculates all the data needed to display a one month chart
  /// only if this has not been set already
  void loadOneMonthData() {
    if (_oneMonthData == null) {
      _oneMonthData = _calculateOneMonthData();
      _oneMonthMaxWeight = _calculateOneMonthMaxWeight();
      _oneMonthMinWeight = _calculateOneMonthMinWeight();
    }
  }

  /// Calculates all the data needed to display a one month chart
  /// only if this has not been set already
  void loadSixMonthsData() {
    if (_sixMonthsData == null) {
      _sixMonthsData = _calculateSixMonthsData();
      _sixMonthsMaxWeight = _calculateSixMonthsMaxWeight();
      _sixMonthsMinWeight = _calculateSixMonthsMinWeight();
    }
  }

  /// Calculates all the data needed to display a one month chart
  /// only if this has not been set already
  void loadOneYearData() {
    if (_oneYearData == null) {
      _oneYearData = _calculateOneYearData();
      _oneYearMaxWeight = _calculateOneYearMaxWeight();
      _oneYearMinWeight = _calculateOneYearMinWeight();
    }
  }

  //! GENERAL DATA GETTERS
  /// Returns entire data length
  int get length => _dataMap.keys.length;

  /// Returns the today date with time as [00:00:0000]
  DateTime get todayDate => UnitConverter.dateFromDateTime(DateTime.now());

  /// Returns the data of the entire list parsed for the graph
  List<Pair<double, double>> get allTimeData => _allTimeData;

  /// Returns max weight and its index of the entire data
  Pair<int, double> get allTimeMaxWeight => _allTimeMaxItem;

  /// Returns min weight and its index of the entire data
  Pair<int, double> get allTimeMinWeight => _allTimeMinItem;

  /// Returns first date of the entire data
  WeightData get firstData => _data.last;

  /// Returns last date of the entire data
  WeightData get lastData => _data.first;

  /// Returns the weight difference between the max and min of the
  /// entire list
  double get allTimeMinMaxDiff =>
      (_allTimeMaxItem.second - _allTimeMinItem.second) / 2;

  //! SEVEN DAYS GETTERS
  /// Returns the data of the last seven days parsed for the graph
  List<Pair<double, double>> get lastSevenDaysData => _lastSevenDaysData;

  /// Returns the data of the max weight and its index relative to
  /// [lastSevenDays] list
  Pair<int, double> get lastSevenDaysMaxWeight => _lastSevenDaysMaxWeight;

  /// Returns the data of the min weight and its index relative to
  /// [lastSevenDays] list
  Pair<int, double> get lastSevenDaysMinWeight => _lastSevenDaysMinWeight;

  /// Returns the weight difference between the max and min of the
  /// last week list
  double get lastSevenDaysMinMaxDiff =>
      (_lastSevenDaysMaxWeight.second - _lastSevenDaysMinWeight.second) / 2;

  /// Returns a date of one week earlier with time as [00:00:0000]
  DateTime get lastSevenDaysFirstDate => UnitConverter.dateFromDateTime(
      DateTime.now().subtract(Duration(days: _weekDays - 1)));

  //! ONE MONTH GETTERS
  /// Returns the data of the last one month parsed for the graph
  List<Pair<double, double>> get oneMonthData => _oneMonthData;

  /// Returns the data of the max weight and its index relative to
  /// [oneMonthData] list
  Pair<int, double> get oneMonthMaxWeight => _oneMonthMaxWeight;

  /// Returns the data of the min weight and its index relative to
  /// [oneMonthData] list
  Pair<int, double> get oneMonthMinWeight => _oneMonthMinWeight;

  /// Returns the weight difference between the max and min of the
  /// [oneMonthData] list
  double get oneMonthMinMaxDiff =>
      (_oneMonthMaxWeight.second - _oneMonthMinWeight.second) / 2;

  /// Returns a date of one month earlier with time as [00:00:0000]
  DateTime get oneMonthFirstDate => UnitConverter.dateFromDateTime(
      DateTime.now().subtract(Duration(days: _monthDays - 1)));

  //! ONE MONTH GETTERS
  /// Returns the data of the last one month parsed for the graph
  List<Pair<double, double>> get sixMonthsData => _sixMonthsData;

  /// Returns the data of the max weight and its index relative to
  /// [sixMonthsData] list
  Pair<int, double> get sixMonthsMaxWeight => _sixMonthsMaxWeight;

  /// Returns the data of the min weight and its index relative to
  /// [sixMonthsData] list
  Pair<int, double> get sixMonthsMinWeight => _sixMonthsMinWeight;

  /// Returns the weight difference between the max and min of the
  /// [sixMonthsData]list
  double get sixMonthsMinMaxDiff =>
      (_sixMonthsMaxWeight.second - _sixMonthsMinWeight.second) / 2;

  /// Returns a date of six months earlier with time as [00:00:0000]
  DateTime get sixMonthsFirstDate => UnitConverter.dateFromDateTime(
      DateTime.now().subtract(Duration(days: _sixMonthsDays - 1)));

  //! ONE MONTH GETTERS
  /// Returns the data of the last one month parsed for the graph
  List<Pair<double, double>> get oneYearData => _oneYearData;

  /// Returns the data of the max weight and its index relative to
  /// [oneYearData] list
  Pair<int, double> get oneYearMaxWeight => _oneYearMaxWeight;

  /// Returns the data of the min weight and its index relative to
  /// [oneYearData] list
  Pair<int, double> get oneYearMinWeight => _oneYearMinWeight;

  /// Returns the weight difference between the max and min of the
  /// [oneYearData]list
  double get oneYearMinMaxDiff =>
      (_oneYearMaxWeight.second - _oneYearMinWeight.second) / 2;

  /// Returns a date of six months earlier with time as [00:00:0000]
  DateTime get oneYearFirstDate => UnitConverter.dateFromDateTime(
      DateTime.now().subtract(Duration(days: _oneYearDays - 1)));

  //! DATA INIT
  /// Returns the entire list data as pair of weight and their index
  /// in the general list
  List<Pair<double, double>> _dataAsPairs() =>
      _dateRangeList(todayDate, _data.length, _data.length);

  Pair<int, double> _calculateMaxItem() {
    if (_data.isEmpty) {
      return null;
    }

    double max = double.negativeInfinity;
    int i = 0;
    _data.asMap().forEach(
      (index, wd) {
        if (wd.weight > max) {
          max = wd.weight;
          i = index;
        }
      },
    );

    return Pair<int, double>(
      first: i,
      second: max,
    );
  }

  Pair<int, double> _calculateMinItem() {
    if (_data.isEmpty) {
      return null;
    }

    double max = double.infinity;
    int i = 0;
    _data.asMap().forEach(
      (index, wd) {
        if (wd.weight < max) {
          max = wd.weight;
          i = index;
        }
      },
    );

    return Pair<int, double>(
      first: i,
      second: max,
    );
  }

  /// Calculates the last seven days data
  List<Pair<double, double>> _calculateLastSevenDaysData() =>
      _dateRangeList(todayDate, _weekDays, _weekDays);

  /// Calculates the last seven days max value
  Pair<int, double> _calculateSevenDaysMaxWeight() {
    if (_lastSevenDaysData.isEmpty) {
      return null;
    }

    return _maxFromPairList(_lastSevenDaysData);
  }

  /// Calculates the last seven days min value
  Pair<int, double> _calculateSevenDaysMinWeight() {
    if (_lastSevenDaysData.isEmpty) {
      return null;
    }

    return _minFromPairList(_lastSevenDaysData);
  }

  /// Calculates the last one month data
  List<Pair<double, double>> _calculateOneMonthData() =>
      _dateRangeList(todayDate, _monthDays, _monthDays);

  /// Calculates the last one month max value
  Pair<int, double> _calculateOneMonthMaxWeight() {
    if (_oneMonthData.isEmpty) {
      return null;
    }

    return _maxFromPairList(_oneMonthData);
  }

  /// Calculates the last on month min value
  Pair<int, double> _calculateOneMonthMinWeight() {
    if (_oneMonthData.isEmpty) {
      return null;
    }

    return _minFromPairList(_oneMonthData);
  }

  /// Calculates the last six months data
  List<Pair<double, double>> _calculateSixMonthsData() =>
      _dateRangeList(todayDate, _sixMonthsDays, _sixMonthsDays);

  /// Calculates the last six months max value
  Pair<int, double> _calculateSixMonthsMaxWeight() {
    if (_sixMonthsData.isEmpty) {
      return null;
    }

    return _maxFromPairList(_sixMonthsData);
  }

  /// Calculates the last six months min value
  Pair<int, double> _calculateSixMonthsMinWeight() {
    if (_sixMonthsData.isEmpty) {
      return null;
    }

    return _minFromPairList(_sixMonthsData);
  }

  /// Calculates the last one year data
  List<Pair<double, double>> _calculateOneYearData() =>
      _dateRangeList(todayDate, _oneYearDays, _oneYearDays);

  /// Calculates the last one year max value
  Pair<int, double> _calculateOneYearMaxWeight() {
    if (_oneYearData.isEmpty) {
      return null;
    }

    return _maxFromPairList(_oneYearData);
  }

  /// Calculates the last one year min value
  Pair<int, double> _calculateOneYearMinWeight() {
    if (_oneYearData.isEmpty) {
      return null;
    }

    return _minFromPairList(_oneYearData);
  }

  /// Returns a list of doubles with all the data from the position 0 to [end]
  /// (exclusive) of the list where [0 <= end <= length]
  /// The items will be placing from [max] to 0 where the closer to [max] the index
  /// of an item is, more close to today is
  List<Pair<double, double>> _dateRangeList(
      DateTime timestamp, int max, int end) {
    List<Pair<double, double>> res = [];
    for (int i = 0; i < end; i++) {
      DateTime temp = UnitConverter.dateFromDateTime(
        timestamp.subtract(Duration(days: i)),
      );
      if (_dataMap.containsKey(temp)) {
        res.add(
          Pair<double, double>(
            first: (max - i - 1).floorToDouble(),
            second: UnitConverter.doubleToFixedDecimals(
              _dataMap[temp].weight,
              2,
            ),
          ),
        );
      }

      if (res.length >= _data.length) {
        break;
      }
    }
    return res;
  }

  /// Returns the max double from a list of pairs comparing the second value
  /// of each pair and it's index relative to the list
  Pair<int, double> _maxFromPairList(List<Pair<double, double>> data) {
    double max = double.negativeInfinity;
    int index = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i].second != null) {
        if (data[i].second > max) {
          max = data[i].second;
          index = i;
        }
      }
    }

    return Pair<int, double>(
      first: index,
      second: max,
    );
  }

  /// Returns the min double from a list of pairs comparing the second value
  /// of each pair and it's index relative to the list
  Pair<int, double> _minFromPairList(List<Pair<double, double>> data) {
    double min = double.infinity;
    int index = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i].second != null) {
        if (data[i].second < min) {
          min = data[i].second;
          index = i;
        }
      }
    }

    return Pair<int, double>(
      first: index,
      second: min,
    );
  }
}
