import 'package:pasti/providers/change_language.dart';

String translateString(String it, String ar) {
  return lang == 'ar' ? ar : it;
  // return 'a';
}

// String translate(context,key,value){
//   return AppLocalizations.of(context)!.translate(key, value);
// }
String langText() {
  if (lang == 'ar') {
    return 'العربية';
  } else {
    return 'Italiano';
  }
}

String modeText(String mode) {
  if (lang == 'ar') {
    if (mode == 'Dark') {
      return 'ليلي';
    } else {
      return "نهار";
    }
  } else {
    if (mode == 'Dark') {
      return 'Dark';
    } else {
      return "Light";
    }
  }
}
