abstract class WeightCounterEvent {}

class WeightCounterModified extends WeightCounterEvent {
  final double value;

  WeightCounterModified(this.value) : assert(value != null);
}

class WeightCounterSet extends WeightCounterEvent {
  final double value;

  WeightCounterSet(this.value) : assert(value >= 0.0);
}

class WeightCounterValueReset extends WeightCounterEvent {}
