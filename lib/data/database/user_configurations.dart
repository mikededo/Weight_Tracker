import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_tracker/data/models/user_data.dart';

class UserConfigurations {
  static Future<UserData> loadConfigurations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return UserData.fromPrefs(prefs);
  }

  static Future<void> saveHeight(int height) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(UserData.UD_HEIGHT, height);
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