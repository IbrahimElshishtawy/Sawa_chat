import 'package:chat_setup/features/chat/views/widgets/chat_input_bar.dart';
import 'package:chat_setup/features/chat/views/widgets/messages_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:chat_setup/features/chat/controllers/chat_controller.dart';

class ChatPage extends StatelessWidget {
  final String chatId;
  final String otherUserId;
  final String otherUserName;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  Widget build(BuildContext context) {
    final ChatController chatCtrl = Get.find<ChatController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(otherUserName),
        leading: BackButton(onPressed: () => Get.back()),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'delete':
                  _deleteChat(chatCtrl);
                  break;
                case 'mute':
                  _muteChat(chatCtrl);
                  break;
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'delete', child: Text('حذف الشات')),
              PopupMenuItem(value: 'mute', child: Text('كتم الإشعارات')),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          /// messages list
          Expanded(child: MessagesList(chatId: chatId)),

          /// input massage bar
          ChatInputBar(chatId: chatId, otherUserId: otherUserId),
        ],
      ),
    );
  }

  Future<void> _deleteChat(ChatController chatCtrl) async {
    await chatCtrl.deleteChat(chatId);
    Get.back();
  }

  void _muteChat(ChatController chatCtrl) {
    chatCtrl.muteChat(chatId);
  }
}
