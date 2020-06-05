import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_tracker/util/pair.dart';

import '../models/user_data.dart';
import '../../util/util.dart';

class UserSharedPreferences {
  /// Get the user saved preferences
  static Future<UserData> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return UserData.fromPrefs(prefs);
  }

  /// Updates the peference saved as [key] if it exists
  static Future<UserData> updatePreference(Pair<String, dynamic> p) async {
    switch (p.first) {
      case UserData.UD_NAME:
      case UserData.UD_LASTNAME:
        saveString(
          Pair<String, String>(
            first: p.first,
            second: p.second as String,
          ),
        );
        break;
      case UserData.UD_HEIGHT:
      case UserData.UD_INITIAL_WEIGHT:
      case UserData.UD_GOAL_WEIGHT:
        saveDouble(
          Pair<String, double>(
            first: p.first,
            second: p.second as double,
          ),
        );
        break;
      case UserData.UD_INITIAL_DATE:
      case UserData.UD_GOAL_DATE:
        saveDateTime(
          Pair<String, DateTime>(
            first: p.first,
            second: p.second as DateTime,
          ),
        );
        break;
      case UserData.UD_UNIT:
        saveUnit(
          Pair<String, Unit>(
            first: p.first,
            second: p.second as Unit,
          ),
        );
        break;
      default:
        throw Exception('UpdatePreferences not found key');
    }

    return loadPreferences();
  }

  /// Adds the preferences and returns the updated preferences
  static Future<UserData> addPreferences(UserData prefs) async {
    if (!prefs.isEmpty) {
      saveString(prefs.nameKeyValue);
      saveString(prefs.lastNameKeyValue);
      saveDouble(prefs.heightKeyValue);
      saveDouble(prefs.initialWeightKeyValue);
      saveDateTime(prefs.initialDateKeyValue);
      saveDouble(prefs.goalWeightKeyValue);
      saveDateTime(prefs.goalDateKeyValue);
      saveUnit(prefs.unitKeyValue);
    }

    return loadPreferences();
  }

  /// Saves a [String] in the [key] to the preferences
  static Future<void> saveString(Pair<String, String> p) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(p.first, p.second);
  }

  /// Saves an [int] in the [key] to the preferences
  static Future<void> saveInt(Pair<String, int> p) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(p.first, p.second);
  }

  /// Saves a [double] in the [key] to the preferences
  static Future<void> saveDouble(Pair<String, double> p) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(p.first, p.second);
  }

  /// Saves a [DateTime] (as ISO string) in the [key] to the preferences
  static Future<void> saveDateTime(Pair<String, DateTime> p) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(p.first, p.second.toIso8601String());
  }

  /// Saves a [Unit] (as a String) in the [key] to the preferences
  static Future<void> saveUnit(Pair<String, Unit> p) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
      p.first,
      UnitConverter.valueFromUnit(p.second),
    );
  }

  /// Resets the initial values
  static Future<void> resetInitial(double weight, DateTime date) async {
    saveDouble(
      Pair<String, double>(
        first: UserData.UD_INITIAL_WEIGHT,
        second: weight,
      ),
    );
    saveDateTime(
      Pair<String, DateTime>(
        first: UserData.UD_INITIAL_DATE,
        second: date,
      ),
    );
  }

  /// Resets the goal values 
  static Future<void> resetGoal(double weight, DateTime date) async {
    saveDouble(
      Pair<String, double>(
        first: UserData.UD_GOAL_WEIGHT,
        second: weight,
      ),
    );
    saveDateTime(
      Pair<String, DateTime>(
        first: UserData.UD_GOAL_DATE,
        second: date,
      ),
    );
  }

  /// Returns the user height value
  static Future<double> getUserHeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int val = prefs.get(UserData.UD_HEIGHT);

    if (val != null) {
      return val.truncateToDouble();
    }

    return null;
  }
}
