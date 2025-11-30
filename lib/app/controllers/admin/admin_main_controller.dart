// lib/controllers/admin/admin_main_controller.dart
import 'package:get/get.dart';

class AdminMainController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}
