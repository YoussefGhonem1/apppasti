import 'package:pasti/models/school.dart';

import '../../../../helper_functions/api.dart';
import '../../../../helper_functions/loading.dart';
import '../../../../helper_functions/navigation.dart';
import '../../../../shared/dialogs.dart';
import '../../../models/meal.dart';
import '../../../models/order.dart';
import '../../../models/student.dart';

Future<bool> cancelOrderFunction(context, int id, bool fromSchool) async {
  loading(context);
  try {
    Map apiData = await handleApi(context, route: 'user/cancel_order', header: {
      // "Authorization":'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9sb2NhbGhvc3RcL2FwcCUyMHBhc3RpXC9wdWJsaWNcL2FwaVwvdXNlclwvcmVnaXN0ZXIiLCJpYXQiOjE2NjY0NDA0OTEsIm5iZiI6MTY2NjQ0MDQ5MSwianRpIjoiVFRYcm9valVkOHR3SUNGYSIsInN1YiI6NSwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.dIaCdWWlQ6TVKQhbvapo7zXrJEHiD19FjH_2oxpQkXA'
      "Authorization": fromSchool ? school.token : student.token
    }, data: {
      "id": id
    });
    navPop(context);
    if (apiData['status'] == 1) {
      return true;
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {}
  return false;
}

Future<bool> endOrderFunction(context, int id, bool fromSchool) async {
  loading(context);
  try {
    Map apiData = await handleApi(context,
        route: 'user/end_order',
        header: {"Authorization": fromSchool ? school.token : student.token},
        data: {"id": id});
    navPop(context);
    if (apiData['status'] == 1) {
      return true;
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {}
  return false;
}

Future<List<MealStudent>> getOrderMeal(
    context, Order order, bool fromSchool) async {
  List<MealStudent> list = [];
  loading(context);
  try {
    Map apiData = await handleApi(context,
        route: 'user/get_order_meals?id=${order.id}',
        isPost: false,
        header: {"Authorization": fromSchool ? school.token : student.token});
    navPop(context);
    if (apiData['status'] == 1) {
      // for(var m in apiData['data']['data']['meals']){
      //
      // }
      list.add(MealStudent.fromJson(apiData['data']['data']['meals']));
      list.first.id = order.meals.first.id;
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {}
  return list;
}

Future<Map<String, dynamic>?> getQrCodeFunction(
    context, int id, bool fromSchool) async {
  try {
    Map apiData = await handleApi(context,
        route: 'order-details/$id/qr',
        // route: 'order-details/18593/qr',
        isPost: false,
        header: {"Authorization": fromSchool ? school.token : student.token});
    if (apiData['data']['status'] == 1) {
      return apiData['data'];
    } else if (apiData['data']['status'] == 2) {
      showSnackBar(context, apiData['data']['message']);
    }
  } catch (e) {
    print(e.toString());
  }
  return null;
}

Future<bool> verifyQrCodeFunction(context, String qrToken, int userId) async {
  loading(context);
  try {
    Map apiData = await handleApi(context, route: 'qr/verify', data: {
      "qr_token": qrToken,
      "user_id": userId,
    }, header: {
      "Authorization": school.token // Scan is done by School
    });
    navPop(context);
    if (apiData['status'] == 1) {
      return true;
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {
    navPop(context);
    print(e.toString());
  }
  return false;
}
