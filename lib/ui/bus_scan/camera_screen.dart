import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isee/ui/bus_scan/camera_viewer.dart';
import 'package:isee/ui/bus_scan/capture_button.dart';
import 'package:isee/controller/scan_controller.dart';

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
