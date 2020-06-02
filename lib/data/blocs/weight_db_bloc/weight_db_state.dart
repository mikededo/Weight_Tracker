part of 'weight_db_bloc.dart';

abstract class WeightDBState extends Equatable {
  const WeightDBState();

  @override
  List<Object> get props => [];
}

class WeightDBInitial extends WeightDBState {}

class WeightDBLoadInProgress extends WeightDBState {}

class WeightDBLoadSuccess extends WeightDBState {
  final List<WeightData> weightCollection;

  const WeightDBLoadSuccess([this.weightCollection = const []]);

  @override
  List<Object> get props => [weightCollection];

  @override
  String toString() => 'WeightLoadSuccess';
}

class WeightDBLoadFailure extends WeightDBState {}
