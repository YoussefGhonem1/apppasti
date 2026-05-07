import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizer {
  static Map<String, dynamic>? _localizedStrings;

  static Future<void> load(String languageCode) async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/languages/$languageCode.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap;
      debugPrint('✅ Loaded language: $languageCode');
    } catch (e) {
      debugPrint('❌ Error loading language file: $e');
      // Fallback to English
      try {
        String jsonString =
            await rootBundle.loadString('assets/languages/en.json');
        Map<String, dynamic> jsonMap = json.decode(jsonString);
        _localizedStrings = jsonMap;
        debugPrint('⚠️ Fallback to English');
      } catch (fallbackError) {
        debugPrint('❌ Fallback failed: $fallbackError');
      }
    }
  }

  static String translate(String key, {String? defaultValue}) {
    if (_localizedStrings == null) {
      return defaultValue ?? key;
    }

    List<String> keys = key.split('.');
    dynamic value = _localizedStrings;

    for (String k in keys) {
      if (value is Map && value.containsKey(k)) {
        value = value[k];
      } else {
        return defaultValue ?? key;
      }
    }

    return value?.toString() ?? defaultValue ?? key;
  }

  // Shorthand function
  static String t(String key, {String? defaultValue}) {
    return translate(key, defaultValue: defaultValue);
  }
}

// Global translation function
String tr(String key, {String? defaultValue}) {
  return AppLocalizer.translate(key, defaultValue: defaultValue);
}

// Translation with context (for future use with context-aware translations)
String trContext(BuildContext context, String key, {String? defaultValue}) {
  return AppLocalizer.translate(key, defaultValue: defaultValue);
}
