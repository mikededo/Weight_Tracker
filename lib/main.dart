import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/blocs/weight_db_bloc/weight_db_bloc.dart';
import 'data/repositories/sql_weight_repository.dart';
import 'screens/splash_screen.dart';
import 'ui/theme_data.dart';
import 'routes.dart';
import 'data/blocs/bloc_delegate.dart';

void main() {
  BlocSupervisor.delegate = WeightBlocDelegate();
  runApp(WeightTracker());
}

class WeightTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WeightDBBloc(SqlWeightRepository())..add(WeightDBLoadOnStart()),
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: SplashScreen.routeName,
        onGenerateRoute: RouteGenerator.generateRoute,
        theme: appThemeData[AppTheme.Dark],
      ),
    );
  }
}
