

import 'package:flutter/material.dart';

void navP(context,className, {void Function()? then}){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>className)).then((value) {
    if(then!=null){
      then();
    }
  });
}
void navPR(context,className){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>className));
}
void navPRRU(context,className){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>className), (route) => false);
}
void navPop(context){
  Navigator.pop(context);
}
void navPU(context){
  Navigator.popUntil(context, (route) => false);
}