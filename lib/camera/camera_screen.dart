import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isee/camera/camera_viewer.dart';
import 'package:isee/camera/capture_button.dart';
import 'package:isee/scan_controller.dart';

class CameraScreen extends GetView<ScanController> {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext buildContext) {
    return const Stack(
      alignment: Alignment.center,
      children: [CameraVeiwer(), CaptureButton()],
    );
  }
}
