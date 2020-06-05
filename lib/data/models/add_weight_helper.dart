import 'package:flutter/foundation.dart';
import 'package:weight_tracker/data/models/weight.dart';
import 'package:weight_tracker/util/util.dart';

enum AddWeightType {
  Default,
  Initial,
  Goal,
}

@immutable
class AddWeightHelper {
  final WeightData weightData;
  final AddWeightType addType;
  final DateTime minDate;
  final Unit units;

  const AddWeightHelper({
    this.weightData,
    this.addType = AddWeightType.Default,
    this.minDate,
    this.units,
  });
}
