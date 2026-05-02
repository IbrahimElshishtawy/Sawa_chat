import 'package:chat_setup/features/chat/controllers/chat_controller.dart';
import 'package:chat_setup/core/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesList extends StatelessWidget {
  final String chatId;

  const MessagesList({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    final chatCtrl = Get.find<ChatController>();

    return StreamBuilder(
      stream: chatCtrl.getMessages(chatId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;
        chatCtrl.markSeen(chatId);

        return ListView.builder(
          reverse: true, // لتكون الرسائل الأحدث في الأسفل
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final doc = docs[i];
            final message = MessageModel.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            );
            final isMe = message.senderId == chatCtrl.uid;

            return GestureDetector(
              onLongPress: isMe
                  ? () => _showEditDialog(context, chatCtrl, message)
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: isMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isMe ? Colors.blue.shade100 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.text,
                            style: TextStyle(
                              color: isMe ? Colors.black : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              if (message.isEdited)
                                const Text(
                                  '(معدلة) ',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              Text(
                                _getTimeAgo(
                                  Timestamp.fromDate(message.createdAt),
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (isMe)
                                Icon(
                                  message.isSeen
                                      ? Icons.check_circle
                                      : Icons.check,
                                  size: 16,
                                  color: message.isSeen
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (!isMe) const SizedBox(width: 8),
                    if (!isMe)
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey.shade300,
                        child: Text(
                          message.senderName.isNotEmpty
                              ? message.senderName[0].toUpperCase()
                              : (message.senderId.isNotEmpty
                                  ? message.senderId[0].toUpperCase()
                                  : '?'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditDialog(
    BuildContext context,
    ChatController chatCtrl,
    MessageModel message,
  ) {
    // Check if still editable
    if (message.canEditUntil != null &&
        DateTime.now().isAfter(message.canEditUntil!)) {
      Get.snackbar('خطأ', 'انتهى الوقت المسموح للتعديل (5 دقائق)');
      return;
    }
    if (message.editCount >= 3) {
      Get.snackbar('خطأ', 'وصلت للحد الأقصى من التعديلات (3 مرات)');
      return;
    }

    final TextEditingController editCtrl =
        TextEditingController(text: message.text);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الرسالة'),
        content: TextField(
          controller: editCtrl,
          decoration: const InputDecoration(hintText: "اكتب تعديلك هنا..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (editCtrl.text.trim().isNotEmpty &&
                  editCtrl.text.trim() != message.text) {
                try {
                  await chatCtrl.editMessage(
                    chatId: chatId,
                    messageId: message.id,
                    newText: editCtrl.text.trim(),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  Get.snackbar('خطأ', e.toString());
                }
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  // دالة لتحويل الوقت إلى تنسيق قابل للقراءة مثل "منذ 5 دقائق"
  String _getTimeAgo(Timestamp timestamp) {
    final time = timestamp.toDate();
    final difference = DateTime.now().difference(time);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} ثواني';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ساعة';
    } else {
      return '${difference.inDays} يوم';
    }
  }
}
