import 'package:equatable/equatable.dart';

class WeightEntity extends Equatable {
  final int id;
  final double weight;
  final DateTime date;

  static const String W_TABLE_NAME = 'weight_table';
  static const String W_COL_ID = 'id';
  static const String W_COL_WEIGHT = 'weight';
  static const String W_COL_DATE = 'date';

  WeightEntity(
    this.id,
    this.weight,
    this.date,
  ) : assert(weight != null, date != null);

  WeightEntity.withId(
    this.id,
    this.weight,
    this.date,
  ) : assert(weight != null, date != null);

  factory WeightEntity.fromMap(Map<String, dynamic> map) {
    return WeightEntity.withId(
      map[W_COL_ID],
      map[W_COL_WEIGHT],
      DateTime.parse(map[W_COL_DATE]),
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

  // Equatable
  @override
  List<Object> get props => [id, weight, date];
}