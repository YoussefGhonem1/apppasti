

import 'package:pasti/helper_functions/small_functions.dart';

int unReadLength = 0;
class NotificationClass{
  String title;
  String message;
  String time;
  NotificationClass({required this.title, required this.message,required this.time});
  factory NotificationClass.fromJson(Map data){
    return NotificationClass(title: data['title'],message: data['message'],
        time: date(data['created_at']==null?data['updated_at']:data['created_at']));
  }
}