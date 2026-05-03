import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildProfileHeader(),
          ),
          const SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverToBoxAdapter(
            child: _buildStats(),
          ),
          const SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverToBoxAdapter(
            child: _buildTabs(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildPostItem(index);
              },
              childCount: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage('https://via.placeholder.com/100'),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.camera_alt, size: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'John Doe',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Software Developer | Flutter Enthusiast',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLinkButton('LinkedIn', Icons.business),
              const SizedBox(width: 16),
              _buildLinkButton('GitHub', Icons.code),
              const SizedBox(width: 16),
              _buildLinkButton('Website', Icons.web),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton(String label, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('Followers', '1.2K'),
          _buildStatItem('Following', '850'),
          _buildStatItem('Posts', '45'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return DefaultTabController(
      length: 2,
      child: const TabBar(
        tabs: [
          Tab(text: 'Posts'),
          Tab(text: 'Reels'),
        ],
      ),
    );
  }

  Widget _buildPostItem(int index) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://via.placeholder.com/40'),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'John Doe',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '${index + 1}h ago',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('This is a sample post content.'),
          const SizedBox(height: 12),
          Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(child: Text('Post Image/Video')),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.thumb_up_outlined), onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.comment_outlined), onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.share_outlined), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
