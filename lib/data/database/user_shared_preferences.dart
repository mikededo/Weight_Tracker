import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_tracker/util/pair.dart';

import '../models/user_data.dart';

class UserSharedPreferences {
  /// Get the user saved preferences
  static Future<UserData> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return UserData.fromPrefs(prefs);
  }

  /// Updates the peference saved as [key] if it exists
  static Future<UserData> updatePreference(Pair<String, dynamic> p) async {

    if (p.first == UserData.UD_NAME || p.first == UserData.UD_LASTNAME) {
      saveString(p);
    } else if (p.first == UserData.UD_HEIGHT) {
      saveInt(p);
    } else if (p.first == UserData.UD_INITIAL_WEIGHT || p.first == UserData.UD_WEIGHT_GOAL) {
      saveDouble(p);
    } else if (p.first == UserData.UD_INITIAL_DATE) {
      saveDateTime(p);
    } else {
      throw Exception('UpdatePreferences not found key');
    }

    return loadPreferences();
  }

  /// Adds the preferences and returns the updated preferences
  static Future<UserData> addPreferences(UserData prefs) async {
    saveString(prefs.nameKeyValue);
    saveString(prefs.lastNameKeyValue);
    saveInt(prefs.heightKeyValue);
    saveDouble(prefs.initialWeightKeyValue);
    saveDateTime(prefs.initialDateKeyValue);
    saveDouble(prefs.weightGoalKeyValue);

    return loadPreferences();
  }

  /// Saves a double in the key to the preferences
  static Future<void> saveString(Pair<String, String> p) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(p.first, p.second);
  }

  /// Saves a double in the key to the preferences
  static Future<void> saveInt(Pair<String, int> p) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(p.first, p.second);
  }

  /// Saves a double in the key to the preferences
  static Future<void> saveDouble(Pair<String, double> p) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(p.first, p.second);
  }

  /// Saves a datetime (as ISO string) in the key to the preferences
  static Future<void> saveDateTime(Pair<String, DateTime> p) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(p.first, p.second.toIso8601String());
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
