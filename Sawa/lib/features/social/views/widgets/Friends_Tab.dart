// ignore_for_file: file_names

import 'package:chat_setup/features/chat/controllers/chat_controller.dart';
import 'package:chat_setup/features/social/controllers/friend_controller.dart';
import 'package:chat_setup/features/chat/views/chat_page.dart';
import 'package:chat_setup/features/social/views/widgets/Small_Btn.dart';
import 'package:chat_setup/features/social/views/widgets/User_Tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class FriendsTab extends StatelessWidget {
  final FriendController friendCtrl;
  final ChatController chatCtrl;
  final bool isDark;

  const FriendsTab({
    super.key,
    required this.friendCtrl,
    required this.chatCtrl,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: friendCtrl.friendsStream(),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(child: Text('لا يوجد أصدقاء حتى الآن'));
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final friendId = docs[i].id;

            return UserTile(
              userId: friendId,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SmallBtn(
                    label: 'رسالة',
                    filled: true,
                    onTap: () async {
                      final chatId = await chatCtrl.openChat(friendId);
                      Get.to(
                        () => ChatPage(
                          chatId: chatId,
                          otherUserId: friendId,
                          otherUserName: 'User',
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  SmallBtn(
                    label: 'إزالة',
                    filled: false,
                    onTap: () => friendCtrl.removeFriend(friendId),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
