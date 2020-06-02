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

  UserData copyWith({
    String name,
    String lastName,
    int height,
    double weightGoal,
  }) {
    return UserData(
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      height: height ?? this.height,
      weightGoal: weightGoal ?? this.weightGoal,
    );
  }

  UserData.emptyData()
      : this.name = null,
        this.lastName = null,
        this.height = null,
        this.weightGoal = null;

  factory UserData.fromPrefs(SharedPreferences prefs) {
    return UserData(
      name: prefs.get(UD_NAME),
      lastName: prefs.get(UD_LASTNAME),
      height: prefs.get(UD_HEIGHT),
      weightGoal: prefs.get(UD_WEIGHT_GOAL),
    );
  }

  @override
  String toString() {
    return 'UD: [$name, $lastName, $height, $weightGoal]';
  }

  bool get isEmpty => (height == null);
}
