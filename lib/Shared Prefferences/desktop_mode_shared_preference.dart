import 'package:shared_preferences/shared_preferences.dart';

class DesktopModePreference {
  static const DESKTOP_STATUS = "DESKTOPSTATUS";

  setDesktopMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(DESKTOP_STATUS, value);
    print("VALUE SAVED");
  }

  Future<bool> getDesktopMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(DESKTOP_STATUS) ?? false;
  }
}