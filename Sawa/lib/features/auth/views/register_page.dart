import 'package:chat_setup/features/auth/views/widgets/auth_animation.dart';
import 'package:chat_setup/features/auth/views/widgets/auth_background.dart';
import 'package:chat_setup/features/auth/views/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
    return Scaffold(
      body: AuthBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AuthAnimation(asset: 'assets/anim/Welcome.json'),
                const Text(
                  'Create Account ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                const RegisterForm(),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'لديك حساب؟ تسجيل الدخول',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
