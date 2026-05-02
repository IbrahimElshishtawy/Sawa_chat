import 'package:chat_setup/features/auth/views/widgets/login_form_controller.dart';
import 'package:get/get.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginFormController>(() => LoginFormController(), fenix: true);
  }
}
