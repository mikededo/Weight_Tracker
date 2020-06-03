import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:weight_tracker/util/pair.dart';


/// Class that contains the user data, not is configurations
@immutable
class UserData {
  final bool empty;
  final String name;
  final String lastName;
  final int height;
  final double initialWeight;
  final DateTime initialDate;
  final double weightGoal;

  static const String UD_NAME = 'name';
  static const String UD_LASTNAME = 'last_name';
  static const String UD_HEIGHT = 'height';
  static const String UD_INITIAL_WEIGHT = 'initial_weight';
  static const String UD_INITIAL_DATE = 'initial_date';
  static const String UD_WEIGHT_GOAL = 'weight_goal';

  UserData({
    @required this.name,
    @required this.lastName,
    @required this.height,
    @required this.initialWeight,
    @required this.initialDate,
    @required this.weightGoal,
  }) : this.empty = false;

  UserData copyWith({
    String name,
    String lastName,
    int height,
    double initialWeight,
    DateTime initialDate,
    double weightGoal,
  }) {
    if (empty) {
      return UserData.emptyData();
    }

    return UserData(
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      height: height ?? this.height,
      initialWeight: initialWeight ?? this.initialWeight,
      initialDate: initialDate ?? this.initialDate,
      weightGoal: weightGoal ?? this.weightGoal,
    );
  }

  UserData.emptyData()
      : this.name = null,
        this.lastName = null,
        this.height = null,
        this.initialWeight = null,
        this.weightGoal = null,
        this.initialDate = null,
        this.empty = true;

  factory UserData.fromPrefs(SharedPreferences prefs) {
    print(prefs);
    if (prefs.getKeys().isEmpty) {
      return UserData.emptyData();
    }

    return UserData(
      name: prefs.get(UD_NAME),
      lastName: prefs.get(UD_LASTNAME),
      height: prefs.get(UD_HEIGHT),
      initialWeight: prefs.get(UD_INITIAL_WEIGHT),
      initialDate: DateTime.parse(prefs.get(UD_INITIAL_DATE)),
      weightGoal: prefs.get(UD_WEIGHT_GOAL),
    );
  }

  bool get isEmpty => this.empty;

  Pair<String, String> get nameKeyValue =>
      Pair<String, String>(first: UD_NAME, second: name);

  Pair<String, String> get lastNameKeyValue =>
      Pair<String, String>(first: UD_LASTNAME, second: lastName);

  Pair<String, int> get heightKeyValue =>
      Pair<String, int>(first: UD_HEIGHT, second: height);

  Pair<String, double> get initialWeightKeyValue =>
      Pair<String, double>(first: UD_INITIAL_WEIGHT, second: initialWeight);

  Pair<String, DateTime> get initialDateKeyValue =>
      Pair<String, DateTime>(first: UD_INITIAL_DATE, second: initialDate);

  Pair<String, double> get weightGoalKeyValue =>
      Pair<String, double>(first: UD_WEIGHT_GOAL, second: weightGoal);

  @override
  String toString() {
    if (empty) {
      return 'UserData(empty)';
    }

    return 'UserData(name: $name, lastName: $lastName, height: $height, initialWeight: $initialWeight, initialDate: $initialDate, weightGoal: $weightGoal)';
  }
}
