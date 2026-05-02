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
              itemCount: 15,
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
            Icon(Icons.search, color: Theme.of(context).textTheme.bodyMedium?.color),
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
    final isGroup = index % 4 == 0;
    final isChannel = index % 5 == 0;
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=$index'),
        child: isGroup
            ? const Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.group, size: 16, color: Colors.white),
              )
            : isChannel
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
              isGroup ? 'Flutter Devs Group' : isChannel ? 'Official Channel' : 'User $index',
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '10:4$index AM',
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
          'This is a preview of the last message sent in this conversation...',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
        ),
      ),
      onTap: () {},
    );
  }
}
