

import 'package:shared_preferences/shared_preferences.dart';

class LocationService {

  static const String key = "user_country";

  static Future<void> saveCountry(String country) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(key, country);

  }

  static Future<String?> getCountry() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);

  }

}
