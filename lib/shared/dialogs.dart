import 'package:pasti/constants/theme.dart';
import 'package:pasti/main.dart';
import 'package:pasti/shared/function/image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

void showSnackBar(context, msg, {String? label, Function()? tap}) {
  var bar = SnackBar(
    backgroundColor: mainColor,
    content: Text(
      msg,
      style: TextStyle(color: Colors.white),
    ),
    action: SnackBarAction(
      label: label ?? 'Annullare',
      textColor: secColor,
      onPressed: () {
        if (tap != null) {
          tap();
        }
        ScaffoldMessenger.of(GlobalVariable.navState.currentContext!)
            .hideCurrentSnackBar();
      },
    ),
    duration: const Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(bar);
}

void successDialog(context, {required String msg, var then}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    enableDrag: true,
    builder: (context) {
      final brightness = Theme.of(context).brightness;
      final isDarkMode = brightness == Brightness.dark;

      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Drag handle
                          Container(
                            margin: EdgeInsets.only(top: 1.h, bottom: 2.h),
                            width: 40.w,
                            height: 0.5.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),

                          // Success Icon
                          Container(
                            width: 22.w,
                            height: 22.w,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF4CAF50), // Green
                                  Color(0xFF2E7D32), // Darker green
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Color(0xFF4CAF50).withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 12.w,
                              ),
                            ),
                          ),

                          SizedBox(height: 3.h),

                          // Title
                          Text(
                            'Successo!',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          SizedBox(height: 2.h),

                          // Message
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(
                              msg,
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[300]
                                    : Colors.grey[700],
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(height: 4.h),

                          // Action Button
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 2.h),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // if (then != null) {
                                //   then();
                                // }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF4CAF50), // Green
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                minimumSize: Size(double.infinity, 6.h),
                                shadowColor:
                                    Color(0xFF4CAF50).withValues(alpha: 0.3),
                              ),
                              child: Text(
                                'Continua',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  ).then((value) {
    if (then != null) {
      then();
    }
  });
}

Future<XFile?> chooseImage(context, {bool video = false}) {
  var img = showCupertinoModalPopup<XFile?>(
    context: context,
    builder: (BuildContext context) => Theme(
      data: appMode != 'Dark' ? ThemeData.light() : ThemeData.dark(),
      child: CupertinoAlertDialog(
        title: Text(
          'Scegli immagine',
          style: TextStyle(color: textColor()),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () async {
              if (video) {
                var img = await pickVideo(context, 1);
                Navigator.pop(context, img);
              } else {
                var img = await pickImage(context, 1);
                Navigator.pop(context, img);
              }
            },
            // child: Text('cancel',style: TextStyle(color: textColor()),),
            child: Text(
              'Telecamera',
              style: TextStyle(color: textColor()),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              if (video) {
                var img = await pickVideo(context, 2);
                Navigator.pop(context, img);
              } else {
                var img = await pickImage(context, 2);
                Navigator.pop(context, img);
              }
            },
            child: Text(
              'Studio',
              style: TextStyle(color: textColor()),
            ),
          )
        ],
      ),
    ),
  );
  return img;
}

void confirmDialog(context, String title, void Function() confirmTap,
    {Color? color}) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(
        title,
        style: TextStyle(color: textColor()),
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Annulla',
            style: TextStyle(color: textColor()),
          ),
        ),
        CupertinoDialogAction(
          onPressed: confirmTap,
          child: Text(
            'Confermare',
            style: TextStyle(color: color ?? Colors.red),
          ),
        )
      ],
    ),
  );
}
