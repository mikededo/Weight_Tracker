import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/sql_weight_repository.dart';
import '../../models/weight.dart';

part 'weight_db_event.dart';
part 'weight_db_state.dart';

class WeightDBBloc extends Bloc<WeightDBEvent, WeightDBState> {
  final SqlWeightRepository _repository;
  StreamSubscription _subscription;

  WeightDBBloc(this._repository);

  @override
  WeightDBState get initialState => WeightDBInitial();

  WeightData get lastWeight {
    if (state is WeightDBLoadSuccess) {
      // The last entered weight is the first of the list
      if ((state as WeightDBLoadSuccess).weightCollection.isEmpty) {
        return null;
      } else {
        return (state as WeightDBLoadSuccess).weightCollection.first;
      }
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
    // Add in the db
    await this._repository.addWeight(event.data);
    yield* _mapLoadedDataToState();
  }

  Stream<WeightDBState> _mapUpdatedDataToState(WeightDBUpdated event) async* {
    if (state is WeightDBLoadSuccess) {
      // Add in the DB
      await this._repository.updateWeight(event.data);
      yield* _mapLoadedDataToState();
    }
  }

  Stream<WeightDBState> _mapDeletedDataToState(WeightDBDeleted event) async* {
    if (state is WeightDBLoadSuccess) {
      // Remove from the DB
      await this._repository.deleteWeight(event.data);
      yield* _mapLoadedDataToState();
    }
  }

  Stream<WeightDBState> _mapDeleteAllDataToState() async* {
    if (state is WeightDBLoadSuccess) {
      // Delete from DB
      await this._repository.deleteAllWeight();
      yield* _mapLoadedDataToState();
    }
  }

  Stream<WeightDBState> _mapWeightUpdateToState(
    WeightDBListUpdated event,
  ) async* {
    yield WeightDBLoadSuccess(event.weightList);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
