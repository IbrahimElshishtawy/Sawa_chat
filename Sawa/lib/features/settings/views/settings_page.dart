import 'package:chat_setup/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_setup/features/core_features/controllers/theme_controller.dart';
import 'package:chat_setup/features/settings/controllers/settings_controller.dart';
import 'package:chat_setup/features/auth/controllers/auth_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();
    final settingsCtrl = Get.find<SettingsController>();
    final authCtrl = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: Obx(
        () => ListView(
          children: [
            const SizedBox(height: 8),

            SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeCtrl.isDark.value,
              onChanged: (_) => themeCtrl.toggleTheme(),
            ),

            const Divider(),

            SwitchListTile(
              title: const Text('الإشعارات'),
              value: settingsCtrl.notificationsEnabled.value,
              onChanged: settingsCtrl.toggleNotifications,
              secondary: const Icon(Icons.notifications),
            ),

            SwitchListTile(
              title: const Text('إشعارات المكالمات'),
              value: settingsCtrl.callNotificationsEnabled.value,
              onChanged: settingsCtrl.toggleCallNotifications,
              secondary: const Icon(Icons.call),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('اللغة'),
              subtitle: const Text('العربية (قريبًا لغات أخرى)'),
              onTap: () {
                Get.snackbar('قريبًا', 'سيتم إضافة تغيير اللغة قريبًا');
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await authCtrl.logout();
                Get.offAllNamed(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
