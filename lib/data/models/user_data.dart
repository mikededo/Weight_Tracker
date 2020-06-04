import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/pair.dart';

/// Class that contains the user data, not is configurations
@immutable
class UserData extends Equatable {
  final bool empty;
  final String name;
  final String lastName;
  final int height;
  final double initialWeight;
  final DateTime initialDate;
  final double goalWeight;
  final DateTime goalDate;

  static const String UD_NAME = 'name';
  static const String UD_LASTNAME = 'last_name';
  static const String UD_HEIGHT = 'height';
  static const String UD_INITIAL_WEIGHT = 'initial_weight';
  static const String UD_INITIAL_DATE = 'initial_date';
  static const String UD_GOAL_WEIGHT = 'goal_weight';
  static const String UD_GOAL_DATE = 'goal_date';

  UserData({
    @required this.name,
    @required this.lastName,
    @required this.height,
    @required this.initialWeight,
    @required this.initialDate,
    @required this.goalWeight,
    DateTime goalDate,
  })  : this.empty = false,
        this.goalDate = goalDate ?? initialDate.add(Duration(days: 27));

  UserData copyWith({
    String name,
    String lastName,
    int height,
    double initialWeight,
    DateTime initialDate,
    double weightGoal,
    DateTime goalDate,
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
      goalWeight: weightGoal ?? this.goalWeight,
      goalDate: goalDate ?? this.goalDate,
    );
  }

  UserData.emptyData()
      : this.name = null,
        this.lastName = null,
        this.height = null,
        this.initialWeight = null,
        this.initialDate = null,
        this.goalWeight = null,
        this.goalDate = null,
        this.empty = true;

  factory UserData.fromPrefs(SharedPreferences prefs) {
    if (prefs.getKeys().isEmpty) {
      return UserData.emptyData();
    }

    return UserData(
      name: prefs.get(UD_NAME),
      lastName: prefs.get(UD_LASTNAME),
      height: prefs.get(UD_HEIGHT),
      initialWeight: prefs.get(UD_INITIAL_WEIGHT),
      initialDate: DateTime.parse(prefs.get(UD_INITIAL_DATE)),
      goalWeight: prefs.get(UD_GOAL_WEIGHT),
      goalDate: DateTime.parse(prefs.get(UD_GOAL_DATE)),
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

  Pair<String, double> get goalWeightKeyValue =>
      Pair<String, double>(first: UD_GOAL_WEIGHT, second: goalWeight);

  Pair<String, DateTime> get goalDateKeyValue =>
      Pair<String, DateTime>(first: UD_GOAL_DATE, second: goalDate);

  @override
  String toString() {
    if (empty) {
      return 'UserData(empty)';
    }

    return 'UserData(name: $name, lastName: $lastName, height: $height, initialWeight: $initialWeight, initialDate: $initialDate, goalWeight: $goalWeight, goalDate: $goalDate)';
  }

  @override
  List<Object> get props => [
        name,
        lastName,
        height,
        initialWeight,
        initialDate,
        goalWeight,
        goalDate,
      ];
}
