import 'package:weight_tracker/util/pair.dart';

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
