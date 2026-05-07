import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = const Locale('en');
  // Locale _appLocale = const Locale('it');
  Locale get appLocal => _appLocale;
  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    String language = prefs.getString('language_code') ?? 'en';
    if (prefs.getString('language_code') == null) {
      _appLocale = const Locale('en');
      lang = 'en';
    } else {
      if (language == 'ar') {
        _appLocale = const Locale('ar');
      } else if (language == 'en') {
        _appLocale = const Locale('en');
      } else {
        _appLocale = const Locale('it');
      }
      lang = language;
    }
    debugPrint(_appLocale.languageCode);
    notifyListeners();
  }

  Future changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();

    if (type == const Locale("en")) {
      _appLocale = const Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
      lang = 'en';
    }

    if (type == const Locale("ar")) {
      _appLocale = const Locale("ar");
      await prefs.setString('language_code', 'ar');
      await prefs.setString('countryCode', 'EG');
      lang = 'ar';
    }

    if (type == const Locale("it")) {
      _appLocale = const Locale("it");
      await prefs.setString('language_code', 'it');
      await prefs.setString('countryCode', 'IT');
      lang = 'it';
    }
    notifyListeners();
  }
}

late String lang;
