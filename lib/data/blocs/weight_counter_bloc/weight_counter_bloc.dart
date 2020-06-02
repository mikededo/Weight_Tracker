import 'dart:async';

import 'package:bloc/bloc.dart';
import 'weight_counter_event.dart';

class WeightCounterBloc extends Bloc<WeightCounterEvent, double> {
  final double initialWeight;

  WeightCounterBloc(double initialWeight)
      : this.initialWeight = initialWeight ?? 75.0;

  @override
  double get initialState => initialWeight;

  @override
  Stream<double> mapEventToState(WeightCounterEvent event) async* {
    if (event is WeightCounterModified) {
      // Wether it is a positive or a negative value, we just sum it
      yield state + event.value;
    } else if (event is WeightCounterSet) {
      // Set initial value
      yield event.value;
    } else if (event is WeightCounterValueReset) {
      // We have the value stored
      yield initialWeight;
    }
  }
}
