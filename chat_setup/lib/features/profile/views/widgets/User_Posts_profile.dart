// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserPostsWidget extends StatelessWidget {
  final String userId;

  const UserPostsWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final postCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('posts')
        .orderBy('createdAt', descending: true); // Get posts sorted by date

    return StreamBuilder<QuerySnapshot>(
      stream: postCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No posts available.'));
        }

        final posts = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: posts.length,
          itemBuilder: (_, index) {
            final post = posts[index];
            final postText = post['text'] ?? '';
            final postImageUrl = post['imageUrl'] ?? '';
            final createdAt = (post['createdAt'] as Timestamp?)?.toDate();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (postImageUrl.isNotEmpty)
                        Image.network(postImageUrl), // Display post image
                      const SizedBox(height: 8),
                      Text(postText, style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 6),
                      if (createdAt != null)
                        Text(
                          'Posted on: ${createdAt.toLocal()}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
