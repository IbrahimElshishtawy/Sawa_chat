import 'package:chat_setup/features/notifications/controllers/notification_controller.dart';
import 'package:chat_setup/features/core_features/controllers/presence_controller.dart';
import 'package:chat_setup/features/social/controllers/follow_controller.dart';
import 'package:chat_setup/features/social/controllers/friend_controller.dart'
    show FriendController;
import 'package:chat_setup/features/profile/controllers/user_controller.dart';
import 'package:get/get.dart';

import '../../features/auth/controllers/auth_controller.dart';
import '../../features/core_features/controllers/theme_controller.dart';
import '../../features/core_features/controllers/navigation_controller.dart';
import '../../features/chat/controllers/chat_controller.dart';
import '../../features/call/controllers/call_controller.dart';
import '../../features/call/controllers/call_history_controller.dart';
import '../../features/settings/controllers/settings_controller.dart';
import '../../core/services/ai_base_service.dart';
import '../../core/services/openai_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    //  لازم يبقى أول Controller
    Get.put(AuthController(), permanent: true);
    Get.put(NotificationController(), permanent: true);

    //  Navigation & Theme
    Get.put(PresenceController(), permanent: true);

    Get.put(ThemeController(), permanent: true);
    Get.put(NavigationController(), permanent: true);

    Get.put<FriendController>(FriendController(), permanent: true);
    Get.put<FollowController>(FollowController(), permanent: true);

    if (!Get.isRegistered<ChatController>()) {
      Get.put(ChatController(), permanent: true);
    }

    // الباقي lazy
    Get.lazyPut<UserController>(() => UserController());

    Get.lazyPut(() => ChatController(), fenix: true);
    Get.lazyPut(() => CallController(), fenix: true);
    Get.lazyPut(() => CallHistoryController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);

    // AI Service - Provider Agnostic registration
    Get.lazyPut<AIService>(() => OpenAiService(apiKey: 'YOUR_API_KEY_HERE'), fenix: true);
  }
}
