import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs ;
Future startShared()async{
  prefs = await SharedPreferences.getInstance();
}