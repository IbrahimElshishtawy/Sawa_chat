import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  /* =============================
      Follow
  ============================== */
  Future<void> follow(String userId) async {
    final batch = _firestore.batch();

    batch.set(
      _firestore
          .collection('following')
          .doc(uid)
          .collection('users')
          .doc(userId),
      {'since': FieldValue.serverTimestamp()},
    );

    batch.set(
      _firestore
          .collection('followers')
          .doc(userId)
          .collection('users')
          .doc(uid),
      {'since': FieldValue.serverTimestamp()},
    );

    await batch.commit();
  }

  /* =============================
      Unfollow
  ============================== */
  Future<void> unfollow(String userId) async {
    final batch = _firestore.batch();

    batch.delete(
      _firestore
          .collection('following')
          .doc(uid)
          .collection('users')
          .doc(userId),
    );

    batch.delete(
      _firestore
          .collection('followers')
          .doc(userId)
          .collection('users')
          .doc(uid),
    );

    await batch.commit();
  }

  /* =============================
      Counts
  ============================== */
  Stream<int> followersCount(String userId) {
    return _firestore
        .collection('followers')
        .doc(userId)
        .collection('users')
        .snapshots()
        .map((s) => s.docs.length);
  }

  Stream<int> followingCount() {
    return _firestore
        .collection('following')
        .doc(uid)
        .collection('users')
        .snapshots()
        .map((s) => s.docs.length);
  }

  /* =============================
      Check Status
  ============================== */
  Stream<bool> isFollowing(String userId) {
    return _firestore
        .collection('following')
        .doc(uid)
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists);
  }
}
