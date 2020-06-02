import 'dart:async';

import '../database/weight_dao.dart';
import '../models/weight.dart';
import 'weight_repository.dart';

class SqlWeightRepository implements WeightRepository {
  final WeightDao _dao = WeightDao();

  @override
  Future<void> addWeight(WeightData wd) {
    return _dao.addWeight(wd);
  }

  @override
  Future<void> updateWeight(WeightData wd) {
    return _dao.updateWeight(wd);
  }

  @override
  Future<void> deleteWeight(WeightData wd) {
    return _dao.deleteWeight(wd);
  }

  @override
  Future<void> deleteAllWeight() {
    return _dao.deleteAllWeight();
  }

  @override
  Stream<List<WeightData>> weightList() {
    // Data filtered in the DAO
    return Stream.fromFuture(_dao.weightDataList);
  }
}
