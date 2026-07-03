// ignore_for_file: file_names

import 'dart:async';
import 'package:chat_setup/core/models/call_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../core/services/call_service.dart';

class CallHistoryController extends GetxController {
  final CallService _service = CallService();

  final calls = <CallModel>[].obs;

  StreamSubscription<User?>? _authSub;
  StreamSubscription<List<CallModel>>? _historySub;

  @override
  void onInit() {
    super.onInit();

    // ✅ اسمع لتغير حالة تسجيل الدخول
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _start(user.uid);
      } else {
        _clear();
      }
    });
  }

  void _start(String uid) {
    _historySub?.cancel();

    _historySub = _service.callHistory(uid).listen((list) {
      calls.assignAll(list);
    });
  }

  void _clear() {
    calls.clear();
    _historySub?.cancel();
  }

  @override
  void onClose() {
    _authSub?.cancel();
    _historySub?.cancel();
    super.onClose();
  }
}
