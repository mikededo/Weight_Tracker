import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/data/blocs/weight_db_bloc/weight_db_bloc.dart';

class WeightDBBlocBuilder extends StatelessWidget {
  final Widget Function(WeightDBLoadSuccess state) onLoaded;

  const WeightDBBlocBuilder({@required this.onLoaded})
      : assert(onLoaded != null);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightDBBloc, WeightDBState>(
      builder: (context, state) {
        if (state is WeightDBLoadInProgress || state is WeightDBInitial) {
          return Center(child: CircularProgressIndicator());
        } else if (state is WeightDBLoadSuccess) {
          /// Data already sorted
          return onLoaded(state);
        } else {
          return Center(child: Text('Failed loading data'));
        }
      },
    );
  }
}
