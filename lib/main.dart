import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/data/blocs/weight_bloc/weight_bloc.dart';
import 'package:weight_tracker/data/repositories/sql_weight_repository.dart';
import 'package:weight_tracker/screens/splash_screen.dart';
import 'package:weight_tracker/ui/theme_data.dart';

import 'routes.dart';
import 'data/blocs/weight_bloc/weight_bloc_delegate.dart';

void main() {
  BlocSupervisor.delegate = WeightBlocDelegate();
  runApp(WeightTracker());
}

class WeightTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeightBloc(SqlWeightRepository())..add(WeightLoadOnStart()),
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: SplashScreen.routeName,
        onGenerateRoute: RouteGenerator.generateRoute,
        theme: appThemeData[AppTheme.Dark],
      ),
    );
  }
}
