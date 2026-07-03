import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void>? _initFuture;
  StreamSubscription<String>? _tokenSub;
  String? _lastUid;

  Future<void> initAndSaveToken() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Future.value();

    if (_lastUid != uid) {
      _lastUid = uid;
      _initFuture = null;
    }

    _initFuture ??= _initInternal(uid);
    return _initFuture!;
  }

  Future<void> _initInternal(String uid) async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    final token = await _messaging.getToken();
    if (token != null) {
      await _saveToken(uid, token);
    }

    await _tokenSub?.cancel();
    _tokenSub = _messaging.onTokenRefresh.listen((newToken) async {
      final currentUid = _auth.currentUser?.uid;
      if (currentUid == null) return;
      await _saveToken(currentUid, newToken);
    });
  }

  Future<void> _saveToken(String uid, String token) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'fcmToken': token,
        'platform': Platform.isAndroid ? 'android' : 'ios',
        'lastActive': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {
      // Ignore errors
      debugPrint('Failed to save FCM token');
    }
  }

  Future<void> reset() async {
    _initFuture = null;
    _lastUid = null;
    await _tokenSub?.cancel();
    _tokenSub = null;
  }
}
