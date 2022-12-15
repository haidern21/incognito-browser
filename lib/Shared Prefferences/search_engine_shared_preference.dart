import 'package:shared_preferences/shared_preferences.dart';

class SearchEngineSharedPreference{
  static const SEARCH_ENGINE = "SEARCHENGINE";

  setSearchEngine(String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(SEARCH_ENGINE, value.trim());
  print("VALUE SAVED");
  }

  Future<String> getSearchEngine() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(SEARCH_ENGINE) ?? 'Google';
  }

}
