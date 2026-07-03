import 'package:get/get.dart';

class NavigationController extends GetxController {
  // current tab index of the navigation bar
  final RxInt index = 0.obs;

  void change(int newIndex) {
    if (index.value == newIndex) return;
    index.value = newIndex;
  }
}
