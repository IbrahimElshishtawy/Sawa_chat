import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Stories Section
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Colors.purple, Colors.orange],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: Colors.transparent, width: 2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(
                                    'https://i.pravatar.cc/150?img=${index + 10}'),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          index == 0 ? 'Your Story' : 'User $index',
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Divider()),
          // Feed Section
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildPostCard(context, index);
              },
              childCount: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar & connecting line (Threads style)
          Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=$index'),
                radius: 20,
              ),
              if (index != 9) // don't show line on last
                Container(
                  width: 2,
                  height: 100,
                  color: Theme.of(context).dividerColor,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                )
            ],
          ),
          const SizedBox(width: 12),
          // Post Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Username $index',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        const Text('2h', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(width: 8),
                        const Icon(Icons.more_horiz, size: 16, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'This is a sample post mimicking the Threads style layout. It supports multi-line text and elegant spacing.',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInteractionIcon(Icons.favorite_border, '1.2k'),
                    _buildInteractionIcon(Icons.chat_bubble_outline, '45'),
                    _buildInteractionIcon(Icons.repeat, '12'),
                    _buildInteractionIcon(Icons.send_outlined, ''),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInteractionIcon(IconData icon, String count) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          if (count.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(count, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          ]
        ],
      ),
    );
  }
}
