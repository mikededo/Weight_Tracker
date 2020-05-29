part of 'weight_bloc.dart';

abstract class WeightState extends Equatable {
  const WeightState();
  @override
  List<Object> get props => [];
}

class WeightInitial extends WeightState {
  const WeightInitial();
  @override
  List<Object> get props => [];
}

class WeightLoadInProgress extends WeightState {}

class WeightLoadSuccess extends WeightState {
  final List<WeightData> weightCollection;

  const WeightLoadSuccess([this.weightCollection = const []]);

  @override
  List<Object> get props => [weightCollection];

  @override
  String toString() => 'WeightLoadSuccess';
}

class WeightLoadFailure extends WeightState {}
