import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'routes.dart';
import 'screens/home.dart';
import 'data/blocs/weight_bloc/weight_bloc.dart';
import 'data/blocs/weight_bloc/weight_bloc_delegate.dart';
import 'data/repositories/sql_weight_repository.dart';

void main() {
  BlocSupervisor.delegate = WeightBlocDelegate();
  runApp(WeightTracker());
}

class WeightTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<WeightBloc>(
      create: (context) {
        return WeightBloc(SqlWeightRepository())..add(WeightLoadOnStart());
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Color(0xFF191924),
          primaryColor: Colors.white,
          primaryColorLight: Color(0xFF202137),
          accentColor: Colors.orange,
          buttonTheme: ButtonThemeData(
            splashColor: Colors.white24,
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          textTheme: GoogleFonts.workSansTextTheme().copyWith(
            bodyText1: GoogleFonts.workSans().copyWith(
              color: Colors.white,
              fontSize: 14.0,
            ),
            headline1: GoogleFonts.workSans().copyWith(
              color: Colors.white,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
            headline2: GoogleFonts.workSans().copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 32.0,
            ),
            headline3: GoogleFonts.workSans().copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              letterSpacing: 1.0,
            ),
            headline4: GoogleFonts.workSans().copyWith(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              letterSpacing: 1.0,
            ),
            subtitle1: GoogleFonts.workSans().copyWith(
              fontWeight: FontWeight.bold,
              color: Color(0xFF8a8b98),
              letterSpacing: 0.5,
              fontSize: 22.0,
            ),
            button: GoogleFonts.workSans().copyWith(
              color: Color(0xFF191924),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            )
          ),
        ),
        initialRoute: Home.routeName,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
