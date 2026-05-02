import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_setup/features/core_features/controllers/archive_controller.dart';

class ArchivedChatsPage extends StatelessWidget {
  const ArchivedChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ArchiveController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Archived Chats')),
      body: StreamBuilder(
        stream: ctrl.archivedChats(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No archived chats'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final chatId = docs[i].id;

              return ListTile(
                title: Text('Chat $chatId'),
                trailing: IconButton(
                  icon: const Icon(Icons.unarchive),
                  onPressed: () => ctrl.unarchiveChat(chatId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
