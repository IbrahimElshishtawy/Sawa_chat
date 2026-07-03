// ignore_for_file: file_names

import 'package:chat_setup/features/social/views/widgets/Empty_Card.dart';
import 'package:chat_setup/features/social/views/widgets/Loading_Card.dart'
    show LoadingCard;
import 'package:chat_setup/features/social/views/widgets/Section_Title.dart';
import 'package:chat_setup/features/social/views/widgets/Small_Btn.dart';
import 'package:chat_setup/features/social/views/widgets/User_Tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_setup/features/social/controllers/friend_controller.dart';

class RequestsTab extends StatelessWidget {
  final FriendController friendCtrl;
  final bool isDark;

  const RequestsTab({
    super.key,
    required this.friendCtrl,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        SectionTitle(title: 'طلبات واردة'),
        const SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: friendCtrl.incomingRequests(),
          builder: (_, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const LoadingCard();
            }
            final docs = snap.data?.docs ?? [];
            if (docs.isEmpty) {
              return const EmptyCard(text: 'لا توجد طلبات واردة');
            }

            return Column(
              children: docs.map((d) {
                final fromId =
                    (d.data() as Map<String, dynamic>)['from'] as String;
                return UserTile(
                  userId: fromId,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SmallBtn(
                        label: 'قبول',
                        filled: true,
                        onTap: () => friendCtrl.acceptRequest(fromId),
                      ),
                      const SizedBox(width: 8),
                      SmallBtn(
                        label: 'رفض',
                        filled: false,
                        onTap: () => friendCtrl.rejectRequest(fromId),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 18),

        SectionTitle(title: 'طلبات مرسلة'),
        const SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: friendCtrl.sentRequests(),
          builder: (_, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const LoadingCard();
            }
            final docs = snap.data?.docs ?? [];
            if (docs.isEmpty) {
              return const EmptyCard(text: 'لا توجد طلبات مرسلة');
            }

            return Column(
              children: docs.map((d) {
                final toId = (d.data() as Map<String, dynamic>)['to'] as String;
                // docId عندنا غالبًا: from_to
                final docId = d.id;

                return UserTile(
                  userId: toId,
                  subtitleOverride: 'تم إرسال طلب صداقة',
                  trailing: SmallBtn(
                    label: 'إلغاء',
                    filled: false,
                    onTap: () => FirebaseFirestore.instance
                        .collection('friend_requests')
                        .doc(docId)
                        .delete(),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
