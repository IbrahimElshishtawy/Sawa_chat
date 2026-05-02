import 'package:chat_setup/features/auth/bindings/auth_bindings.dart';
import 'package:chat_setup/features/social/bindings/social_binding.dart';
import 'package:chat_setup/features/home/bindings/home_binding.dart';
import 'package:chat_setup/features/social/views/Friend_Page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'route_animations.dart';

// Screens
import '../../features/splash/views/splash_page.dart';
import '../../features/auth/views/login_page.dart';
import '../../features/auth/views/register_page.dart';
import '../../features/home/views/home_page.dart';
import '../../features/profile/views/profile_page.dart';
import '../../features/settings/views/settings_page.dart';
import '../../features/chat/views/chat_page.dart';
import '../../features/chat/views/groups_page.dart';
import '../../features/community/views/community_page.dart';
import '../../features/notifications/views/notifications_page.dart';
import '../../features/call/views/call_history_page.dart';
import '../../features/chat/views/chatbot_page.dart';

class AppRoutes {
  // ===== Route Names =====
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';

  static const profile = '/profile';
  static const settings = '/settings';

  static const chat = '/chat';

  static const groups = '/groups';
  static const community = '/community';

  static const notifications = '/notifications';

  static const callHistory = '/call-history';
  static const chatbot = '/chatbot';

  // ===== Pages =====
  static final pages = <GetPage>[
    // Splash
    GetPage(name: splash, page: () => const SplashPage()),

    // Auth
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBindings(),
    ),

    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: AuthBindings(),
      customTransition: ScaleFadeTransition(),
      transitionDuration: const Duration(milliseconds: 600),
    ),

    // Home
    GetPage(name: '/home', page: () => HomePage(), binding: HomeBinding()),

    // Profile
    GetPage(
      name: profile,
      page: () => const ProfilePage(),
      binding: SocialBinding(),
    ),

    // Settings
    GetPage(name: settings, page: () => const SettingsPage()),

    // Chat
    GetPage(
      name: chat,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;

        if (args == null ||
            args['id'] == null ||
            args['name'] == null ||
            args['id'] is! String ||
            args['name'] is! String) {
          return const Scaffold(
            body: Center(child: Text('❌ بيانات الشات غير صحيحة')),
          );
        }

        return ChatPage(
          otherUserId: args['id'] as String,
          otherUserName: args['name'] as String,
          chatId: '',
        );
      },
    ),

    GetPage(
      name: '/friends',
      page: () => const FriendPage(),
      binding: SocialBinding(),
    ),
    // Groups
    GetPage(name: groups, page: () => const GroupsPage()),

    // Community
    GetPage(name: community, page: () => const CommunityPage()),

    // Notifications
    GetPage(name: notifications, page: () => const NotificationsPage()),

    // Call History
    GetPage(name: callHistory, page: () => const CallHistoryPage()),
    GetPage(name: chatbot, page: () => ChatbotPage()),
  ];
}
