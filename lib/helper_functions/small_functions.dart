import 'package:pasti/providers/change_language.dart';
import 'package:flutter/material.dart';

Future delay(int delay)async{
  await Future.delayed(Duration(milliseconds: delay));
}
TextDirection getDirection({bool normal = true}){
  if(normal){
    return lang=='en'?TextDirection.ltr:TextDirection.rtl;
  }else{
    return lang=='en'?TextDirection.rtl:TextDirection.ltr;
  }
}
bool isLeft(){
  return lang=='en'?true:false;
}
String date(String time){
  String date = '';
  date = time.split('T').first+' '+(time.split('T').last.split('.').first);
  return date;
}
bool checkBool(var val){
  if(val is int){
    if(val==0){
      return false;
    }else{
      return true;
    }
  }else if(val is String){
    if(int.parse(val)==0){
      return false;
    }else{
      return true;
    }
  }
  return val;
}

String reverseDate(String date){
  if(date.contains('-')){
    List<String> s = date.split('-');
    return s.last+'-'+s[1]+'-'+s.first;
  }
  List<String> s = date.split('/');
  return s.last+'-'+s[1]+'-'+s.first;
}
