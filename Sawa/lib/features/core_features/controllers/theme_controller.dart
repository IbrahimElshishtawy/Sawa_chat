import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  final RxBool isDark = false.obs;

  ThemeMode get mode => isDark.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDark.toggle();
    Get.changeThemeMode(mode);
  }
}
