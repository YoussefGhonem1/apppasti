import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../helper_functions/navigation.dart';
import '../main.dart';
import '../screens/main_page/student/home/controller.dart';
import '../screens/main_page/student/notification/view.dart';
import 'notification.dart';

class NotificationLocalClass {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static Future notificationDet() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('test', 'c_name',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          playSound: true,
          channelShowBadge: true,
          channelDescription: 'c_des'),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future showNoti(
      {int? id,
      required String title,
      required String body,
      required String payload}) async {
    try {
      notificationsPlugin.show(id ?? DateTime.now().millisecond, title, body,
          await notificationDet(),
          payload: payload);
    } catch (e) {}
  }

  static Future init({bool initScheduled = false}) async {
    final settings = InitializationSettings(
      android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
          defaultPresentBadge: true),
    );
    await notificationsPlugin.initialize(settings,
        onDidReceiveNotificationResponse: (details) async {
      clickNoti(details.payload);
    });
  }
}

void clickNoti(String? pay) async {
  List<NotificationClass> list =
      await getNotificationFunction(GlobalVariable.navState.currentContext!);
  navP(GlobalVariable.navState.currentContext!, NotificationPage(list: list));
}
