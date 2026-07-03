import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/presence_service.dart';

class PresenceController extends GetxController with WidgetsBindingObserver {
  final _auth = FirebaseAuth.instance;
  final _service = PresenceService();

  String? get uid => _auth.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    final id = uid;
    if (id != null) {
      _service.setOnline(id);
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);

    final id = uid;
    if (id != null) {
      _service.setOffline(id);
    }
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final id = uid;
    if (id == null) return;

    if (state == AppLifecycleState.resumed) {
      _service.setOnline(id);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      _service.setOffline(id);
    }
  }
}
