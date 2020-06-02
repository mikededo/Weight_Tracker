import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/sql_weight_repository.dart';
import '../../models/weight.dart';

part 'weight';

class WeightDBBloc extends Bloc<WeightDBEvent, WeightDBState> {
  final SqlWeightRepository _repository;
  StreamSubscription _subscription;

  WeightDBBloc(this._repository);

  @override
  WeightDBState get initialState => WeightDBInitial();

  WeightData get lastWeight {
    if (state is WeightDBLoadSuccess) {
      // The last entered weight is the first of the list
      return (state as WeightDBLoadSuccess).weightCollection.first;
    }

    return null;
  }

  @override
  Stream<WeightDBState> mapEventToState(WeightDBEvent event) async* {
    if (event is WeightDBLoadOnStart) {
      yield* _mapLoadedDataToState();
    } else if (event is WeightDBFetchData) {
      yield* _mapLoadedDataToState();
    } else if (event is WeightDBAdded) {
      yield* _mapAddedDataToState(event);
    } else if (event is WeightDBUpdated) {
      yield* _mapUpdatedDataToState(event);
    } else if (event is WeightDBDeleted) {
      yield* _mapDeletedDataToState(event);
    } else if (event is WeightDBDeletedAll) {
      yield* _mapDeleteAllDataToState();
    } else if (event is WeightDBListUpdated) {
      yield* _mapWeightUpdateToState(event);
    }
  }

  Stream<WeightDBState> _mapLoadedDataToState() async* {
    try {
      _subscription?.cancel();
      _subscription = _repository.weightList().listen(
            (weight) => add(
              WeightDBListUpdated(weight),
            ),
          );
    } catch (error) {
      yield WeightDBLoadFailure();
    }
  }

  Stream<WeightDBState> _mapAddedDataToState(WeightDBAdded event) async* {
    List<WeightData> updatedData;
    if (state is WeightDBLoadSuccess) {
      // Search its position
      int index = (state as WeightDBLoadSuccess)
          .weightCollection
          .indexWhere((weight) => event.data.date.isAfter(weight.date));

      // Update in the cached memory
      if (index == -1) {
        updatedData = List.from(
          (state as WeightDBLoadSuccess).weightCollection,
        )..add(event.data);
      } else {
        updatedData = List.from(
          (state as WeightDBLoadSuccess).weightCollection,
        )..insert(index == -1 ? 0 : index, event.data);
      }
    } else if (state is WeightDBInitial) {
      updatedData = List<WeightData>()..add(event.data);
    }

    // Add in the db
    await this._repository.addWeight(event.data);
    yield WeightDBLoadSuccess(updatedData);
  }

  Stream<WeightDBState> _mapUpdatedDataToState(WeightDBUpdated event) async* {
    if (state is WeightDBLoadSuccess) {
      // Update weight in the cached memory
      final List<WeightData> updatedData = (state as WeightDBLoadSuccess)
          .weightCollection
          .map((weight) => weight.id == event.data.id ? event.data : weight)
          .toList();

      // Re-order list
      updatedData.sort((wa, wb) => wb.date.compareTo(wa.date));

      yield WeightDBLoadSuccess(updatedData);

      // Add in the DB
      this._repository.updateWeight(event.data);
    }
  }

  Stream<WeightDBState> _mapDeletedDataToState(WeightDBDeleted event) async* {
    if (state is WeightDBLoadSuccess) {
      // Delete weight in the cached memory
      final List<WeightData> updatedData = (state as WeightDBLoadSuccess)
          .weightCollection
          .where((weight) => weight.id != event.data.id)
          .toList();
      yield WeightDBLoadSuccess(updatedData);

      // Remove from the DB
      this._repository.deleteWeight(event.data);
    }
  }

  Stream<WeightDBState> _mapDeleteAllDataToState() async* {
    if (state is WeightDBLoadSuccess) {
      // Set an empty list
      yield WeightDBLoadSuccess([]);

      // Delete from DB
      this._repository.deleteAllWeight();
    }
  }

  Stream<WeightDBState> _mapWeightUpdateToState(WeightDBListUpdated event) async* {
    yield WeightDBLoadSuccess(event.weightList);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
