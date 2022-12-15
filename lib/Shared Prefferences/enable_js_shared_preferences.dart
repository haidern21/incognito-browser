import 'package:shared_preferences/shared_preferences.dart';

class EnableJsPreference {
  static const ENABLEJS_STATUS = "ENABLEJSSTATUS";

  setEnableJs(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(ENABLEJS_STATUS, value);
    print("VALUE SAVED");
  }

  Future<bool> getEnableJs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(ENABLEJS_STATUS) ?? false;
  }
}