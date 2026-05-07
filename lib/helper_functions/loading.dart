import 'package:pasti/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

bool isLoadingStart = false;
void loading(context) {
  isLoadingStart = true;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: true,
        child: Opacity(
          opacity: 0.7,
          child: Container(
            width: 100.w,
            height: 100.h,
            color: Colors.black12,
            child: Center(
              child: CircularProgressIndicator(
                color: mainColor,
              ),
            ),
          ),
        ),
      );
    },
  ).then((value) {
    isLoadingStart = false;
  });
}
