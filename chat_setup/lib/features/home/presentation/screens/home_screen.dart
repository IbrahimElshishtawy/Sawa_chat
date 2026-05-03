import 'package:chat_setup/core/mock/sample_data.dart';
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
          ),
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CreatePostScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Create Post Button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CreatePostScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Create Post'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),
          ),
          // Stories Section
          SliverToBoxAdapter(
            child: SizedBox(
              height: 96,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                itemCount: sampleStories.length,
                itemBuilder: (context, index) {
                  final story = sampleStories[index];
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
                            border:
                                Border.all(color: Colors.transparent, width: 2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(story.avatarUrl),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          story.isYourStory ? 'Your Story' : story.name,
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
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reels',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                itemCount: samplePosts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final post = samplePosts[index];
                  return _buildReelCard(context, post);
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
              childCount: samplePosts.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, int index) {
    final post = samplePosts[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(post.avatarUrl),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post.timeAgo,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
              const Icon(Icons.more_horiz, size: 20, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          Text(post.content),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(post.imageUrl,
                fit: BoxFit.cover, height: 180, width: double.infinity),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInteractionIcon(Icons.favorite_border, '${post.likes}'),
              _buildInteractionIcon(
                  Icons.chat_bubble_outline, '${post.comments}'),
              _buildInteractionIcon(Icons.repeat, '${post.shares}'),
              _buildInteractionIcon(Icons.send_outlined, ''),
            ],
          ),
          const SizedBox(height: 16),
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
            Text(count,
                style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          ]
        ],
      ),
    );
  }

  Widget _buildReelCard(BuildContext context, dynamic post) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                post.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.timeAgo,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  List<String> _selectedImages = [];
  String? _selectedVideo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: () {
              // Publish logic
              Navigator.of(context).pop();
            },
            child: const Text('Post'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/40'),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Your Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'What do you want to talk about?',
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedImages.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.network(_selectedImages[index],
                          width: 100, height: 100, fit: BoxFit.cover),
                    );
                  },
                ),
              ),
            if (_selectedVideo != null)
              Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(child: Text('Video Preview')),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    // Pick images
                  },
                  icon: const Icon(Icons.image),
                  tooltip: 'Add photo',
                ),
                IconButton(
                  onPressed: () {
                    // Pick video
                  },
                  icon: const Icon(Icons.videocam),
                  tooltip: 'Add video',
                ),
                IconButton(
                  onPressed: () {
                    // Add document
                  },
                  icon: const Icon(Icons.attach_file),
                  tooltip: 'Add document',
                ),
                IconButton(
                  onPressed: () {
                    // Add poll
                  },
                  icon: const Icon(Icons.poll),
                  tooltip: 'Create poll',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
