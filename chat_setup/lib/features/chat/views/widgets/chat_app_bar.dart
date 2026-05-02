import 'package:chat_setup/features/chat/views/widgets/OnlineStatusText.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String otherUserId;

  const ChatAppBar({super.key, required this.name, required this.otherUserId});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: Row(
        children: [
          const SizedBox(width: 8),

          /// Avatar
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFEBE5FF),
            child: Icon(Icons.person, size: 20),
          ),

          const SizedBox(width: 10),

          /// الاسم + الحالة (ONLINE)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),

                /// ✅ الحالة الحقيقية
                OnlineStatusText(userId: otherUserId),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
        IconButton(icon: const Icon(Icons.call), onPressed: () {}),
        IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
