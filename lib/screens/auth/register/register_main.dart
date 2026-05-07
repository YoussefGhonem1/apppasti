import 'package:flutter/material.dart';
import 'package:pasti/constants/theme.dart';
import 'package:pasti/helper_functions/navigation.dart';
import 'package:pasti/screens/auth/register/school_register.dart';
import 'package:pasti/screens/auth/register/student_register.dart';
import 'package:pasti/shared/widgets/app_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/widgets/buttons.dart';

/// DEPRECATED: This screen is no longer used in the registration flow.
/// Users now register directly as Workers/Employees (StudentRegister).
/// Company registration has been removed from the public registration flow.
/// This file is kept for reference only.

class RegisterMain extends StatefulWidget {
  const RegisterMain({Key? key}) : super(key: key);

  @override
  _RegisterMainState createState() => _RegisterMainState();
}

class _RegisterMainState extends State<RegisterMain> {
  int index = 0;
  List<Map<String, String>> list = [
    {
      "title": "Azienda",
      "des":
          "Registrazione di un'azienda per connettersi a seguire i Collaboratori",
      "image": "assets/school.jpg"
    },
    {
      "title": "Collaboratori",
      "des": "Per scegliere tra i pasti più facile e veloce",
      "image": "assets/student.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar1('Registrati'),
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Image.asset(
                  'assets/choose.png',
                  fit: BoxFit.contain,
                  width: 75.w,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                'Seleziona un tipo di account ...',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 10.sp,
                    color: Colors.grey),
              ),
              SizedBox(
                height: 3.h,
              ),
              Column(
                children: List.generate(
                    list.length,
                    (i) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          child: InkWell(
                            child: Container(
                              width: double.infinity,
                              height: i == 0 ? 18.2.h : 16.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: i == index
                                        ? secColor
                                        : Colors.grey.shade300,
                                    width: 2.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: i == 0
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  SizedBox(
                                    width: 45.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Text(
                                          list[i]['title']!,
                                          style: TextStyle(
                                              color: mainColor,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Text(
                                          list[i]['des']!,
                                          style: TextStyle(
                                              color: Color(0xff747474),
                                              fontSize: 9.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Image.asset(
                                    list[i]['image']!,
                                    width: 35.w,
                                    fit: BoxFit.fill,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                index = i;
                              });
                            },
                          ),
                        )),
              ),
              SizedBox(
                height: 4.h,
              ),
              button1('Confermare', onTap: () {
                if (index == 0) {
                  navP(context, SchoolRegister());
                } else {
                  navP(context, StudentRegister());
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
