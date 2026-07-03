import 'package:chat_setup/features/chat/controllers/chats__list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_page.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatsController chatsCtrl = Get.put(ChatsController());

    return Scaffold(
      appBar: AppBar(title: const Text('الدردشات')),
      body: Obx(() {
        final chats = chatsCtrl.chats;

        if (chats.isEmpty) {
          return const Center(child: Text('لا توجد محادثات'));
        }

        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: chat.isSelfChat ? Colors.blue.shade100 : null,
                child: chat.isSelfChat
                  ? const Icon(Icons.bookmark, color: Colors.blue)
                  : Text(chat.otherUserName[0]),
              ),
              title: Text(
                chat.otherUserName,
                style: TextStyle(
                  fontWeight: chat.isSelfChat ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Text(
                chat.lastMessage ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Get.to(
                  () => ChatPage(
                    chatId: chat.id,
                    otherUserId: chat.otherUserId,
                    otherUserName: chat.otherUserName,
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
