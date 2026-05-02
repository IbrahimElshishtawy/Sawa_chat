import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  RxBool notificationsEnabled = true.obs;
  RxBool callNotificationsEnabled = true.obs;

  static const _notifKey = 'notifications';
  static const _callNotifKey = 'call_notifications';

  @override
  void onInit() {
    loadSettings();
    super.onInit();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    notificationsEnabled.value = prefs.getBool(_notifKey) ?? true;
    callNotificationsEnabled.value = prefs.getBool(_callNotifKey) ?? true;
  }

  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifKey, value);
  }

  Future<void> toggleCallNotifications(bool value) async {
    callNotificationsEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_callNotifKey, value);
  }
}
