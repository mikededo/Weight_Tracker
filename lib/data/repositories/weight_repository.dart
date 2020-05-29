import 'package:weight_tracker/data/models/weight.dart';

abstract class WeightRepository {
  Future<void> addWeight(WeightData wd);

  Future<void> updateWeight(WeightData wd);

  Future<void> deleteWeight(WeightData wd);

  Future<void> deleteAllWeight();

  Stream<List<WeightData>> weightList();
}