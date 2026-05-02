import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickSettingsSheet extends StatelessWidget {
  const QuickSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          const SizedBox(height: 20),

          _item(
            icon: Icons.person_outline,
            text: 'الملف الشخصي',
            onTap: () => Get.toNamed('/profile'),
          ),

          _item(
            icon: Icons.settings_outlined,
            text: 'الإعدادات',
            onTap: () => Get.toNamed('/settings'),
          ),

          _item(icon: Icons.lock_outline, text: 'الخصوصية', onTap: () {}),

          _item(icon: Icons.help_outline, text: 'المساعدة', onTap: () {}),

          const Divider(height: 28),

          _item(
            icon: Icons.logout,
            text: 'تسجيل الخروج',
            color: Colors.red,
            onTap: () {
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      onTap: onTap,
    );
  }
}
