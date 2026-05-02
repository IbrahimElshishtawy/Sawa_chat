import 'package:chat_setup/features/auth/views/widgets/auth_animation.dart';
import 'package:chat_setup/features/auth/views/widgets/auth_background.dart';
import 'package:chat_setup/features/auth/views/widgets/confirm_page.dart';
import 'package:chat_setup/features/auth/views/widgets/login_button.dart';
import 'package:chat_setup/features/auth/views/widgets/login_form.dart';
import 'package:chat_setup/features/auth/views/widgets/login_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:chat_setup/features/auth/controllers/auth_controller.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<AuthController>();
    final isDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
    Get.put(LoginFormController());
    Future<void> onLogin() async {
      final c = Get.find<LoginFormController>();
      final auth = Get.find<AuthController>();

      if (!c.formKey.currentState!.validate()) return;

      final success = await auth.login(
        c.emailCtrl.text.trim(),
        c.passCtrl.text,
      );

      if (!success) return;

      Get.off(() => ConfirmPage(onDone: () => Get.offAllNamed('/home')));
    }

    return Scaffold(
      body: AuthBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const AuthAnimation(asset: 'assets/anim/Phoenix Dancing.json'),
                const SizedBox(height: 10),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Welcome Back',
                          speed: const Duration(milliseconds: 80),
                          textStyle: TextStyle(
                            fontSize: 26,
                            color: isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    const LoginForm(),
                    const SizedBox(height: 24),

                    LoginButton(onPressed: onLogin),

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: () {
                        Get.to(
                          () => const RegisterPage(),
                          transition: Transition.fade,
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 500),
                        );
                      },
                      child: Text(
                        'إنشاء حساب جديد',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
