import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginFormController extends GetxController {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final rememberMe = false.obs;
  final obscure = true.obs;

  final isEmailValid = RxnBool();

  static const _kEmail = 'saved_email';
  static const _kPass = 'saved_password';
  static const _kRemember = 'remember_me';

  @override
  void onInit() {
    super.onInit();
    _loadSaved();
    emailCtrl.addListener(_validateEmail);
  }

  @override
  void onClose() {
    emailCtrl.removeListener(_validateEmail);
    emailCtrl.dispose();
    passCtrl.dispose();
    super.onClose();
  }

  void toggleRemember() {
    rememberMe.toggle();
  }

  void toggleObscure() => obscure.value = !obscure.value;
  // void toggleRemember(bool v) => rememberMe.value = v;

  void _validateEmail() {
    final text = emailCtrl.text.trim();
    if (text.isEmpty) {
      isEmailValid.value = null;
      return;
    }
    final ok = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$').hasMatch(text);
    isEmailValid.value = ok;
  }

  Future<void> saveIfRemembered() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_kRemember, rememberMe.value);

    if (rememberMe.value) {
      await prefs.setString(_kEmail, emailCtrl.text.trim());
      await prefs.setString(_kPass, passCtrl.text);
    } else {
      await prefs.remove(_kEmail);
      await prefs.remove(_kPass);
    }
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool(_kRemember) ?? false;
    rememberMe.value = remember;

    if (remember) {
      emailCtrl.text = prefs.getString(_kEmail) ?? '';
      passCtrl.text = prefs.getString(_kPass) ?? '';
    }
    _validateEmail();
  }
}
