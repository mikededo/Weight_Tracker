import 'package:weight_tracker/data/models/weight.dart';
import 'package:weight_tracker/util/pair.dart';
import 'package:weight_tracker/util/util.dart';

class ChartData {
  /// Holds the weight data
  List<WeightData> _data;

  /// Entire data as chart data
  List<Pair<double, double>> _allTimeData;

  /// Max weight and its index of the entire list
  Pair<int, double> _allTimeMaxItem;

  /// Min weight and its index of the entire list
  Pair<int, double> _allTimeMinItem;

  /// Last seven days chart data
  List<Pair<double, double>> _lastSevenDays;

  /// Last seven days max weight and its index relative to [lastSevenDays] list
  Pair<int, double> _lastSevenDaysMaxWeight;

  /// Last seven days min weight and its index relative to [lastSevenDays] list
  Pair<int, double> _lastSevenDaysMinWeight;

  /// [data] Weight data
  ChartData(this._data) : assert(_data != null);

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
    if (_lastSevenDays == null) {
      _lastSevenDays = _calculateLastSevenDays();
      _lastSevenDaysMaxWeight = _calculateSevenDaysMaxWeight();
      _lastSevenDaysMinWeight = _calculateSevenDaysMinWeight();
    }
  }

  //! GENERAL DATA GETTERS
  /// Returns entire data length
  int get length => _data.length;

  /// Returns the data of the entire list parsed for the graph
  List<Pair<double, double>> get allTimeData => _allTimeData;

  /// Returns max weight and its index of the entire data
  Pair<int, double> get maxWeight => _allTimeMaxItem;

  /// Returns min weight and its index of the entire data
  Pair<int, double> get minWeight => _allTimeMinItem;

  /// Returns firts date of the entire data
  DateTime get firstDate => _data.last.date;

  /// Returns last date of the entire data
  DateTime get lastDate => _data.first.date;

  /// Returns the weight difference between the max and min of the
  /// entire list
  double get minMaxDiff =>
      (_allTimeMaxItem.second - _allTimeMinItem.second) / 2;

  //! SEVEN DAYS GETTERS
  /// Returns the data of the last seven days parsed for the graph
  List<Pair<double, double>> get lastSevenDays => _lastSevenDays;

  /// Returns the data of the max weight and its index relative to
  /// [lastSevenDays] list
  Pair<int, double> get lastSevenDaysMaxWeight => _lastSevenDaysMaxWeight;

  /// Returns the data of the min weight and its index relative to
  /// [lastSevenDays] list
  Pair<int, double> get lastSevenDaysMinWeight => _lastSevenDaysMinWeight;

  /// Returns the weight difference between the max and min of the
  /// entire list
  double get sevenDaysMinMaxDiff =>
      (_lastSevenDaysMaxWeight.second - _lastSevenDaysMinWeight.second) / 2;

  /// Returns a date of one week earlier with time as [00:00:0000]
  DateTime get lastSevenDaysFirstDate {
    DateTime temp = DateTime.now().subtract(Duration(days: 7));
    return DateTime(temp.year, temp.month, temp.day);
  }

  /// Returns the current date with time as [00:00:0000]
  DateTime get lastSevenDaysLastDate {
    DateTime temp = DateTime.now();
    return DateTime(temp.year, temp.month, temp.day);
  }

  //! DATA INIT
  /// Returns the entire list data as pair of weight and their index
  /// in the general list
  List<Pair<double, double>> _dataAsPairs() {
    List<Pair<double, double>> res = [];

    for (int i = 0; i < _data.length; i++) {
      res.add(
        Pair<double, double>(
          first: i.floorToDouble(),
          second: double.parse(
            _data[i].weight.toStringAsFixed(1),
          ),
        ),
      );
    }

    return res;
  }

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

  List<Pair<double, double>> _calculateLastSevenDays() {
    List<Pair<double, double>> res = [];

    double lastWeight;
    int end = _data.length > 7 ? 7 : _data.length;
    for (int i = 0; i < end; i++) {
      DateTime timestamp = lastSevenDaysFirstDate;
      if (_data[i].date.isAfter(timestamp)) {
        lastWeight = UnitConverter.doubleToFixedDecimals(_data[i].weight, 1);
        res.add(
          Pair<double, double>(
            first: (end - i - 1).floorToDouble(),
            second: UnitConverter.doubleToFixedDecimals(_data[i].weight, 1),
          ),
        );
      } else {
        res.add(
          Pair<double, double>(
            first: i.floorToDouble(),
            second: lastWeight,
          ),
        );
      }
    }
    return res;
  }

  Pair<int, double> _calculateSevenDaysMaxWeight() {
    // Get the last seven day data
    List<Pair<double, double>> data = _lastSevenDays;

    if (_lastSevenDays.isEmpty) {
      return null;
    }

    double max = double.negativeInfinity;
    int index = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i].second > max) {
        max = data[i].second;
        index = i;
      }
    }

    return Pair<int, double>(
      first: index,
      second: max,
    );
  }

  Pair<int, double> _calculateSevenDaysMinWeight() {
    // Get the last seven day data
    List<Pair<double, double>> data = _lastSevenDays;

    if (_lastSevenDays.isEmpty) {
      return null;
    }

    double min = double.infinity;
    int index = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i].second < min) {
        min = data[i].second;
        index = i;
      }
    }

    return Pair<int, double>(
      first: index,
      second: min,
    );
  }
}
