import 'package:flutter/material.dart';
import 'package:weight_tracker/data/database/user_preferences.dart';
import 'package:weight_tracker/screens/add_user_screen.dart';
import 'package:weight_tracker/screens/home.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> _checkUserPreferences() async {
    return (await UserPreferences.loadPreferences()).isEmpty;
  }

  @override
  void initState() {
    super.initState();

    _checkUserPreferences().then(
      (bool emptyPreferences) {
        if (!emptyPreferences) {
          Navigator.of(context).pushReplacementNamed(Home.routeName);
        } else {
          Navigator.of(context).pushReplacementNamed(AddUserScreen.routeName);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
