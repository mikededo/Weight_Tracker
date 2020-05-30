import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_tracker/data/models/user_data.dart';

class UserConfiguration {
  Future<UserData> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return UserData.fromPrefs(prefs);
  }

  Future<void> saveHeight(int height) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt(UserData.UD_HEIGHT, height);
  }
}
