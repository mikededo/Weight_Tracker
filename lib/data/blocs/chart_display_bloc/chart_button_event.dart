part of 'chart_button_bloc.dart';

abstract class ChartButtonEvent extends Equatable {
  const ChartButtonEvent();

  @override
  List<Object> get props => [];
}

class ChartButtonPressed extends ChartButtonEvent {
  final int pressedId;

  const ChartButtonPressed(this.pressedId);

  @override
  List<Object> get props => [pressedId];

  @override
  String toString() => 'Data [$pressedId]';
}
