import 'package:flutter/material.dart';

import 'data/models/user_data.dart';
import 'data/models/weight.dart';
import 'screens/add_user_screen.dart';
import 'screens/add_weight_screen.dart';
import 'screens/configuration_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home.dart';
import 'screens/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case AddUserScreen.routeName:
        return MaterialPageRoute(builder: (_) => AddUserScreen());
      case Home.routeName:
        return MaterialPageRoute(builder: (_) => Home());
      case AddWeightScreen.routeName:
        final WeightData wd = settings.arguments as WeightData;
        return MaterialPageRoute(builder: (_) => AddWeightScreen(wd: wd));
      case ConfigurationScreen.routeName:
        final UserData prefs = settings.arguments as UserData;
        return MaterialPageRoute(
          builder: (_) => ConfigurationScreen(
            prefs: prefs,
          ),
        );
      case HistoryScreen.routeName:
        return MaterialPageRoute(builder: (_) => HistoryScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          body: Center(
            child: Text(
              '404 Page not found',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
