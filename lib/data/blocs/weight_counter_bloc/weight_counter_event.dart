abstract class WeightCounterEvent {}

class ModifyWeight extends WeightCounterEvent {
  final double value;

  ModifyWeight(this.value) : assert (value != null);
}

class SetWeight extends WeightCounterEvent {
  final double value;

  SetWeight(this.value) : assert(value >= 0.0);
}

class ResetToInitialWeight extends WeightCounterEvent {}