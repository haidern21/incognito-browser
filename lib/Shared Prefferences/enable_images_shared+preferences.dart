import 'package:shared_preferences/shared_preferences.dart';

class EnableImagesPreference {
  static const ENABLEIMAGES_STATUS = "ENABLEIMAGESSTATUS";

  setEnableImages(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(ENABLEIMAGES_STATUS, value);
    print("VALUE SAVED");
  }

  Future<bool> getEnableImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(ENABLEIMAGES_STATUS) ?? true;
  }
}