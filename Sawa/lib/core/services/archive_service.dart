import 'package:cloud_firestore/cloud_firestore.dart';

class ArchiveService {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference userChats(String userId) {
    return _firestore.collection('user_chats').doc(userId).collection('chats');
  }

  Future<void> setArchived({
    required String userId,
    required String chatId,
    required bool archived,
  }) async {
    await userChats(userId).doc(chatId).set({
      'archived': archived,
      'updatedAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> archivedChats(String userId) {
    return userChats(userId).where('archived', isEqualTo: true).snapshots();
  }

  Stream<QuerySnapshot> activeChats(String userId) {
    return userChats(userId).where('archived', isEqualTo: false).snapshots();
  }
}
