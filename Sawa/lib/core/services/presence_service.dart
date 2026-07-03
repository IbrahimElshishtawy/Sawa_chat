import 'package:cloud_firestore/cloud_firestore.dart';

class PresenceService {
  final _db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> ref(String uid) =>
      _db.collection('presence').doc(uid);

  Future<void> setOnline(String uid) async {
    await ref(uid).set({
      'isOnline': true,
      'updatedAt': FieldValue.serverTimestamp(),
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> setOffline(String uid) async {
    await ref(uid).set({
      'isOnline': false,
      'updatedAt': FieldValue.serverTimestamp(),
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watch(String uid) {
    return ref(uid).snapshots();
  }
}
