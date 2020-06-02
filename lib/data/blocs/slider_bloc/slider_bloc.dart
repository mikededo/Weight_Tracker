import 'dart:async';

import 'package:bloc/bloc.dart';
import 'slider_event.dart';

class SliderBloc extends Bloc<SliderEvent, double> {
  final double initialValue;

  SliderBloc(double initialValue)
      : this.initialValue = initialValue ?? 180.0 {
        print(initialValue);
      }

  @override
  double get initialState => initialValue;

  @override
  Stream<double> mapEventToState(SliderEvent event) async* {
    if (event is SliderBlocModified) {
      // Yield the changed value
      yield event.value;
    } else if (event is SliderBlocValueReset) {
      // We have the value stored
      yield initialValue;
    }
  }
}
