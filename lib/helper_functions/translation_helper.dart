import 'package:flutter/material.dart';
import 'package:pasti/models/localizations.dart';

/// Helper function to access translations using the existing AppLocalizations
/// Usage: translate(context, 'main', 'home') returns the translated text
String translate(BuildContext context, String parentKey, String nestedKey) {
  final localizations = AppLocalizations.of(context);
  if (localizations != null) {
    try {
      return localizations.translate(parentKey, nestedKey);
    } catch (e) {
      debugPrint('Translation error for $parentKey.$nestedKey: $e');
      return nestedKey; // Return the key as fallback
    }
  }
  return nestedKey; // Return the key if localizations not available
}

/// Shorthand function for translation
/// Usage: tr(context, 'main', 'home')
String tr(BuildContext context, String parentKey, String nestedKey) {
  return translate(context, parentKey, nestedKey);
}

/// Extension method for easier access
extension LocalizationExtension on BuildContext {
  String loc(String parentKey, String nestedKey) {
    return translate(this, parentKey, nestedKey);
  }
}
