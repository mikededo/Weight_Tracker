import 'package:flutter/foundation.dart';
import 'package:weight_tracker/data/models/weight.dart';

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

  const AddWeightHelper({
    this.weightData,
    this.addType = AddWeightType.Default,
    this.minDate,
  });
}
