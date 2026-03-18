import 'package:chat_setup/controllers/notification/notification_controller.dart';
import 'package:chat_setup/controllers/presence/presence_controller.dart';
import 'package:chat_setup/controllers/social/follow_controller.dart';
import 'package:chat_setup/controllers/social/friend_controller.dart'
    show FriendController;
import 'package:chat_setup/controllers/user/user_controller.dart';
import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../controllers/navigation/navigation_controller.dart';
import '../../controllers/chat/chat_controller.dart';
import '../../controllers/call/call_controller.dart';
import '../../controllers/call/call_history_controller.dart';
import '../../controllers/settings/settings_controller.dart';
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
