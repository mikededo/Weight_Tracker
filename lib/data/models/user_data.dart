import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class UserData {
  final String name;
  final String lastName;
  final int height;
  final double weightGoal;

  static const String UD_NAME = 'name';
  static const String UD_LASTNAME = 'last_name';
  static const String UD_HEIGHT = 'height';
  static const String UD_WEIGHT_GOAL = 'weight_goal';
  static const String UD_THEME = 'theme_type';

  UserData({
    @required this.name,
    @required this.lastName,
    @required this.height,
    @required this.weightGoal,
  });

  factory UserData.fromPrefs(SharedPreferences prefs) {
    return UserData(
      name: prefs.get(UD_NAME),
      lastName: prefs.get(UD_LASTNAME),
      height: prefs.get(UD_HEIGHT),
      weightGoal: prefs.get(UD_WEIGHT_GOAL),
    );
  }

  bool get isEmpty => (height == null);
}
