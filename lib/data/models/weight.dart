import 'package:meta/meta.dart';

@immutable
class WeightData {
  final String id;
  final double weight;
  final DateTime date;

  static const String W_TABLE_NAME = 'weight_table';
  static const String W_COL_ID = 'id';
  static const String W_COL_WEIGHT = 'weight';
  static const String W_COL_DATE = 'date';

  WeightData(this.id, {this.weight, DateTime date})
      : this.date = date ?? DateTime.now(),
        assert(weight != null);

  WeightData copyWith({String id, double weight, DateTime date}) {
    return WeightData(
      id ?? this.id,
      weight: weight ?? this.weight,
      date: date ?? this.date,
    );
  }

  factory WeightData.fromMap(Map<String, dynamic> map) {
    return WeightData(
      map[W_COL_ID].toString(),
      weight: map[W_COL_WEIGHT],
      date: DateTime.parse(map[W_COL_DATE]),
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> res = {};

    if (this.id != null) {
      res[W_COL_ID] = this.id;
    }
    res[W_COL_WEIGHT] = this.weight;
    res[W_COL_DATE] = this.date.toIso8601String();

    return res;
  }

  @override
  int get hashCode => id.hashCode ^ weight.hashCode ^ date.hashCode;

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is WeightData &&
            this.runtimeType == other.runtimeType &&
            this.id == other.id &&
            this.weight == other.weight &&
            this.date == other.date;
  }

  @override
  String toString() => '\n Data: $id, $weight, $date';
}
