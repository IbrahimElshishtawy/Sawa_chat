// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';

class CompleteProfileButton extends StatelessWidget {
  const CompleteProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          // Navigate to Edit Profile Page
          Navigator.pushNamed(context, '/editProfile');
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.red, // يمكن تغييره حسب التصميم
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4), // تأثير الظل
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.edit, // يمكنك تغيير الأيقونة حسب الحاجة
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                'Complete Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
