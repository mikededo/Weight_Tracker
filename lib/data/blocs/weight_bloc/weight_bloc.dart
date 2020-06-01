import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/sql_weight_repository.dart';
import '../../models/weight.dart';

part 'weight_event.dart';
part 'weight_state.dart';

class WeightBloc extends Bloc<WeightEvent, WeightState> {
  final SqlWeightRepository _repository;
  StreamSubscription _subscription;

  WeightBloc(this._repository);

  @override
  WeightState get initialState => WeightInitial();

  WeightData get lastWeight {
    if (state is WeightLoadSuccess) {
      // The last entered weight is the first of the list
      return (state as WeightLoadSuccess).weightCollection.first;
    }

    return null;
  }

  @override
  Stream<WeightState> mapEventToState(WeightEvent event) async* {
    if (event is WeightLoadOnStart) {
      yield* _mapLoadedDataToState();
    } else if (event is WeightFetchData) {
      yield* _mapLoadedDataToState();
    } else if (event is WeightAdded) {
      yield* _mapAddedDataToState(event);
    } else if (event is WeightUpdated) {
      yield* _mapUpdatedDataToState(event);
    } else if (event is WeightDeleted) {
      yield* _mapDeletedDataToState(event);
    } else if (event is WeightDeletedAll) {
      yield* _mapDeleteAllDataToState();
    } else if (event is WeightListUpdated) {
      yield* _mapWeightUpdateToState(event);
    }
  }

  Stream<WeightState> _mapLoadedDataToState() async* {
    try {
      _subscription?.cancel();
      _subscription = _repository.weightList().listen(
            (weight) => add(
              WeightListUpdated(weight),
            ),
          );
    } catch (error) {
      yield WeightLoadFailure();
    }
  }

  Stream<WeightState> _mapAddedDataToState(WeightAdded event) async* {
    List<WeightData> updatedData;
    if (state is WeightLoadSuccess) {
      // Search its position
      int index = (state as WeightLoadSuccess)
          .weightCollection
          .indexWhere((weight) => event.data.date.isAfter(weight.date));

      // Update in the cached memory
      if (index == -1) {
        updatedData = List.from(
          (state as WeightLoadSuccess).weightCollection,
        )..add(event.data);
      } else {
        updatedData = List.from(
          (state as WeightLoadSuccess).weightCollection,
        )..insert(index == -1 ? 0 : index, event.data);
      }
    } else if (state is WeightInitial) {
      updatedData = List<WeightData>()..add(event.data);
    }

    // Add in the db
    await this._repository.addWeight(event.data);
    yield WeightLoadSuccess(updatedData);
  }

  Stream<WeightState> _mapUpdatedDataToState(WeightUpdated event) async* {
    if (state is WeightLoadSuccess) {
      // Update weight in the cached memory
      final List<WeightData> updatedData = (state as WeightLoadSuccess)
          .weightCollection
          .map((weight) => weight.id == event.data.id ? event.data : weight)
          .toList();

      // Re-order list
      updatedData.sort((wa, wb) => wb.date.compareTo(wa.date));

      yield WeightLoadSuccess(updatedData);

      // Add in the DB
      this._repository.updateWeight(event.data);
    }
  }

  Stream<WeightState> _mapDeletedDataToState(WeightDeleted event) async* {
    if (state is WeightLoadSuccess) {
      // Delete weight in the cached memory
      final List<WeightData> updatedData = (state as WeightLoadSuccess)
          .weightCollection
          .where((weight) => weight.id != event.data.id)
          .toList();
      yield WeightLoadSuccess(updatedData);

      // Remove from the DB
      this._repository.deleteWeight(event.data);
    }
  }

  Stream<WeightState> _mapDeleteAllDataToState() async* {
    if (state is WeightLoadSuccess) {
      // Set an empty list
      yield WeightLoadSuccess([]);

      // Delete from DB
      this._repository.deleteAllWeight();
    }
  }

  Stream<WeightState> _mapWeightUpdateToState(WeightListUpdated event) async* {
    yield WeightLoadSuccess(event.weightList);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
