import 'package:chat_setup/core/mock/sample_data.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_square),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          Expanded(
            child: ListView.builder(
              itemCount: sampleChats.length,
              itemBuilder: (context, index) {
                return _buildChatTile(context, index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Icon(Icons.search,
                color: Theme.of(context).textTheme.bodyMedium?.color),
            const SizedBox(width: 8),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTile(BuildContext context, int index) {
    final chat = sampleChats[index];
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(chat.avatarUrl),
        child: chat.isGroup
            ? const Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.group, size: 16, color: Colors.white),
              )
            : chat.isChannel
                ? const Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.campaign, size: 16, color: Colors.white),
                  )
                : null,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              chat.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            chat.time,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 12,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          chat.subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
        ),
      ),
      trailing: chat.unreadCount > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                chat.unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          : null,
      onTap: () {},
    );
  }
}
