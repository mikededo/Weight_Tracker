import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chart_button_event.dart';

class ChartButtonBloc extends Bloc<ChartButtonEvent, int> {
  final List<int> buttonIds;

  ChartButtonBloc(this.buttonIds);

  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(ChartButtonEvent event) async* {
    if (event is ChartButtonPressed) {
      if (buttonIds.contains(event.pressedId)) {
        // If the ids is in the possible list, yield it
        yield event.pressedId;
      } else {
        // -1 Will simbolize the error id
        yield -1;
      }
    }
  }
}
