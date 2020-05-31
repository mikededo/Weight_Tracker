import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_tracker/data/models/user_data.dart';

class UserPreferences {
  // Get the user saved preferences
  static Future<UserData> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return UserData.fromPrefs(prefs);
  }

  static Future<UserData> updatePreference(String key, dynamic value) async {
    if (key == UserData.UD_HEIGHT) {
        saveHeight(value as int);
    }
    
    return loadPreferences();
  }

  static Future<UserData> addPreferences(UserData prefs) async {
    await saveHeight(prefs.height);

    return loadPreferences();
  }

  static Future<void> saveHeight(int height) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(
      UserData.UD_HEIGHT,
      height,
    );
  }

  static Future<double> getUserHeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int val = prefs.get(UserData.UD_HEIGHT);

    if (val != null) {
      return val.truncateToDouble();
    }

    return null;
  }
}
