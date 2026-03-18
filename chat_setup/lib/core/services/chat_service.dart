import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/message_model.dart';
import '../utils/password_helper.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _chats => _firestore.collection('chats');

  // Cache لتقليل reads
  final Map<String, bool> _userExistsCache = {};

  String getChatId(String a, String b) {
    final ids = [a, b]..sort();
    return ids.join('_');
  }

  // ======================
  // Messages (لا side-effects)
  // ======================
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _chats
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // لو ما زلت محتاج تنظيف الأعضاء، استدعيه مرة واحدة عند فتح الشات (من Controller/UI)
  Future<void> refreshMembersIfNeeded(String chatId) async {
    await _filterDeletedUsers(chatId);
  }

  Future<void> ensureSelfChatExists(String userId) async {
    final chatId = getChatId(userId, userId);
    final ref = _chats.doc(chatId);
    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({
        'members': [userId],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': 'Welcome to your private space!',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'isSelfChat': true,
      });
    }
  }

  Future<void> ensureChatExists({
    required String chatId,
    required List<String> members,
  }) async {
    final validMembers = await _verifyMembersExist(members);
    if (validMembers.isEmpty) {
      throw Exception('Some members do not exist in Firebase');
    }

    final ref = _chats.doc(chatId);
    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({
        'members': validMembers,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': null,
        'hasPassword': false,
        // per-user maps (اختياري)
        'muted': <String, bool>{},
        'deletedFor': <String, bool>{},
      });
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required MessageModel message,
    required List<String> members,
  }) async {
    final validMembers = await _verifyMembersExist(members);
    if (validMembers.isEmpty) {
      throw Exception('Some members do not exist in Firebase');
    }

    final chatRef = _chats.doc(chatId);

    await chatRef.set({
      'members': validMembers,
      'lastMessage': message.text,
      'lastMessageTime': Timestamp.fromDate(message.createdAt),
    }, SetOptions(merge: true));

    // Set canEditUntil to 5 minutes from now
    final messageData = message.toMap();
    messageData['canEditUntil'] = Timestamp.fromDate(
      message.createdAt.add(const Duration(minutes: 5)),
    );

    await chatRef.collection('messages').add(messageData);
  }

  Future<void> shareWebsiteLink({
    required String chatId,
    required String senderId,
    required String websiteUrl,
    required List<String> members,
  }) async {
    await sendMessage(
      chatId: chatId,
      message: MessageModel(
        id: '',
        text: 'My website: $websiteUrl',
        senderId: senderId,
        receiverId: '',
        createdAt: DateTime.now(),
        isSeen: false,
      ),
      members: members,
    );
  }

  Future<void> sendMediaMessage({
    required String chatId,
    required String senderId,
    required String mediaUrl,
    required String mediaType,
    required List<String> members,
    String text = '',
  }) async {
    final message = MessageModel(
      id: '',
      text: text,
      mediaUrl: mediaUrl,
      mediaType: mediaType,
      senderId: senderId,
      receiverId: '',
      createdAt: DateTime.now(),
      isSeen: false,
    );

    await sendMessage(
      chatId: chatId,
      message: message,
      members: members,
    );
  }

  Future<void> forwardMessage({
    required String targetChatId,
    required MessageModel originalMessage,
    required String senderId,
  }) async {
    final targetChatRef = _chats.doc(targetChatId);

    final newMessageData = originalMessage.toMap();
    newMessageData['senderId'] = senderId;
    newMessageData['createdAt'] = FieldValue.serverTimestamp();
    newMessageData['isForwarded'] = true;
    newMessageData['isSeen'] = false;
    newMessageData['seenAt'] = null;

    await targetChatRef.collection('messages').add(newMessageData);

    await targetChatRef.update({
      'lastMessage': originalMessage.text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  Future<void> editMessage({
    required String chatId,
    required String messageId,
    required String newText,
    required String userId,
  }) async {
    final messageRef =
        _chats.doc(chatId).collection('messages').doc(messageId);
    final doc = await messageRef.get();

    if (!doc.exists) {
      throw Exception('Message does not exist');
    }

    final data = doc.data() as Map<String, dynamic>;
    final senderId = data['senderId'];
    final createdAt = (data['createdAt'] as Timestamp).toDate();
    final editCount = data['editCount'] ?? 0;
    final canEditUntil = data['canEditUntil'] != null
        ? (data['canEditUntil'] as Timestamp).toDate()
        : createdAt.add(const Duration(minutes: 5));

    if (senderId != userId) {
      throw Exception('You can only edit your own messages');
    }

    if (DateTime.now().isAfter(canEditUntil)) {
      throw Exception('Edit time limit exceeded (5 minutes)');
    }

    if (editCount >= 3) {
      throw Exception('Maximum edit limit reached (3 times)');
    }

    await messageRef.update({
      'text': newText,
      'isEdited': true,
      'editedAt': FieldValue.serverTimestamp(),
      'editCount': editCount + 1,
    });
  }

  // ======================
  // Seen (Batch + Limit)
  // ======================
  Future<void> markMessagesAsSeen(String chatId, String myId) async {
    final q = await _chats
        .doc(chatId)
        .collection('messages')
        // الأفضل لو عندك receiverId: .where('receiverId', isEqualTo: myId)
        .where('senderId', isNotEqualTo: myId)
        .where('isSeen', isEqualTo: false)
        .limit(200)
        .get();

    if (q.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final d in q.docs) {
      batch.update(d.reference, {'isSeen': true});
    }
    await batch.commit();
  }

  Future<void> markMessagesAsDelivered(String chatId, String myId) async {
    final q = await _chats
        .doc(chatId)
        .collection('messages')
        .where('senderId', isNotEqualTo: myId)
        .where('isDelivered', isEqualTo: false)
        .limit(200)
        .get();

    if (q.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final d in q.docs) {
      batch.update(d.reference, {
        'isDelivered': true,
        'deliveredAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  // ======================
  // Typing
  // ======================
  Stream<bool> typingStream({
    required String otherUserId,
    required String myId,
  }) {
    return _firestore
        .collection('users')
        .doc(otherUserId)
        .snapshots()
        .map((doc) => doc.data()?['typingTo'] == myId);
  }

  Future<void> setTyping({
    required String myId,
    required String? typingTo,
  }) async {
    await _firestore.collection('users').doc(myId).update({
      'typingTo': typingTo,
    });
  }

  // ======================
  // Password
  // ======================
  Future<void> setChatPassword(String chatId, String password) async {
    await _chats.doc(chatId).update({
      'hasPassword': true,
      'passwordHash': PasswordHelper.hash(password),
    });
  }

  // ======================
  // Mute / Delete (per-user)
  // ======================
  Future<void> muteChatForUser({
    required String chatId,
    required String userId,
    required bool muted,
  }) async {
    await _chats.doc(chatId).set({
      'muted': {userId: muted},
    }, SetOptions(merge: true));
  }

  Future<void> deleteChatForUser({
    required String chatId,
    required String userId,
    required bool deleted,
  }) async {
    await _chats.doc(chatId).set({
      'deletedFor': {userId: deleted},
    }, SetOptions(merge: true));
  }

  // ======================
  // Message Actions (Delete/Report)
  // ======================

  Future<void> deleteMessageForMe({
    required String chatId,
    required String messageId,
    required String userId,
  }) async {
    await _chats.doc(chatId).collection('messages').doc(messageId).update({
      'deletedFor': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> deleteMessageForEveryone({
    required String chatId,
    required String messageId,
    String deletedText = 'Message deleted',
  }) async {
    await _chats.doc(chatId).collection('messages').doc(messageId).update({
      'isDeleted': true,
      'text': deletedText,
      'mediaUrl': null,
      'mediaType': null,
    });
  }

  Future<void> reportMessage({
    required String chatId,
    required String messageId,
    required String reporterId,
    required String reason,
  }) async {
    // 1) Mark message as reported
    await _chats.doc(chatId).collection('messages').doc(messageId).update({
      'isReported': true,
    });

    // 2) Store report in a separate collection
    await _firestore.collection('reports').add({
      'chatId': chatId,
      'messageId': messageId,
      'reporterId': reporterId,
      'reason': reason,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // ======================
  // Helpers
  // ======================
  Future<List<String>> _verifyMembersExist(List<String> members) async {
    final validMembers = <String>[];

    for (final memberId in members.toSet()) {
      // cache hit
      final cached = _userExistsCache[memberId];
      if (cached == true) {
        validMembers.add(memberId);
        continue;
      }
      if (cached == false) {
        continue;
      }

      try {
        final userDoc = await _firestore
            .collection('users')
            .doc(memberId)
            .get();
        final exists = userDoc.exists;
        _userExistsCache[memberId] = exists;
        if (exists) validMembers.add(memberId);
      } catch (e) {
        _userExistsCache[memberId] = false;
        if (kDebugMode) {
          // ignore: avoid_print
          print('User check failed: $memberId => $e');
        }
      }
    }

    return validMembers;
  }

  Future<void> _filterDeletedUsers(String chatId) async {
    final chatDoc = await _chats.doc(chatId).get();
    if (!chatDoc.exists) return;

    final data = chatDoc.data() as Map<String, dynamic>?;
    final members = List<String>.from(data?['members'] ?? const <String>[]);

    if (members.isEmpty) return;

    final validMembers = await _verifyMembersExist(members);

    if (validMembers.length != members.length) {
      await _chats.doc(chatId).update({'members': validMembers});
    }
  }

  // ======================
  // Extra helpers (minimal & safe)
  // ======================
  Future<void> attachFileToLastMessage({
    required String chatId,
    required String fileUrl,
    required String senderId,
  }) async {
    final q = await _chats
        .doc(chatId)
        .collection('messages')
        .where('senderId', isEqualTo: senderId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (q.docs.isEmpty) return;

    await q.docs.first.reference.update({'fileUrl': fileUrl});
  }

  /// mute per user
  Future<void> muteChat({
    required String chatId,
    required String userId,
    required bool muted,
  }) async {
    await _chats.doc(chatId).set({
      'muted': {userId: muted},
    }, SetOptions(merge: true));
  }

  /// delete for user
  // Future<void> deleteChatForUser({
  //   required String chatId,
  //   required String userId,
  //   required bool deleted,
  // }) async {
  //   await _chats.doc(chatId).set(
  //     {
  //       'deletedFor': {userId: deleted}
  //     },
  //     SetOptions(merge: true),
  //   );
  // }
}
