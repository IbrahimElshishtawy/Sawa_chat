// ignore_for_file: file_names

import 'package:chat_setup/features/social/controllers/follow_controller.dart';
import 'package:chat_setup/features/social/views/widgets/Small_Btn.dart';
import 'package:chat_setup/features/social/views/widgets/User_Tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FollowingTab extends StatelessWidget {
  final FollowController followCtrl;
  final bool isDark;

  const FollowingTab({
    super.key,
    required this.followCtrl,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final myId = followCtrl.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('following')
          .doc(myId)
          .collection('users')
          .snapshots(),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(child: Text('أنت لا تتابع أحدًا'));
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final followingId = docs[i].id;

            return UserTile(
              userId: followingId,
              trailing: SmallBtn(
                label: 'إلغاء',
                filled: false,
                onTap: () => followCtrl.unfollow(followingId),
              ),
            );
          },
        );
      },
    );
  }
}
