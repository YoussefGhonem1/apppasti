import 'dart:async';

import 'package:pasti/models/school.dart';
import 'package:pasti/models/student.dart';
import 'package:pasti/screens/auth/login/view.dart';
import 'package:pasti/screens/main_page/school/home/shcool.dart';
import 'package:pasti/screens/main_page/school/home/controller.dart';
import 'package:pasti/screens/main_page/student/home/menu/check_out/controller.dart';
import 'package:pasti/screens/main_page/student/home/view.dart';
import '../../kitchen/dashboard/view.dart';

import '../../../constants/var.dart';
import '../../../helper_functions/api.dart';
import '../../../helper_functions/loading.dart';
import '../../../helper_functions/navigation.dart';
import '../../../helper_functions/shared_pref.dart';
import '../../../shared/dialogs.dart';
import '../../main_page/student/home/controller.dart';
import '../../splash_screen/controller.dart';

String code = '+2';
Future loginFunction(context,
    {required String userName,
    required String pass,
    required bool fromLogin}) async {
  loading(context);
  while (token == 'null') {
    await getToken();
  }
  try {
    Map apiData =
        await handleApi(context, isFromLogin: true, route: 'login', data: {
      'user_name': userName,
      'password': pass,
      "fcm_token": token,
    });
    navPop(context);
    if (apiData['status'] == 1) {
      var responseData = apiData['data'];
      Map data;

      // Handle inconsistent API response structure (nested data vs direct data)
      if (responseData is Map && responseData.containsKey('data')) {
        data = responseData['data'];
      } else {
        data = responseData is Map ? responseData : {};
      }

      if (data['is_active'] == 'pending') {
        showSnackBar(context, 'Il tuo account è in fase di revisione');
        if (!fromLogin) {
          navPRRU(context, Login());
        }
      } else if (data['is_active'] == 'no') {
        showSnackBar(context, 'Il tuo account è disattivato');
        if (!fromLogin) {
          navPRRU(context, Login());
        }
      } else if (data['block'] == 'yes') {
        showSnackBar(context, 'Il tuo account è stato bannato');
        if (!fromLogin) {
          navPRRU(context, Login());
        }
      } else {
        cart.clear();
        prefs.setString('userName', userName);
        prefs.setString('pass', pass);

        if (data['role'] == 'kitchen') {
          var userData = data['user'];
          // Manually initialize global 'school' object as KitchenDashboard relies on it.
          // Mapping user fields to School fields where possible.
          school = School(
              id: int.parse(userData['id'].toString()),
              name: userData['name'],
              image: userData['image'] ?? '',
              token: userData['token'],
              code: '', // Default value
              address: userData['address'],
              block: false, // Default value
              isActive: userData['is_active'] == 'yes',
              userName: userData['user_name']);

          await prefs.setBool('login', true);
          await prefs.setInt('id', school.id ?? 0);
          await prefs.setBool('isSchool', false);
          await prefs.setString('apiToken', school.token ?? '');

          navPRRU(context, KitchenDashboard());
          return;
        }

        if (data.containsKey('school_id')) {
          student = Student.fromJson(data);

          school = School.fromJson(data['school']);

          loading(context);
          await unReadFunction(context, load: false);
          // await getOrdersFunction(context,load: false);
          await getMenuFunction(context, true);
          navPop(context);
          await prefs.setBool('login', true);
          await prefs.setInt('id', student.id);
          await prefs.setBool('isSchool', true);
          await prefs.setString('apiToken', student.token);
          navPRRU(context, Home());
        } else {
          school = School.fromJson(data);
          unReadSchoolFunction(context, load: false);
          await countsFunction(
            context,
          );
          await prefs.setBool('login', true);
          await prefs.setInt('id', school.id ?? 0);
          await prefs.setBool('isSchool', true);
          await prefs.setString('apiToken', school.token ?? '');
          navPRRU(context, SchoolHome());
        }
      }
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
      if (!fromLogin) {
        navPRRU(context, Login());
      }
    }
  } catch (e) {
    prefs.setBool('login', false);
    prefs.setInt('id', 0);
    prefs.setBool('isSchool', true);
    prefs.setString('apiToken', '');
    prefs.setString('pass', '');
    prefs.setString('userName', '');
    navPRRU(context, Login());
  }
}
