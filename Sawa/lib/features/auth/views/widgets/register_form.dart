// ignore_for_file: deprecated_member_use

import 'package:chat_setup/features/auth/views/widgets/confirm_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_setup/features/auth/controllers/auth_controller.dart';
import 'login_button.dart';

enum RegisterMethod { email, phone }

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final auth = Get.find<AuthController>();

  RegisterMethod method = RegisterMethod.phone;

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool obscure = true;

  bool hasMinLength = false;
  bool hasUpper = false;
  bool hasNumber = false;
  bool hasSymbol = false;

  void _checkPassword(String value) {
    setState(() {
      hasMinLength = value.length >= 8;
      hasUpper = RegExp(r'[A-Z]').hasMatch(value);
      hasNumber = RegExp(r'[0-9]').hasMatch(value);
      hasSymbol = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
    });
  }

  bool get isPasswordValid =>
      hasMinLength && hasUpper && hasNumber && hasSymbol;

  Future<void> onRegister() async {
    if (nameCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      Get.snackbar('خطأ', 'من فضلك أدخل جميع البيانات');
      return;
    }

    if (method == RegisterMethod.phone && phoneCtrl.text.isEmpty) {
      Get.snackbar('خطأ', 'أدخل رقم الهاتف');
      return;
    }

    if (method == RegisterMethod.email && emailCtrl.text.isEmpty) {
      Get.snackbar('خطأ', 'أدخل البريد الإلكتروني');
      return;
    }

    if (!isPasswordValid) {
      Get.snackbar('كلمة المرور ضعيفة', 'يجب الالتزام بجميع الشروط');
      return;
    }

    bool success;

    if (method == RegisterMethod.phone) {
      success = await auth
          .registerWithPhone(phoneCtrl.text.trim(), passCtrl.text, {
            'name': nameCtrl.text.trim(),
            'phone': phoneCtrl.text.trim(),
            'role': 'user',
            'createdAt': DateTime.now(),
          });
    } else {
      success = await auth.register(emailCtrl.text.trim(), passCtrl.text, {
        'name': nameCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
        'role': 'user',
        'createdAt': DateTime.now(),
      });
    }

    if (!success) return;

    Get.off(() => ConfirmPage(onDone: () => Get.offAllNamed('/home')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///  Register Method Switch
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              _methodButton(
                title: 'رقم الهاتف',
                icon: Icons.phone_rounded,
                selected: method == RegisterMethod.phone,
                onTap: () => setState(() => method = RegisterMethod.phone),
              ),
              _methodButton(
                title: 'البريد الإلكتروني',
                icon: Icons.email_rounded,
                selected: method == RegisterMethod.email,
                onTap: () => setState(() => method = RegisterMethod.email),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        ///  Name
        TextField(
          controller: nameCtrl,
          decoration: _decoration(
            context,
            label: 'الاسم',
            icon: Icons.person_rounded,
          ),
        ),

        const SizedBox(height: 16),

        ///  Phone OR  Email
        if (method == RegisterMethod.phone)
          TextField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: _decoration(
              context,
              label: 'رقم الهاتف',
              icon: Icons.phone_rounded,
            ),
          ),

        if (method == RegisterMethod.email)
          TextField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: _decoration(
              context,
              label: 'البريد الإلكتروني',
              icon: Icons.email_rounded,
            ),
          ),

        const SizedBox(height: 16),

        ///  Password
        TextField(
          controller: passCtrl,
          obscureText: obscure,
          onChanged: _checkPassword,
          decoration: _decoration(
            context,
            label: 'كلمة المرور',
            icon: Icons.lock_rounded,
            suffix: IconButton(
              onPressed: () => setState(() => obscure = !obscure),
              icon: Icon(
                obscure
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        ///  Password Rules
        _rule('٨ أحرف على الأقل', hasMinLength),
        _rule('حرف كابتل (A-Z)', hasUpper),
        _rule('رقم (0-9)', hasNumber),
        _rule('رمز خاص (!@#)', hasSymbol),

        const SizedBox(height: 24),

        ///  Button
        LoginButton(onPressed: onRegister),
      ],
    );
  }

  Widget _methodButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rule(String text, bool ok) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: ok ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              color: ok ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(
    BuildContext context, {
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withOpacity(0.95),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
    );
  }
}
