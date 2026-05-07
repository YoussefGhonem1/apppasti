import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pasti/models/new_student.dart';
import 'package:pasti/models/school.dart';
import 'package:pasti/models/student.dart';
import '../../../helper_functions/api.dart';
import '../../../helper_functions/loading.dart';
import '../../../helper_functions/navigation.dart';
import '../../../helper_functions/shared_pref.dart';
import '../../../screens/auth/login/view.dart';
import '../../../shared/dialogs.dart';
// int newCount = 0;

Future schoolUpdateFunction(context,
    {required List<TextEditingController> inputs, required File? img}) async {
  loading(
    context,
  );
  Map<String, dynamic> data;
  if (img == null) {
    data = {
      "name": inputs.first.text,
      "user_name": inputs[1].text,
      "address": inputs.last.text,
      // "phone":inputs[2].text,
    };
  } else {
    data = {
      "name": inputs.first.text,
      "user_name": inputs[1].text,
      "address": inputs.last.text,
      // "phone":inputs[2].text,
      "image": await MultipartFile.fromFile(img.path,
          filename: 'school${inputs.first.text}')
    };
  }
  try {
    Map apiData = await handleApi(context,
        route: 'school/update_profile',
        formData: FormData.fromMap(data),
        header: {"Authorization": school.token});
    navPop(context);
    if (apiData['status'] == 1) {
      school = School.fromJson(apiData['data']['data']);
      await prefs.setString('apiToken', school.token ?? '');
      successDialog(context, msg: 'La richiesta è stata inviata con successo',
          then: () {
        navPop(context);
      });
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {
    navPop(context);
  }
}

Future<List<NewStudent>> newStudentsFunction(
  context,
) async {
  loading(
    context,
  );
  List<NewStudent> list = [];
  try {
    Map apiData = await handleApi(context,
        route: 'school/new_students',
        isPost: false,
        header: {"Authorization": school.token});
    navPop(context);
    if (apiData['status'] == 1) {
      for (var s in apiData['data']['data']) {
        list.add(NewStudent.fromJson(s));
      }
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {
    navPop(context);
  }
  return list;
}

Future<bool> newStudentUpdateFunction(
    context, NewStudent student, bool accept) async {
  loading(
    context,
  );
  try {
    Map apiData =
        await handleApi(context, route: 'school/accept_refuse_student', data: {
      'student_id': student.id,
      'status': accept ? 'accept' : 'refuse',
    }, header: {
      "Authorization": school.token
    });
    navPop(context);
    if (apiData['status'] == 1) {
      successDialog(context, msg: 'Operazione riuscita');
      return true;
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {
    navPop(context);
  }
  return false;
}
// Future newCountFunction(context,
//     )async{
//
//   loading(context,);
//   try{
//     Map apiData = await handleApi(context, route: 'school/new_students_count',isPost: false,
//     header: {
//       "Authorization":school.token
//     });
//     navPop(context);
//     if(apiData['status']==1){
//       newCount = apiData['data']['data'];
//     }else if(apiData['status']==2){
//       showSnackBar(context, apiData['message']);
//     }
//   }catch(e){
//     navPop(context);
//     print(e);
//   }
// }

Future contactUsFunction(context,
    {required List<TextEditingController> inputs,
    required bool fromSchool}) async {
  loading(
    context,
  );
  try {
    Map apiData = await handleApi(
      context,
      route: 'contact_us',
      data: {
        'name': inputs[0].text,
        'mail': inputs[1].text,
        'subject': inputs[2].text,
        'message': inputs[3].text,
        (fromSchool ? "school_id" : "user_id"):
            (fromSchool ? school.id : student.id),
      },
    );
    navPop(context);
    if (apiData['status'] == 1) {
      successDialog(context, msg: 'Operazione riuscita');
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {
    navPop(context);
    print(e);
  }
}

Future logoutFunction(context, bool fromSchool, String? token) async {
  Map data = {
    "token": token,
  };
  if (fromSchool) {
    data['school_id'] = school.id;
  } else {
    data['user_id'] = student.id;
  }
  try {
    await handleApi(context,
        route: 'logout',
        header: {
          "Authorization": token ?? (fromSchool ? school.token : student.token)
        },
        data: data);
    await prefs.setBool('login', false);
    await prefs.setInt('id', 0);
    await prefs.setBool('isSchool', true);
    await prefs.setString('apiToken', '');
    await prefs.setString('pass', '');
    await prefs.setString('userName', '');
    navPRRU(context, Login());
  } catch (e) {
    print(e);
  }
}
