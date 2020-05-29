import 'package:flutter/material.dart';
import 'package:weight_tracker/data/models/weight.dart';
import 'package:weight_tracker/screens/add_weight_screen.dart';
import 'package:weight_tracker/screens/configuration_screen.dart';
import 'package:weight_tracker/screens/history_screen.dart';
import 'package:weight_tracker/screens/home.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Home.routeName:
        return MaterialPageRoute(builder: (_) => Home());
      case AddWeightScreen.routeName:
        final WeightData wd = settings.arguments as WeightData;
        print(wd);
        return MaterialPageRoute(builder: (_) => AddWeightScreen(wd: wd));
      case ConfigurationScreen.routeName:
        return MaterialPageRoute(builder: (_) => ConfigurationScreen());
      case HistoryScreen.routeName:
        return MaterialPageRoute(builder: (_) => HistoryScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('404 Page nout found'),
        ),
      );
    });
  }
}
