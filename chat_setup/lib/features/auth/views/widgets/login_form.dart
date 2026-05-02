// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_form_controller.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<LoginFormController>();
    final isDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
    return Form(
      key: c.formKey,
      child: Column(
        children: [
          /// 📧 Email Field
          Obx(() {
            final v = c.isEmailValid.value;

            IconData? icon;
            Color? color;

            if (v == true) {
              icon = Icons.verified_rounded;
              color = Colors.green;
            } else if (v == false) {
              icon = Icons.error_rounded;
              color = Colors.red;
            }

            return TextFormField(
              controller: c.emailCtrl,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني',
                hintText: 'example@email.com',
                prefixIcon: const Icon(Icons.email_rounded),
                suffixIcon: icon == null
                    ? null
                    : Icon(icon, color: color, size: 20),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.4,
                  ),
                ),
              ),
              validator: (value) {
                final text = (value ?? '').trim();
                if (text.isEmpty) return 'من فضلك أدخل البريد الإلكتروني';
                final ok = RegExp(
                  r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$',
                ).hasMatch(text);
                if (!ok) return 'البريد الإلكتروني غير صحيح';
                return null;
              },
            );
          }),

          const SizedBox(height: 18),

          Obx(() {
            return TextFormField(
              controller: c.passCtrl,
              obscureText: c.obscure.value,
              textInputAction: TextInputAction.done,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                prefixIcon: const Icon(Icons.lock_rounded),
                suffixIcon: IconButton(
                  onPressed: c.toggleObscure,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      c.obscure.value
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      key: ValueKey(c.obscure.value),
                    ),
                  ),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.4,
                  ),
                ),
              ),
              validator: (value) {
                final text = value ?? '';
                if (text.isEmpty) return 'من فضلك أدخل كلمة المرور';
                if (text.length < 6) {
                  return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                }
                return null;
              },
            );
          }),

          const SizedBox(height: 14),

          /// ☑ Remember Me + Forgot Password
          Obx(() {
            return Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: c.toggleRemember,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: c.rememberMe.value
                                  ? Theme.of(context).primaryColor
                                  : const Color.fromARGB(188, 253, 253, 253),
                              border: Border.all(
                                color: c.rememberMe.value
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                              ),
                            ),
                            child: c.rememberMe.value
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'تذكرني',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'نسيت كلمة المرور؟',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
