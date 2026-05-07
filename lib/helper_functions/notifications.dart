import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:pasti/models/local_notifications.dart';

bool appOpen = false;
bool inChat = false;
bool startNoti = false;
// late Map dataNoti;
bool inApp = false;
final player = AudioPlayer();

// Since we are removing Firebase, this function will now be empty or removed.
// However, since it might be called from elsewhere (though I removed the call in main),
// I will keep the file but remove the firebase logic.
// The main.dart call was removed, so this function is effectively dead code,
// but the variables like appOpen might be used elsewhere.

// Replacing with a safe version that doesn't use Firebase types
void appNotifications(dynamic data, {bool click = false, bool start = false}) {
  // START: Notification handling logic (simplified/stubbed)
  if (Platform.isAndroid) {
    final player = AudioPlayer();
    player.play(AssetSource('sound.mp3')).then((value) {});
  }
  // Try to extract title/body if data follows a known structure, or just show generic
  String title = "";
  String body = "";

  if (data is Map) {
    title = data['title'] ?? "";
    body = data['body'] ?? "";
  }

  NotificationLocalClass.showNoti(title: title, body: body, payload: '');
}
