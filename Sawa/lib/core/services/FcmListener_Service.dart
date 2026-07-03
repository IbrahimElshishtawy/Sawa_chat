// ignore_for_file: file_names

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FcmListenerService {
  void listen() {
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      // اعرض Snackbar / Local Notification
      final title = msg.notification?.title ?? '';
      final body = msg.notification?.body ?? '';
      if (title.isNotEmpty || body.isNotEmpty) {
        Get.snackbar(title, body);
      }
    });

    // لما المستخدم يضغط على الإشعار والتطبيق كان بالخلفية
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      // افتح شاشة معينة (مثلاً شات)
      final chatId = msg.data['chatId'];
      if (chatId != null) {
        // Get.toNamed('/chat', arguments: chatId);
      }
    });
  }
}
