import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/pair.dart';
import '../../util/util.dart';

/// Class that contains the user data, not is configurations
@immutable
class UserData extends Equatable {
  final bool _empty;
  final String _name;
  final String _lastName;
  final double _height;
  final double _initialWeight;
  final DateTime _initialDate;
  final double _goalWeight;
  final DateTime _goalDate;
  final Unit _units;

  static const String UD_NAME = 'name';
  static const String UD_LASTNAME = 'last_name';
  static const String UD_HEIGHT = 'height';
  static const String UD_INITIAL_WEIGHT = 'initial_weight';
  static const String UD_INITIAL_DATE = 'initial_date';
  static const String UD_GOAL_WEIGHT = 'goal_weight';
  static const String UD_GOAL_DATE = 'goal_date';
  static const String UD_UNIT = 'unit';

  UserData({
    @required String name,
    @required String lastName,
    @required double height,
    @required double initialWeight,
    @required DateTime initialDate,
    @required double goalWeight,
    DateTime goalDate,
    Unit units = Unit.Metric,
  })  : this._name = name,
        this._lastName = lastName,
        this._height = height,
        this._initialWeight = initialWeight,
        this._initialDate = initialDate,
        this._goalWeight = goalWeight,
        this._empty = false,
        this._goalDate = goalDate ?? initialDate.add(Duration(days: 27)),
        this._units = units;

  UserData copyWith({
    String name,
    String lastName,
    double height,
    double initialWeight,
    DateTime initialDate,
    double weightGoal,
    DateTime goalDate,
    Unit units,
  }) {
    if (_empty) {
      return UserData.emptyData();
    }

    return UserData(
      name: name ?? this._name,
      lastName: lastName ?? this._lastName,
      height: height ?? this._height,
      initialWeight: initialWeight ?? this._initialWeight,
      initialDate: initialDate ?? this._initialDate,
      goalWeight: weightGoal ?? this._goalWeight,
      goalDate: goalDate ?? this._goalDate,
      units: units ?? this._units,
    );
  }

  UserData.emptyData()
      : this._name = null,
        this._lastName = null,
        this._height = null,
        this._initialWeight = null,
        this._initialDate = null,
        this._goalWeight = null,
        this._goalDate = null,
        this._units = null,
        this._empty = true;

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
      units: UnitConverter.unitFromValue(prefs.get(UD_UNIT)),
    );
  }

  /// Getters that return the atributes depending on the [Unit]
  String get name => this._name;

  String get lastName => this._lastName;

  /// Returns the height in cm (metric) or feet (imperial)
  double get height => _units == Unit.Metric
      ? this._height
      : UnitConverter.cmToFeet(this._height);

  /// Returns the height in cm
  double get rawHeight => this._height;

  /// Returns the initial weight in kg (metric) or lbs (imperial)
  double get initialWeight => _units == Unit.Metric
      ? this._initialWeight
      : UnitConverter.kgToLbs(this._initialWeight);

  /// Returns the height in cm
  double get rawInitialWeight => this._initialWeight;

  DateTime get initialDate => this._initialDate;

  /// Returns the goal weight in kg (metric) or lbs (imperial)
  double get goalWeight => _units == Unit.Metric
      ? this._goalWeight
      : UnitConverter.kgToLbs(this._goalWeight);

  /// Returns the height in cm
  double get rawGoalWeight => this._goalWeight;

  DateTime get goalDate => this._goalDate;

  Unit get dataUnits => this._units;

  /// Returns true if the units are in [Metric]
  bool get areMetric => this._units == Unit.Metric;

  /// Returns true if the units are in [Imperial]
  bool get areImperial => this._units == Unit.Imperial;

  bool get isEmpty => this._empty;

  /// Getters that return a [Pair<Key, Value>] for each atribute of the class
  /// User name
  Pair<String, String> get nameKeyValue =>
      Pair<String, String>(first: UD_NAME, second: this._name);

  /// User last name
  Pair<String, String> get lastNameKeyValue =>
      Pair<String, String>(first: UD_LASTNAME, second: this._lastName);

  /// User height
  Pair<String, double> get heightKeyValue =>
      Pair<String, double>(first: UD_HEIGHT, second: this._height);

  /// User initial weight value
  Pair<String, double> get initialWeightKeyValue => Pair<String, double>(
      first: UD_INITIAL_WEIGHT, second: this._initialWeight);

  /// User intial weight date
  Pair<String, DateTime> get initialDateKeyValue =>
      Pair<String, DateTime>(first: UD_INITIAL_DATE, second: this._initialDate);

  /// User goal weight value
  Pair<String, double> get goalWeightKeyValue =>
      Pair<String, double>(first: UD_GOAL_WEIGHT, second: this._goalWeight);

  /// User goal weight date
  Pair<String, DateTime> get goalDateKeyValue =>
      Pair<String, DateTime>(first: UD_GOAL_DATE, second: this._goalDate);

  /// User unit system
  Pair<String, Unit> get unitKeyValue =>
      Pair<String, Unit>(first: UD_UNIT, second: this._units);

  /// Returns true if the [key] is one of the initials
  static bool isInitialKey(String key) =>
      key == UD_INITIAL_DATE || key == UD_INITIAL_WEIGHT;

  /// Returns true if the [key] is one of the goals
  static bool isGoalKey(String key) =>
      key == UD_GOAL_DATE || key == UD_GOAL_WEIGHT;

  @override
  String toString() {
    if (_empty) {
      return 'UserData(empty)';
    }

    return """
      UserData {
        name: $_name,
        lastName: $_lastName, 
        height: $_height, 
        initialWeight: $_initialWeight, 
        initialDate: $_initialDate, 
        goalWeight: $_goalWeight, 
        goalDate: $_goalDate,
        unit: ${UnitConverter.valueFromUnit(_units)}
      }
    """;
  }

  @override
  List<Object> get props => [
        _name,
        _lastName,
        _height,
        _initialWeight,
        _initialDate,
        _goalWeight,
        _goalDate,
        _units,
      ];
}
