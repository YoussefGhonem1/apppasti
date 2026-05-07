import 'package:flutter/material.dart';
import 'package:pasti/main.dart';
import 'package:pasti/models/school.dart';
import 'package:sizer/sizer.dart';

import '../constants/theme.dart';
import '../helper_functions/api.dart';
import '../helper_functions/loading.dart';
import '../helper_functions/navigation.dart';

class Classes {
  int id;
  String schoolId;
  String className;

  Classes({required this.id, required this.schoolId, required this.className});
  factory Classes.fromJson(Map data) {
    return Classes(
        id: data['id'],
        schoolId: data['school_id'].toString(),
        className: data['name']);
  }
  static Future<List<Classes>> getClasses() async {
    loading(
      GlobalVariable.navState.currentContext!,
    );
    List<Classes> list = [];
    try {
      Map apiData = await handleApi(GlobalVariable.navState.currentContext!,
          route: 'school/get_school_classes',
          isPost: false,
          header: {
            'Authorization': school.token,
          });
      navPop(GlobalVariable.navState.currentContext!);
      if (apiData['status'] == 1) {
        for (var c in apiData['data']['data']) {
          list.add(Classes.fromJson(c));
        }
      }
    } catch (e) {
      navPop(GlobalVariable.navState.currentContext!);
    }
    return list;
  }

  static Future<Classes?> addClass(String name) async {
    loading(
      GlobalVariable.navState.currentContext!,
    );
    try {
      Map apiData = await handleApi(GlobalVariable.navState.currentContext!,
          route: 'school/add_class',
          data: {
            "name": name
          },
          header: {
            'Authorization': school.token,
          });
      navPop(GlobalVariable.navState.currentContext!);
      if (apiData['status'] == 1) {
        return Classes.fromJson(apiData['data']['data']);
      }
    } catch (e) {
      navPop(GlobalVariable.navState.currentContext!);
    }
    return null;
  }

  static Future<Classes?> editClass(String name, int id) async {
    loading(
      GlobalVariable.navState.currentContext!,
    );
    try {
      Map apiData = await handleApi(GlobalVariable.navState.currentContext!,
          route: 'school/edit_class',
          data: {
            "name": name,
            "class_id": id
          },
          header: {
            'Authorization': school.token,
          });
      navPop(GlobalVariable.navState.currentContext!);
      if (apiData['status'] == 1) {
        return Classes.fromJson(apiData['data']['data']);
      }
    } catch (e) {
      navPop(GlobalVariable.navState.currentContext!);
    }
    return null;
  }

  static Future<bool> deleteClass(int id) async {
    loading(
      GlobalVariable.navState.currentContext!,
    );
    try {
      Map apiData = await handleApi(GlobalVariable.navState.currentContext!,
          route: 'school/delete_class',
          data: {
            "class_id": id
          },
          header: {
            'Authorization': school.token,
          });
      navPop(GlobalVariable.navState.currentContext!);
      if (apiData['status'] == 1) {
        return true;
      }
    } catch (e) {
      navPop(GlobalVariable.navState.currentContext!);
    }
    return false;
  }
}

Future<Classes?> enterClass(context, String? name, int? id) async {
  Classes? v;
  final TextEditingController controller =
      TextEditingController(text: name ?? "");
  final _formKey = GlobalKey<FormState>();

  await showModalBottomSheet<Classes>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      final brightness = Theme.of(context).brightness;
      final isDarkMode = brightness == Brightness.dark;

      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: EdgeInsets.only(top: 8.h),
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Form(
            key: _formKey,
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

                    // Header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [mainColor, secColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Icon(
                                name != null
                                    ? Icons.edit_rounded
                                    : Icons.add_business_rounded,
                                color: Colors.white,
                                size: 6.w,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name != null ? 'Modifica Sede' : 'Nuova Sede',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Inserisci il nome della sede',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Input Field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isDarkMode ? Colors.grey[900] : Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.grey[800]!
                                : Colors.grey[200]!,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.business_rounded,
                                    color: mainColor,
                                    size: 18,
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Text(
                                      'Nome Sede',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              TextFormField(
                                controller: controller,
                                autofocus: true,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Inserisci il nome della sede...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11.sp,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 2.h,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: isDarkMode
                                      ? Color(0xFF2D2D2D)
                                      : Colors.white,
                                  errorStyle: TextStyle(
                                    fontSize: 9.sp,
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Questo campo è obbligatorio';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Action Buttons
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Cancel Button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context, null);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: BorderSide(
                                    color: Colors.red.withValues(alpha: 0.3)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 1.8.h),
                              ),
                              child: Text(
                                'Annulla',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 3.w),

                          // Confirm Button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  Classes? val;
                                  if (name != null) {
                                    val = await Classes.editClass(
                                        controller.text, id!);
                                  } else {
                                    val =
                                        await Classes.addClass(controller.text);
                                  }
                                  Navigator.pop(context, val);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 1.8.h),
                              ),
                              child: Text(
                                name != null ? 'Salva Modifiche' : 'Crea Sede',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  ).then((value) {
    v = value;
  });

  return v;
}
