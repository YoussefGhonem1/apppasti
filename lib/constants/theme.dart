// import 'package:pasti/shared/size.dart';
import 'package:flutter/material.dart';
import 'package:pasti/main.dart';
import 'package:sizer/sizer.dart';

import '../helper_functions/small_functions.dart';

String appMode = 'Light';
Color mainColor = const Color(0xffA77943);
Color secColor = const Color(0xffF2BE62);
Color textColor({Color? grey}) {
  return appMode == 'Dark' ? Colors.white : grey ?? Colors.black;
}

Color back({String? mode}) {
  if (mode == null) {
    return appMode == 'Dark' ? Colors.black : Colors.white;
  } else {
    return mode == 'Dark' ? Colors.black : Colors.white;
  }
}

Color dialog() {
  return appMode == 'Dark' ? const Color(0xff111111) : Colors.white;
}

// Color dialog2(){
//   return appMode=='Dark'?const Color(0xff111111):Colors.white;
// }
Color strok() {
  return const Color(0xffDDDDDD);
}

ThemeData mainTheme() {
  return ThemeData(
    primaryColor: mainColor,
    scaffoldBackgroundColor: Colors.white,
    checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all<Color>(mainColor),
        fillColor: WidgetStateProperty.all<Color>(Colors.transparent),
        overlayColor: WidgetStateProperty.all<Color>(mainColor),
        side: AlwaysActiveBorderSide(),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: barColor(),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(mainColor),
    ),
    tabBarTheme: TabBarThemeData(
        labelColor: mainColor,
        indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelColor: Colors.grey),
  );
}

InputDecoration inputDecoration1(
    {Widget? suffixIcon,
    Widget? prefixIcon,
    String? label,
    String? hint,
    double? radius,
    double? content,
    Color? labelColor,
    double? contentPadding,
    double? hintS,
    double? labelS,
    double? prefixPadding,
    bool? filled,
    Color? borderC}) {
  return InputDecoration(
    focusedBorder: border(radius: radius, color: borderC),
    enabledBorder: border(radius: radius, color: borderC),
    errorBorder: border(radius: radius, color: borderC),
    focusedErrorBorder: border(radius: radius, color: borderC),
    labelText: label,
    hintText: hint,
    fillColor: dialog(),
    filled: filled ?? true,
    contentPadding:
        EdgeInsets.symmetric(horizontal: contentPadding ?? 3.w, vertical: 2.h),
    labelStyle: TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w400,
        fontSize: labelS ?? 9.sp),
    hintStyle: TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w400,
        fontSize: labelS ?? 9.sp),
    floatingLabelStyle: TextStyle(
      color: labelColor ?? mainColor,
      fontWeight: FontWeight.bold,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    errorMaxLines: 1,
    prefixIcon: prefixIcon == null
        ? null
        : Padding(
            padding: EdgeInsets.only(left: 2.w, bottom: prefixPadding ?? 0),
            child: prefixIcon,
          ),
    suffixIcon: Padding(
      padding: EdgeInsets.only(right: 4.w),
      child: suffixIcon,
    ),
    suffixIconConstraints: const BoxConstraints(
      minHeight: 0,
    ),
    errorStyle: TextStyle(fontSize: 3.w),
  );
}

InputBorder border({double? radius, Color? color}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius ?? 8),
    borderSide: BorderSide(
      color: color ?? strok(),
      width: 1,
    ),
  );
}

Widget inputBorder({required Widget textField, bool pad = false}) {
  return Padding(
    padding: pad
        ? EdgeInsets.only(
            top: 1.3.h,
            bottom: 1.3.h,
            left: isLeft() ? 0 : 1.w,
            right: isLeft() ? 1.w : 0)
        : EdgeInsets.symmetric(vertical: 1.3.h, horizontal: 1.w),
    child: textField,
  );
}

class AlwaysActiveBorderSide extends WidgetStateBorderSide {
  @override
  BorderSide? resolve(_) => const BorderSide(color: Colors.grey);
}
