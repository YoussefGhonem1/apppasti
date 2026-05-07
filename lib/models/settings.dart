
import 'package:pasti/helper_functions/small_functions.dart';
class Settings{
  int id;
  String orderTime;
  String termsLink;

  Settings({required this.id, required this.orderTime, required this.termsLink});
  
  factory Settings.fromJson(Map data){
    String time = data['order_time'];
    String finalTime = '';
    List<String> parts = time.split(':');
    if(parts.length>1){
      finalTime = parts.first+':'+parts[1];
    }else{
      finalTime = time;
    }
    return Settings(id: data['id'], orderTime: finalTime, termsLink: data['terms_link']);
  }
}
class TimeClass{
  String time;
  String date;
  String day;

  TimeClass({required this.time, required this.date, required this.day});
  factory TimeClass.fromJson(Map data){
    return TimeClass(time: data['time'], date: reverseDate(data['date']), day: data['current_day']);
  }
}
late Settings settings;
late TimeClass timeClass;

