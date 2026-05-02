// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // تضمين المكتبة

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // لون الخلفية
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // شكل الزر
          ),
        ),
        onPressed: () {
          // نص مخصص للمشاركة (يمكنك إضافة رابط للملف الشخصي هنا)
          final String profileContent =
              'Check out my profile on [App Name]! Here is the link: [profile_url]';

          // نشر المحتوى عبر التطبيقات المختلفة
          // ignore: deprecated_member_use
          Share.share(profileContent);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.share, color: Colors.white), // أيقونة المشاركة
            const SizedBox(width: 8),
            const Text(
              'Share Profile',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // لون النص
              ),
            ),
          ],
        ),
      ),
    );
  }
}
