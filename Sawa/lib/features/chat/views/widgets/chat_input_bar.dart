// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_setup/features/chat/controllers/chat_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ChatInputBar extends StatefulWidget {
  final String chatId;
  final String otherUserId;

  const ChatInputBar({
    super.key,
    required this.chatId,
    required this.otherUserId,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController textCtrl = TextEditingController();
  bool hasText = false;

  final _picker = ImagePicker();

  @override
  void dispose() {
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatCtrl = Get.find<ChatController>();

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.grey),
              onPressed: () async {
                final pickedFile = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (pickedFile != null) {
                  final file = File(pickedFile.path);
                  final ref = FirebaseStorage.instance.ref().child(
                    'chat_images/${pickedFile.name}',
                  );
                  await ref.putFile(file);
                  final downloadUrl = await ref.getDownloadURL();
                  if (kDebugMode) {
                    print("File uploaded: $downloadUrl");
                  }
                }
              },
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F3F7),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextField(
                        controller: textCtrl,
                        minLines: 1,
                        maxLines: 5,
                        onChanged: (value) {
                          final typing = value.trim().isNotEmpty;
                          if (typing != hasText) {
                            setState(() => hasText = typing);
                          }
                          if (typing) {
                            chatCtrl.startTyping(widget.otherUserId);
                          } else {
                            chatCtrl.stopTyping();
                          }
                        },
                        onTapOutside: (_) => chatCtrl.stopTyping(),
                        decoration: const InputDecoration(
                          hintText: 'اكتب رسالة...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () async {
                if (!hasText) {
                  return;
                }
                final text = textCtrl.text.trim();
                if (text.isEmpty) return;

                await chatCtrl.sendMessage(
                  chatId: widget.chatId,
                  text: text,
                  members: [chatCtrl.uid!, widget.otherUserId],
                );
                textCtrl.clear();
                setState(() => hasText = false);
                await chatCtrl.stopTyping();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: hasText ? const Color(0xFF007AFF) : Colors.grey.shade200,
                  shape: BoxShape.circle,
                  boxShadow: hasText ? [
                    BoxShadow(
                      color: const Color(0xFF007AFF).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ] : null,
                ),
                child: Icon(
                  hasText ? Icons.send : Icons.mic,
                  color: hasText ? Colors.white : Colors.grey.shade600,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
