// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final bool isSeen;

  // ألوان قابلة للتخصيص
  final Color sentMessageColor;
  final Color receivedMessageColor;
  final Color seenIconColor;
  final Color notSeenIconColor;
  final double fontSize;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.isSeen,
    this.sentMessageColor = Colors.blue,
    this.receivedMessageColor = Colors.grey,
    this.seenIconColor = Colors.lightBlueAccent,
    this.notSeenIconColor = Colors.white70,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isMe ? sentMessageColor : receivedMessageColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe
                ? const Radius.circular(16)
                : const Radius.circular(0),
            bottomRight: isMe
                ? const Radius.circular(0)
                : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontSize: fontSize,
              ),
            ),
            const SizedBox(height: 4),
            if (isMe)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // عرض حالة الرسالة (تم قراءة أو تم تسليمها)
                  Icon(
                    isSeen ? Icons.done_all : Icons.done,
                    size: 16,
                    color: isSeen ? seenIconColor : notSeenIconColor,
                  ),
                  const SizedBox(width: 4),
                  // يمكن إضافة الوقت هنا إذا أردت
                  Text(
                    _getTimeAgo(),
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo() {
    return '10:30 PM';
  }
}
