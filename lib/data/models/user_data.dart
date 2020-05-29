import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  int height;

  static const String UD_HEIGHT = 'height';

  UserData({this.height = 180});

  factory UserData.fromPrefs(SharedPreferences prefs) {
    return UserData(
      height: prefs.get(UD_HEIGHT) ?? 180,
    );
  }
}