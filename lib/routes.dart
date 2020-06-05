import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

import 'data/models/user_data.dart';
import 'data/models/add_weight_helper.dart';
import 'screens/add_user_screen.dart';
import 'screens/add_weight_screen.dart';
import 'screens/configuration_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home.dart';
import 'screens/progression_screen.dart';
import 'screens/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) {
        switch (settings.name) {
          case SplashScreen.routeName:
            return SplashScreen();
          case AddUserScreen.routeName:
            return AddUserScreen();
          case Home.routeName:
            return Home();
          case AddWeightScreen.routeName:
            return _addWeightScreenHandler(settings.arguments);
          case ConfigurationScreen.routeName:
            if (settings.arguments is UserData) {
              return ConfigurationScreen(
                lastConfiguration: settings.arguments,
              );
            }

            return _errorRoute('Illegal argumets for route ConfigurationScreen'); 
          case HistoryScreen.routeName:
            return HistoryScreen();
          case ProgressionScreen.routeName:
            return ProgressionScreen();
          default:
            return _errorRoute('404 Page not found');
        }
      },
      transitionDuration: Duration(milliseconds: 300),
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return effectMap[PageTransitionType.slideParallaxLeft](
          Curves.fastLinearToSlowEaseIn,
          animation,
          secondaryAnimation,
          child,
        );
      },
    );
  }

  static Widget _addWeightScreenHandler(dynamic args) {
    if (args is AddWeightHelper) {
      return AddWeightScreen(helper: args);
    }

    return _errorRoute('Illegal argumets for route AddWeightScreen');
  }

  static Widget _errorRoute(String text) {
    return Scaffold(
      body: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
