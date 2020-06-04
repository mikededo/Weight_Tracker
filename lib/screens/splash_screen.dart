import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/blocs/user_preferences_bloc/user_preferences_bloc.dart';
import '../data/blocs/weight_db_bloc/weight_db_bloc.dart';
import '../data/database/user_shared_preferences.dart';
import '../screens/add_user_screen.dart';
import '../screens/home.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> _checkUserPreferences() async {
    return (await UserSharedPreferences.loadPreferences()).isEmpty;
  }

  @override
  void initState() {
    super.initState();

    _checkUserPreferences().then(
      (bool emptyPreferences) {
        if (!emptyPreferences) {
          BlocProvider.of<WeightDBBloc>(context).add(WeightDBLoadOnStart());
          BlocProvider.of<UserPreferencesBloc>(context)
              .add(UserPreferencesLoadPreferences());
          Navigator.of(context).pushNamedAndRemoveUntil(
            Home.routeName,
            (route) => false,
          );
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AddUserScreen.routeName,
            (route) => false,
          );
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
