enum Unit { Metric, Imperial }

class UnitConverter {
  static const double cmFeet = 0.03280839895;
  static const double feetInch = 12;
  static const double kgLbs = 2.20462262185;

  static Unit unitFromValue(String val) {
    if (val == 'metric') {
      return Unit.Metric;
    } else {
      return Unit.Imperial;
    }
  }

  static String valueFromUnit(Unit unit) {
    switch (unit) {
      case Unit.Metric:
        return 'metric';
      default:
        return 'imperial';
    }
  }

  static double kgToLbs(double val) => val * kgLbs;

  static double lbsToKg(double val) => val / kgLbs;

  static String kgLbsToString(double val) => val.toStringAsFixed(1);

  static String kgToStringRich(double val) => val.toStringAsFixed(1) + 'kg';

  static String lbsToStringRich(double val) => val.toStringAsFixed(1) + 'lb';

  static double cmToFeet(double val) => val * cmFeet;

  static double feetToCm(double val) => val / cmFeet;

  static String feetToString(double val) {
    if (val < 0) {
      throw Exception('Value must be positive');
    }

    double result = val * cmFeet;
    String feet = result.toString().substring(0, 1);
    if (((result % 1) * feetInch).floor() == 0) {
      return feet + '\'';
    }

    String inch = ((result % 1) * feetInch).floor().toString();
    return feet + '\' ' + inch + '\'\'';
  }

  static String cmToString(double val) => val.toStringAsFixed(0) + 'cm';

  static double doubleToFixedDecimals(double value, int decimals) =>
      double.parse(value.toStringAsFixed(decimals));
}
