import 'package:flutter/foundation.dart';
import 'package:weight_tracker/data/models/weight.dart';

import 'util/pair.dart';

class ChartData {
  List<WeightData> _data;
  Pair<int, double> _maxItem;
  Pair<int, double> _minItem;

  ChartData(this._data) : assert(_data != null) {
    this._maxItem = _calculateMaxItem();
    this._minItem = _calculateMinItem();
  }

  int get length => _data.length;

  Pair<int, double> get maxWeight => _maxItem;

  Pair<int, double> get minWeight => _minItem;

  DateTime get firstDate => _data.last.date;

  DateTime get lastDate => _data.first.date;

  double get minMaxDiff => (_maxItem.second - _minItem.second) / 2;

  List<Pair<double, double>> get dataAsPairs {
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

  List<Pair<double, double>> get lastSevenDays {
    List<Pair<double, double>> res = [];

    DateTime timestamp = DateTime.now();

    for (int i = 0; i < 7; i++) {
      if (_data[i].date.difference(timestamp).inDays == 0) {
        res.add(
          Pair<double, double>(
            first: i.floorToDouble(),
            second: double.parse(
              _data[i].weight.toStringAsFixed(1),
            ),
          ),
        );
      } else {
        res.add(
          Pair<double, double>(
            first: i.floorToDouble(),
            second: null,
          ),
        );
      }
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
}

class Data {
  static List<Pair<double, double>> weightDataList = [
    Pair<double, double>(first: 78.80, second: 1.0),
    Pair<double, double>(first: 77.30, second: 1.5),
    Pair<double, double>(first: 76.60, second: 2.0),
    Pair<double, double>(first: 75.00, second: 2.5),
    Pair<double, double>(first: 75.70, second: 3.0),
    Pair<double, double>(first: 74.50, second: 3.5),
    Pair<double, double>(first: 74.30, second: 4.0),
    Pair<double, double>(first: 75.20, second: 4.5),
    Pair<double, double>(first: 74.90, second: 5.0),
    Pair<double, double>(first: 72.60, second: 5.5)
  ];

  static double get length => weightDataList.length.floorToDouble();

  static Pair<double, double> pairOf(int index) => weightDataList[index];

  static double maxWeight() {
    double max = 0;

    weightDataList.forEach((p) {
      if (p.first > max) {
        max = p.first;
      }
    });
    return max;
  }

  static double minWeight() {
    double min = double.maxFinite;

    weightDataList.forEach(
      (p) {
        if (p.first < min) {
          min = p.first;
        }
      },
    );
    return min;
  }

  static double get minMonth => 1.0;

  static double get maxMonth => 5.5;
}
