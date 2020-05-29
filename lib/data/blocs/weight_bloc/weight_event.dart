part of 'weight_bloc.dart';

abstract class WeightEvent extends Equatable {
  const WeightEvent();

  @override
  List<Object> get props => [];
}

class WeightLoadedSuccess extends WeightEvent {}

class WeightLoadOnStart extends WeightEvent {}

class WeightAdded extends WeightEvent {
  final WeightData data;

  const WeightAdded(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'WeightAdded {data: $data}';
}

class WeightUpdated extends WeightEvent {
  final WeightData data;

  const WeightUpdated(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'WeightUpdated {data: $data}';
}

class WeightListUpdated extends WeightEvent {
  final List<WeightData> weightList;

  WeightListUpdated(this.weightList);
}

class WeightDeleted extends WeightEvent {
  final WeightData data;

  const WeightDeleted(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'WeightDeleted {data: $data}';
}

class WeightDeletedAll extends WeightEvent {}