import 'package:get/get.dart';
import 'package:chat_setup/features/social/controllers/friend_controller.dart';
import 'package:chat_setup/features/social/controllers/follow_controller.dart';

class SocialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FriendController>(() => FriendController());
    Get.lazyPut<FollowController>(() => FollowController());
  }
}
