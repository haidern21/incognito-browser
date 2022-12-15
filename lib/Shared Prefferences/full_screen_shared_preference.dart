import 'package:shared_preferences/shared_preferences.dart';

class FullScreenPreference {
  static const FULL_SCREEN_STATUS = "FULLSCREENSTATUS";

  setFullScreenMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(FULL_SCREEN_STATUS, value);
    print("VALUE SAVED");
  }

  Future<bool> getFullScreenMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(FULL_SCREEN_STATUS) ?? false;
  }
}