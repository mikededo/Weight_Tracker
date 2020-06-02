part of 'weight_db_bloc.dart';

abstract class WeightDBEvent extends Equatable {
  const WeightDBEvent();

  @override
  List<Object> get props => [];
}

class WeightDBFetchData extends WeightDBEvent {}

class WeightDBLoadOnStart extends WeightDBEvent {}

class WeightDBAdded extends WeightDBEvent {
  final WeightData data;

  const WeightDBAdded(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'WeightAdded {data: $data}';
}

class WeightDBUpdated extends WeightDBEvent {
  final WeightData data;

  const WeightDBUpdated(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'WeightUpdated {data: $data}';
}

class WeightDBListUpdated extends WeightDBEvent {
  final List<WeightData> weightList;

  WeightDBListUpdated(this.weightList);
}

class WeightDBDeleted extends WeightDBEvent {
  final WeightData data;

  const WeightDBDeleted(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'WeightDeleted {data: $data}';
}

class WeightDBDeletedAll extends WeightDBEvent {}