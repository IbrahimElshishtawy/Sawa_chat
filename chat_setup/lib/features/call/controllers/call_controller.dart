import 'dart:async';
import 'package:chat_setup/core/models/call_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';


import '../../../core/services/call_service.dart';

class CallController extends GetxController {
  final CallService _service = CallService();

  final calls = <CallModel>[].obs;
  final Rx<CallModel?> incomingCall = Rx<CallModel?>(null);

  StreamSubscription<User?>? _authSub;
  StreamSubscription? _incomingSub;
  StreamSubscription? _historySub;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();

    // ✅ نسمع لتغير حالة تسجيل الدخول
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _start(user.uid);
      } else {
        _clear();
      }
    });
  }

  void _start(String uid) {
    _incomingSub?.cancel();
    _historySub?.cancel();

    // 📞 سجل المكالمات
    _historySub = _service.callHistory(uid).listen((list) {
      calls.assignAll(list);
    });

    // 📲 مكالمة واردة
    _incomingSub = _service.listenIncomingCalls(uid).listen((
      QuerySnapshot snap,
    ) {
      if (snap.docs.isEmpty) {
        incomingCall.value = null;
        return;
      }

      final data = snap.docs.first.data() as Map<String, dynamic>;
      incomingCall.value = CallModel.fromMap(data);
    });
  }

  void _clear() {
    calls.clear();
    incomingCall.value = null;
    _incomingSub?.cancel();
    _historySub?.cancel();
  }

  // =========================
  // Actions
  // =========================

  Future<void> acceptCall(String callId) async {
    await _service.updateCallStatus(callId, CallStatus.accepted);
  }

  Future<void> rejectCall(String callId) async {
    await _service.updateCallStatus(callId, CallStatus.rejected);
    incomingCall.value = null;
  }

  Future<void> endCall(String callId) async {
    await _service.updateCallStatus(callId, CallStatus.ended);
    incomingCall.value = null;
  }

  bool isMissed(CallModel call) {
    final uid = _uid;
    if (uid == null) return false;
    return call.status == CallStatus.missed && call.receiverId == uid;
  }

  @override
  void onClose() {
    _authSub?.cancel();
    _incomingSub?.cancel();
    _historySub?.cancel();
    super.onClose();
  }
}
