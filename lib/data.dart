class Pair<T extends num, S extends num> {
  T f;
  S s;

  Pair(this.f, this.s);
}

class Data {
  static List<Pair<double, double>> weightDataList = [
    Pair<double, double>(78.80, 1.0),
    Pair<double, double>(77.30, 1.5),
    Pair<double, double>(76.60, 2.0),
    Pair<double, double>(75.00, 2.5),
    Pair<double, double>(75.70, 3.0),
    Pair<double, double>(74.50, 3.5),
    Pair<double, double>(74.30, 4.0),
    Pair<double, double>(75.20, 4.5),
    Pair<double, double>(74.90, 5.0),
    Pair<double, double>(72.60, 5.5)
  ];

  static double get length => weightDataList.length.floorToDouble();

  static Pair<double, double> pairOf(int index) => weightDataList[index];

  static double maxWeight() {
    double max = 0;

    weightDataList.forEach((p) {
      if (p.f > max) {
        max = p.f;
      }
    });
    return max;
  }

  static double minWeight() {
    double min = double.maxFinite;

    weightDataList.forEach(
      (p) {
        if (p.f < min) {
          min = p.f;
        }
      },
    );
    return min;
  }

  static double get minMonth => 1.0;

  static double get maxMonth => 5.5;
}
