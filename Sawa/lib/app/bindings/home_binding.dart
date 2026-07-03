import 'package:chat_setup/features/chat/controllers/chat_controller.dart';
import 'package:chat_setup/features/core_features/controllers/navigation_controller.dart';
import 'package:chat_setup/features/profile/controllers/user_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController(), fenix: true);
    Get.lazyPut(() => ChatController(), fenix: true);
    Get.lazyPut(() => UserController(), fenix: true);
  }
}
