import 'package:chat_setup/core/models/group_model.dart';
import 'package:chat_setup/core/models/message_model.dart' show MessageModel;
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/services/group_service.dart';

class GroupController extends GetxController {
  final GroupService _service = GroupService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get uid => _auth.currentUser?.uid;

  Future<String> createGroup(String name, String description, List<String> members) async {
    final myId = uid;
    if (myId == null) throw Exception('Not logged in');

    final group = GroupModel(
      id: '',
      name: name,
      description: description,
      groupIcon: '',
      createdBy: myId,
      admins: [myId],
      members: [myId, ...members],
      createdAt: DateTime.now(),
    );

    return await _service.createGroup(group);
  }

  Future<void> sendGroupMessage(String groupId, String text) async {
    final myId = uid;
    if (myId == null) return;

    final message = MessageModel(
      id: '',
      text: text,
      senderId: myId,
      senderName: _auth.currentUser?.displayName ?? 'User',
      receiverId: '', // Group message
      createdAt: DateTime.now(),
      isSeen: false,
    );

    await _service.sendGroupMessage(groupId, message);
  }

  Stream getGroupMessages(String groupId) => _service.getGroupMessages(groupId);
  Stream<List<GroupModel>> getUserGroups() {
    final myId = uid;
    if (myId == null) return const Stream.empty();
    return _service.getUserGroups(myId);
  }

  Future<void> addMembers(String groupId, List<String> userIds) async {
    await _service.addMembers(groupId, userIds);
  }

  Future<void> removeMember(String groupId, String userId) async {
    await _service.removeMember(groupId, userId);
  }

  Future<void> promoteToAdmin(String groupId, String userId) async {
    await _service.updateGroupRole(groupId, userId, true);
  }
}
