abstract class SliderEvent {}

class ModifySliderValue extends SliderEvent {
  final double value;

  ModifySliderValue(this.value) : assert (value != null);
}

class ResetToInitialValue extends SliderEvent {}