import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class UserData {
  final int height;

  static const String UD_HEIGHT = 'height';
  static const String UD_THEME = 'theme_type';

  UserData({@required this.height});

  factory UserData.fromPrefs(SharedPreferences prefs) {
    return UserData(
      height: prefs.get(UD_HEIGHT)
    );
  }

  bool get isEmpty => (height == null);
}
