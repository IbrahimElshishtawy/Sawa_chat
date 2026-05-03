import 'package:flutter/material.dart';

class Chat {
  final String title;
  final String avatarUrl;
  final bool isGroup;
  final bool isChannel;
  final String time;
  final String subtitle;
  final int unreadCount;

  Chat({
    required this.title,
    required this.avatarUrl,
    required this.isGroup,
    required this.isChannel,
    required this.time,
    required this.subtitle,
    required this.unreadCount,
  });
}

class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = ['Hello!', 'How are you?', 'Fine, thanks!'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.chat.avatarUrl),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Text(widget.chat.title),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'permissions':
                  _showPermissionsDialog();
                  break;
                case 'settings':
                  _showSettingsDialog();
                  break;
                case 'react':
                  _showReactDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 'permissions', child: Text('Permissions')),
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
              const PopupMenuItem(value: 'react', child: Text('React')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(
                    _messages[_messages.length - 1 - index], index % 2 == 0);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                setState(() {
                  _messages.add(_messageController.text);
                  _messageController.clear();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  void _showPermissionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissions'),
        content: const Text('Manage group permissions here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Text('Group settings here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('React'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: const Icon(Icons.thumb_up), onPressed: () {}),
            IconButton(icon: const Icon(Icons.favorite), onPressed: () {}),
            IconButton(
                icon: const Icon(Icons.emoji_emotions), onPressed: () {}),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
