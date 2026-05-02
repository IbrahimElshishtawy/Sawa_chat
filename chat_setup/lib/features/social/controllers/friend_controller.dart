import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  /* =============================
     Send Friend Request
  ============================== */
  Future<void> sendFriendRequest(String toUserId) async {
    final docId = '${uid}_$toUserId';

    await _firestore.collection('friend_requests').doc(docId).set({
      'from': uid,
      'to': toUserId,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /* =============================
      Incoming Requests
  ============================== */
  Stream<QuerySnapshot> incomingRequests() {
    return _firestore
        .collection('friend_requests')
        .where('to', isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  /* =============================
      Sent Requests
  ============================== */
  Stream<QuerySnapshot> sentRequests() {
    return _firestore
        .collection('friend_requests')
        .where('from', isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  /* =============================
      Accept Request
  ============================== */
  Future<void> acceptRequest(String fromUserId) async {
    final requestId = '${fromUserId}_$uid';
    final batch = _firestore.batch();

    // Update request
    final reqRef = _firestore.collection('friend_requests').doc(requestId);
    batch.update(reqRef, {'status': 'accepted'});

    // Add to friends (both sides)
    batch.set(
      _firestore
          .collection('friends')
          .doc(uid)
          .collection('list')
          .doc(fromUserId),
      {'since': FieldValue.serverTimestamp()},
    );

    batch.set(
      _firestore
          .collection('friends')
          .doc(fromUserId)
          .collection('list')
          .doc(uid),
      {'since': FieldValue.serverTimestamp()},
    );

    await batch.commit();
  }

  /* =============================
      Reject / Remove
  ============================== */
  Future<void> rejectRequest(String fromUserId) async {
    final requestId = '${fromUserId}_$uid';
    await _firestore.collection('friend_requests').doc(requestId).delete();
  }

  Future<void> removeFriend(String friendId) async {
    final batch = _firestore.batch();

    batch.delete(
      _firestore
          .collection('friends')
          .doc(uid)
          .collection('list')
          .doc(friendId),
    );

    batch.delete(
      _firestore
          .collection('friends')
          .doc(friendId)
          .collection('list')
          .doc(uid),
    );

    await batch.commit();
  }

  /* =============================
      Friends List
  ============================== */
  Stream<QuerySnapshot> friendsStream() {
    return _firestore
        .collection('friends')
        .doc(uid)
        .collection('list')
        .snapshots();
  }
}
