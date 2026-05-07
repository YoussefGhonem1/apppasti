import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pasti/main.dart';
import 'package:pasti/models/school.dart';
import 'package:pasti/screens/main_page/student/home/controller.dart';

import '../../../../../../helper_functions/api.dart';
import '../../../../../../helper_functions/loading.dart';
import '../../../../../../helper_functions/navigation.dart';
import '../../../../../../models/cart.dart';
import '../../../../../../models/student.dart';
import '../../../../../../shared/dialogs.dart';

List<Cart> cart = [];
List<int> deletedOrders = [];

bool find(int id) {
  for (var c in cart) {
    if (c.id == id) {
      return true;
    }
  }
  return false;
}

void deleteItemCart(List list) {
  for (var i in list) {
    cart.removeWhere((element) => element.id == i);
  }
}

int getIndex(int id) {
  for (int i = 0; i < cart.length; i++) {
    if (cart[i].id == id) {
      return i;
    }
  }
  return 0;
}

Future createOrder(context, int date, bool fromSchool) async {
  loading(context);
  try {
    List<Map<String, int>> data = [];
    List<Map<String, int>> deleted = [];
    for (var c in cart) {
      data.add({'menu_id': c.id});
    }
    for (var d in deletedOrders) {
      deleted.add({'menu_id': d});
    }
    Map apiData = await handleApi(context,
        route: '${fromSchool ? 'school' : 'user'}/store_order',
        header: {"Authorization": fromSchool ? school.token : student.token},
        formData:
            FormData.fromMap({"details": data, "deleted_orders": deleted}));
    print(apiData);
    navPop(context);
    if (apiData['status'] == 1) {
      cart.clear();
      deletedOrders.clear();
      successDialog(context, msg: 'L`ordine è stato inviato con successo',
          then: () async {
        // await getOrdersFunction(context);
        for (var m in mealsList) {
          m.id = 0;
        }
        navPop(GlobalVariable.navState.currentContext!);
      });
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {
    print(e);
  }
}

Future updateOrder(context, int date, bool fromSchool, int orderId) async {
  loading(context);
  try {
    List<Map<String, int>> data = [];
    for (var c in cart) {
      data.add({'menu_id': c.id});
    }
    Map apiData = await handleApi(context,
        route: 'user/update_order',
        header: {"Authorization": fromSchool ? school.token : student.token},
        formData: FormData.fromMap({
          "id": orderId,
          "details": data,
        }));
    navPop(context);
    if (apiData['status'] == 1) {
      cart.clear();
      successDialog(context, msg: 'L`ordine è stato inviato con successo',
          then: () async {
        // await getOrdersFunction(context);
        for (var m in mealsList) {
          m.id = 0;
        }
        navPop(GlobalVariable.navState.currentContext!);
        navPop(GlobalVariable.navState.currentContext!);
        Navigator.pop(GlobalVariable.navState.currentContext!, 'Update');
      });
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {}
}
