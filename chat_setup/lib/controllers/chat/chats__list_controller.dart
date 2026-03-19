import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatItem {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String? lastMessage;
  final bool isSelfChat;

  ChatItem({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    this.lastMessage,
    this.isSelfChat = false,
  });
}

class ChatsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<ChatItem> chats = <ChatItem>[].obs;

  String? get uid => _auth.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    _listenToChats();
  }

  void _listenToChats() {
    final myId = uid;
    if (myId == null) return;

    _firestore
        .collection('chats')
        .where('members', arrayContains: myId)
        .snapshots()
        .listen((snapshot) async {
          final List<ChatItem> items = [];

          for (final doc in snapshot.docs) {
            final data = doc.data();
            final members = List<String>.from(data['members'] ?? []);
            final isSelfChat = data['isSelfChat'] ?? (members.length == 1 && members.contains(myId));

            String otherUserId = myId;
            String otherUserName = 'Saved Messages';

            if (!isSelfChat) {
              otherUserId = members.firstWhere((id) => id != myId, orElse: () => myId);
              final userDoc = await _firestore
                  .collection('users')
                  .doc(otherUserId)
                  .get();
              otherUserName = userDoc.data()?['name'] ?? 'مستخدم';
            }

            items.add(
              ChatItem(
                id: doc.id,
                otherUserId: otherUserId,
                otherUserName: otherUserName,
                lastMessage: data['lastMessage'],
                isSelfChat: isSelfChat,
              ),
            );
          }

          // Pin self-chat to top
          items.sort((a, b) {
            if (a.isSelfChat) return -1;
            if (b.isSelfChat) return 1;
            return 0;
          });

          chats.value = items;
        });
  }
}
