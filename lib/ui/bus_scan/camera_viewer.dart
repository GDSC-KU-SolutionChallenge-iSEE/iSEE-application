import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isee/controller/scan_controller.dart';

class CameraVeiwer extends GetView<ScanController> {
  const CameraVeiwer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext buildContext) {
    return GetX<ScanController>(builder: (controller) {
      if (!controller.isInitialized) {
        return Container();
      }

      return SizedBox(
        height: Get.height,
        width: Get.width,
        child: CameraPreview(controller.cameraController),
      );
    });
  }
}
