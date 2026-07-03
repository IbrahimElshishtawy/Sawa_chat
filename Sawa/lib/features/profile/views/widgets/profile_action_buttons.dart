import 'package:chat_setup/features/chat/views/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_setup/features/social/controllers/friend_controller.dart';
import 'package:chat_setup/features/social/controllers/follow_controller.dart';
import 'package:chat_setup/features/chat/controllers/chat_controller.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ProfileActionButtons extends StatelessWidget {
  final String profileUserId;

  const ProfileActionButtons({super.key, required this.profileUserId});

  @override
  Widget build(BuildContext context) {
    final FriendController friendCtrl = Get.isRegistered<FriendController>()
        ? Get.find<FriendController>()
        : Get.put(FriendController(), permanent: true);

    final FollowController followCtrl = Get.isRegistered<FollowController>()
        ? Get.find<FollowController>()
        : Get.put(FollowController(), permanent: true);

    final chatCtrl = Get.find<ChatController>();
    final myId = FirebaseAuth.instance.currentUser!.uid;

    if (profileUserId == myId) return const SizedBox.shrink();

    return Column(
      children: [
        /// 🔹 Friendship Button
        StreamBuilder(
          stream: friendCtrl.incomingRequests().map(
            (s) => s.docs.any((d) => d['from'] == profileUserId),
          ),
          builder: (_, incomingSnap) {
            final hasIncoming = incomingSnap.data ?? false;

            return StreamBuilder(
              stream: friendCtrl.sentRequests().map(
                (s) => s.docs.any((d) => d['to'] == profileUserId),
              ),
              builder: (_, sentSnap) {
                final hasSent = sentSnap.data ?? false;

                return StreamBuilder(
                  stream: friendCtrl.friendsStream().map(
                    (s) => s.docs.any((d) => d.id == profileUserId),
                  ),
                  builder: (_, friendSnap) {
                    final isFriend = friendSnap.data ?? false;

                    if (isFriend) {
                      return _primaryBtn(
                        icon: Icons.chat,
                        label: 'مراسلة',
                        onTap: () async {
                          final chatId = await chatCtrl.openChat(profileUserId);
                          Get.to(
                            () => ChatPage(
                              chatId: chatId,
                              otherUserId: profileUserId,
                              otherUserName: 'User',
                            ),
                          );
                        },
                      );
                    }

                    if (hasIncoming) {
                      return Row(
                        children: [
                          Expanded(
                            child: _primaryBtn(
                              icon: Icons.check,
                              label: 'قبول',
                              onTap: () =>
                                  friendCtrl.acceptRequest(profileUserId),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _outlineBtn(
                              label: 'رفض',
                              onTap: () =>
                                  friendCtrl.rejectRequest(profileUserId),
                            ),
                          ),
                        ],
                      );
                    }

                    if (hasSent) {
                      return _outlineBtn(label: 'تم الإرسال');
                    }

                    return _primaryBtn(
                      icon: Icons.person_add,
                      label: 'إضافة صديق',
                      onTap: () => friendCtrl.sendFriendRequest(profileUserId),
                    );
                  },
                );
              },
            );
          },
        ),

        const SizedBox(height: 10),

        /// 🔹 Follow Button
        StreamBuilder<bool>(
          stream: followCtrl.isFollowing(profileUserId),
          builder: (_, snap) {
            final following = snap.data ?? false;

            return _outlineBtn(
              label: following ? 'إلغاء المتابعة' : 'متابعة',
              icon: following ? Icons.person_remove : Icons.person_add_alt,
              onTap: () => following
                  ? followCtrl.unfollow(profileUserId)
                  : followCtrl.follow(profileUserId),
            );
          },
        ),
      ],
    );
  }

  /// ================= UI Helpers =================

  Widget _primaryBtn({
    required String label,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: icon == null ? const SizedBox() : Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _outlineBtn({
    required String label,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: icon == null ? const SizedBox() : Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
