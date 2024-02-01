import 'package:get/instance_manager.dart';
import 'package:isee/login_controller.dart';
import 'package:isee/scan_controller.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<ScanController>(() => ScanController());
  }
}
