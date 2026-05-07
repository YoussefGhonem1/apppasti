import 'package:pasti/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget button1 (String text,{double? width,double? height,void Function()? onTap,
  double? fontS,bool hie = false,double? circular,
Color? border,Color? color,Color? textC}){
  return Align(
    alignment: Alignment.center,
    child: InkWell(
      child: Container(
        width: width??54.w,
        height: height??6.3.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(circular??50),
          color: color??mainColor,
          border: border==null?null:Border.all(color: border),
        ),
        child: Center(
          child: Text(text,
            style: TextStyle(color: textC??Colors.white,fontSize: fontS??9.sp,fontWeight: FontWeight.w400,
            height: hie?1:null),),
        ),
      ),
      onTap: onTap,
    ),
  );
}