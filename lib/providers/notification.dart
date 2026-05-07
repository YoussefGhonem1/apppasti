import 'package:pasti/helper_functions/small_functions.dart';
import 'package:flutter/material.dart';

class NotificationShowProvider extends ChangeNotifier {
  bool show = false;
  Map? data;
  String? pay;
  Future changeShow(Map noti, String payN) async {
    show = true;
    data = noti;
    pay = payN;
    notifyListeners();
    delay(2500).then((value) {
      show = false;
      notifyListeners();
    });
  }
}
