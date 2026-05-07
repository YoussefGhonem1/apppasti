import 'package:pasti/models/notification.dart';
import 'package:pasti/models/order.dart';
import 'package:pasti/models/school.dart';
import 'package:pasti/models/student.dart';
import '../../../../helper_functions/api.dart';
import '../../../../helper_functions/loading.dart';
import '../../../../helper_functions/navigation.dart';
import '../../../../models/meal.dart';
import '../../../../shared/dialogs.dart';

import 'package:pasti/screens/main_page/student/home/menu/check_out/controller.dart';

int unRead = 0;

Future unReadFunction(context, {bool load = true}) async {
  if (load) loading(context);
  try {
    Map apiData = await handleApi(context,
        route: 'user/getNotificationsCount',
        isPost: false,
        header: {"Authorization": student.token});
    if (load) navPop(context);
    if (apiData['status'] == 1) {
      unRead = apiData['data']['data'];
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {}
}

Future unReadSchoolFunction(context, {bool load = true}) async {
  if (load) loading(context);
  try {
    Map apiData = await handleApi(context,
        route: 'school/getNotificationsCount',
        isPost: false,
        header: {"Authorization": student.token});
    if (load) navPop(context);
    if (apiData['status'] == 1) {
      unRead = apiData['data']['data'];
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {}
}

Future<List<NotificationClass>> getNotificationFunction(
  context,
) async {
  loading(context);
  List<NotificationClass> list = [];
  try {
    Map apiData = await handleApi(context,
        route: 'user/notifications',
        isPost: false,
        header: {"Authorization": student.token});
    navPop(context);
    if (apiData['status'] == 1) {
      for (var n in apiData['data']['data']) {
        list.add(NotificationClass.fromJson(n));
      }
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {}
  return list;
}

Future<List<NotificationClass>> getNotificationSchoolFunction(
  context,
) async {
  loading(context);
  List<NotificationClass> list = [];
  try {
    Map apiData = await handleApi(context,
        route: 'school/notifications',
        isPost: false,
        header: {"Authorization": school.token});
    navPop(context);
    if (apiData['status'] == 1) {
      for (var n in apiData['data']['data']) {
        list.add(NotificationClass.fromJson(n));
      }
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {}
  return list;
}

List<MealStudent> mealsList = [];
List<Order> orders = [];
Future getMenuFunction(context, bool load) async {
  mealsList.clear();
  cart.clear(); // Clear cart to avoid duplicates since MealStudent.fromJson repopulates it
  if (load) loading(context);
  try {
    Map apiData = await handleApi(context,
        route: 'user/get_school_meals',
        isPost: false,
        header: {"Authorization": student.token});
    if (load) navPop(context);
    if (apiData['status'] == 1) {
      for (var m in apiData['data']['data']['meals']) {
        mealsList.add(MealStudent.fromJson(m));
      }
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {}
}

Future getOrdersFunction(context,
    {bool load = true,
    bool fromSchool = false,
    int id = 0,
    bool filter = false,
    String from = '',
    String to = ''}) async {
  orders.clear();
  if (load) {
    loading(context);
  }
  String url = 'user/current_orders';
  if (fromSchool) {
    url = 'school/student_orders?student_id=$id';
  }
  if (filter) {
    url += '&from_date=$from&to_date=$to';
  }

  try {
    Map apiData = await handleApi(context, route: url, isPost: false, header: {
      // "Authorization":'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9sb2NhbGhvc3RcL2FwcCUyMHBhc3RpXC9wdWJsaWNcL2FwaVwvdXNlclwvcmVnaXN0ZXIiLCJpYXQiOjE2NjY0NDA0OTEsIm5iZiI6MTY2NjQ0MDQ5MSwianRpIjoiVFRYcm9valVkOHR3SUNGYSIsInN1YiI6NSwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.dIaCdWWlQ6TVKQhbvapo7zXrJEHiD19FjH_2oxpQkXA'
      "Authorization": fromSchool ? school.token : student.token
    });
    if (load) navPop(context);
    if (apiData['status'] == 1) {
      var data = apiData['data']['data'];
      if (fromSchool) {
        data = apiData['data']['data']['orders'];
      }
      for (var o in data) {
        orders.add(Order.fromJson(o));
      }
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {}
}

Future getOrdersMonthFunction(context,
    {bool load = true,
    bool filter = false,
    String from = '',
    String to = ''}) async {
  orders.clear();
  if (load) {
    loading(context);
  }
  String url = 'user/current_orders?from_date=$from&to_date=$to';

  try {
    Map apiData = await handleApi(context, route: url, isPost: false, header: {
      // "Authorization":'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9sb2NhbGhvc3RcL2FwcCUyMHBhc3RpXC9wdWJsaWNcL2FwaVwvdXNlclwvcmVnaXN0ZXIiLCJpYXQiOjE2NjY0NDA0OTEsIm5iZiI6MTY2NjQ0MDQ5MSwianRpIjoiVFRYcm9valVkOHR3SUNGYSIsInN1YiI6NSwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.dIaCdWWlQ6TVKQhbvapo7zXrJEHiD19FjH_2oxpQkXA'
      "Authorization": student.token
    });
    if (load) navPop(context);
    if (apiData['status'] == 1) {
      var data = apiData['data']['data'];
      for (var o in data) {
        orders.add(Order.fromJson(o));
      }
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {}
}

Future getOrdersSchoolFunction(
  context,
) async {
  orders.clear();
  loading(context);
  String url = 'school/current_orders';

  try {
    Map apiData = await handleApi(context,
        route: url, isPost: false, header: {"Authorization": school.token});
    navPop(context);
    if (apiData['status'] == 1) {
      var data = apiData['data']['data'];
      for (var o in data) {
        orders.add(Order.fromJson(o));
      }
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {}
}
