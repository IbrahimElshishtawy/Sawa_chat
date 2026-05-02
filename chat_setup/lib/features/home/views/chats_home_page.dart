import 'package:chat_setup/features/chat/controllers/chat_controller.dart';
import 'package:chat_setup/features/chat/views/chat_page.dart';
import 'package:chat_setup/features/home/views/widgets/empty_chats_view.dart';
import 'package:chat_setup/features/home/views/widgets/home_fab.dart';
import 'package:chat_setup/features/home/views/widgets/home_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/routes.dart';
import '../../../core/constants/app_colors.dart';

class ChatsHomePage extends StatelessWidget {
  const ChatsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatCtrl = Get.find<ChatController>();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text('Please login')));
    final uid = user.uid;

    final chatsRef = FirebaseFirestore.instance
        .collection('chats')
        .where('members', arrayContains: uid)
        .orderBy('lastMessageTime', descending: true);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const HomeHeader(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    children: [
                      _buildSpecialTile(
                        context,
                        icon: Icons.auto_awesome_rounded,
                        title: 'Sphere AI',
                        subtitle: 'Your personal premium assistant',
                        onTap: () => Get.toNamed(AppRoutes.chatbot),
                        color: AppColors.secondary,
                        isDark: isDarkMode,
                      ),
                      const SizedBox(height: 12),
                      _buildSpecialTile(
                        context,
                        icon: Icons.bookmark_rounded,
                        title: 'Saved Messages',
                        subtitle: 'Quick notes & private storage',
                        onTap: () async {
                           final chatId = await chatCtrl.openChat(uid);
                           Get.to(() => ChatPage(
                             chatId: chatId,
                             otherUserId: uid,
                             otherUserName: 'Saved Messages',
                           ));
                        },
                        color: Colors.deepPurpleAccent,
                        isDark: isDarkMode,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'RECENT MESSAGES',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white38 : Colors.black38,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: chatsRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                  }

                  final allDocs = snapshot.data?.docs ?? [];
                  final chats = allDocs.where((doc) {
                     final data = doc.data() as Map<String, dynamic>;
                     return data['isSelfChat'] != true;
                  }).toList();

                  if (chats.isEmpty) {
                    return const SliverFillRemaining(child: EmptyChatsView());
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final chatId = chats[i].id;
                        final data = chats[i].data() as Map<String, dynamic>;
                        final members = List<String>.from(data['members'] ?? []);
                        final otherUserId = members.firstWhere((id) => id != uid, orElse: () => '');

                        return _buildChatTile(
                          context: context,
                          chatId: chatId,
                          otherUserId: otherUserId,
                          isDark: isDarkMode,
                          chatCtrl: chatCtrl,
                        );
                      },
                      childCount: chats.length,
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 160)),
            ],
          ),
          const Positioned(right: 20, bottom: 130, child: HomeFAB()),
        ],
      ),
    );
  }

  Widget _buildSpecialTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 13, color: isDark ? Colors.white54 : Colors.black54)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildChatTile({
    required BuildContext context,
    required String chatId,
    required String otherUserId,
    required bool isDark,
    required ChatController chatCtrl,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.secondary.withOpacity(0.1),
          child: const Icon(Icons.person_outline_rounded, color: AppColors.secondary),
        ),
        title: const Text('User Name', style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: StreamBuilder<String>(
          stream: chatCtrl.getLastMessageStream(chatId),
          builder: (_, snap) {
            return Text(
              snap.data ?? 'No messages yet',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: isDark ? Colors.white38 : Colors.black38),
            );
          },
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('12:00 PM', style: TextStyle(fontSize: 11, color: isDark ? Colors.white24 : Colors.black26)),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
              child: const Text('2', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        onTap: () {
          Get.to(
            () => ChatPage(
              chatId: chatId,
              otherUserId: otherUserId,
              otherUserName: 'User Name',
            ),
          );
        },
      ),
    );
  }
}
