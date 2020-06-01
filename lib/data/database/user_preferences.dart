import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_data.dart';

class UserPreferences {
  /// Get the user saved preferences
  static Future<UserData> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return UserData.fromPrefs(prefs);
  }

  /// Updates the peference saved as [key] if it exists
  static Future<UserData> updatePreference(String key, dynamic value) async {
    if (key == UserData.UD_HEIGHT) {
      saveHeight(value as int);
    }

    return loadPreferences();
  }

  /// Adds the preferences and returns the updated preferences
  static Future<UserData> addPreferences(UserData prefs) async {
    await saveHeight(prefs.height);

    return loadPreferences();
  }

  /// Saved the height preference value
  static Future<void> saveHeight(int height) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(
      UserData.UD_HEIGHT,
      height,
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
