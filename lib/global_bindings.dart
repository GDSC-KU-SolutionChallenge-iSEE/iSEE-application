import 'package:get/instance_manager.dart';
import 'package:isee/controller/global_controller.dart';
import 'package:isee/controller/login_controller.dart';
import 'package:isee/controller/scan_controller.dart';
import 'package:isee/controller/set_bus_controller.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GlobalController>(() => GlobalController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<ScanController>(() => ScanController());
    Get.lazyPut<SetBusController>(() => SetBusController());
  }
}
