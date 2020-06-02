abstract class SliderEvent {}

class SliderBlocModified extends SliderEvent {
  final double value;

  SliderBlocModified(this.value) : assert(value != null);
}

class SliderBlocValueReset extends SliderEvent {}
