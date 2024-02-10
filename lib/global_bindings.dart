import 'package:get/instance_manager.dart';
import 'package:isee/global_controller.dart';
import 'package:isee/login_controller.dart';
import 'package:isee/scan_controller.dart';
import 'package:isee/set_bus_controller.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GlobalController>(() => GlobalController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<ScanController>(() => ScanController());
    Get.lazyPut<SetBusController>(() => SetBusController());
  }
}
