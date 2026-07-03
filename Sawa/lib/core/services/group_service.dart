import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group_model.dart';
import '../models/message_model.dart';

class GroupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _groups => _firestore.collection('groups');

  /// 🆕 Create Group
  Future<String> createGroup(GroupModel group) async {
    final docRef = await _groups.add(group.toMap());
    return docRef.id;
  }

  /// ➕ Add Members
  Future<void> addMembers(String groupId, List<String> userIds) async {
    await _groups.doc(groupId).update({
      'members': FieldValue.arrayUnion(userIds),
    });
  }

  /// ➖ Remove Member
  Future<void> removeMember(String groupId, String userId) async {
    await _groups.doc(groupId).update({
      'members': FieldValue.arrayRemove([userId]),
      'admins': FieldValue.arrayRemove([userId]), // Also remove from admins if they were one
    });
  }

  /// 👑 Update Role (Promote/Demote)
  Future<void> updateGroupRole(String groupId, String userId, bool isAdmin) async {
    if (isAdmin) {
      await _groups.doc(groupId).update({
        'admins': FieldValue.arrayUnion([userId]),
      });
    } else {
      await _groups.doc(groupId).update({
        'admins': FieldValue.arrayRemove([userId]),
      });
    }
  }

  /// ✉️ Send Group Message
  Future<void> sendGroupMessage(String groupId, MessageModel message) async {
    final groupRef = _groups.doc(groupId);

    await groupRef.collection('messages').add(message.toMap());

    await groupRef.update({
      'lastMessage': message.text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  /// 📥 Get Group Messages
  Stream<QuerySnapshot> getGroupMessages(String groupId) {
    return _groups
        .doc(groupId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// 📂 Get User's Groups
  Stream<List<GroupModel>> getUserGroups(String userId) {
    return _groups
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => GroupModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  /// 📝 Update Group Info
  Future<void> updateGroupInfo(String groupId, Map<String, dynamic> data) async {
    await _groups.doc(groupId).update(data);
  }
}
