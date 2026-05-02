import 'package:chat_setup/features/chat/views/groups_page.dart';
import 'package:chat_setup/features/community/views/community_page.dart';
import 'package:chat_setup/features/home/views/chats_home_page.dart';
import 'package:chat_setup/features/notifications/views/notifications_page.dart';
import 'package:chat_setup/features/profile/views/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_setup/features/core_features/controllers/navigation_controller.dart';

import 'widgets/floating_nav_bar.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final NavigationController nav = Get.put(
    NavigationController(),
    permanent: true,
  );

  final List<Widget> pages = const [
    ChatsHomePage(), // 0 - الدردشات
    GroupsPage(), // 1 - الجروبات
    CommunityPage(), // 2 - المجتمع
    NotificationsPage(), // 3 - التنبيهات
    ProfilePage(), // 4 - البروفايل
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            IndexedStack(index: nav.index.value, children: pages),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: FloatingNavBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
