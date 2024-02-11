import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isee/controller/scan_controller.dart';

class CaptureButton extends GetView<ScanController> {
  const CaptureButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.capture(),
      child: Container(
        width: 100,
        height: 100,
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      ),
    );
  }
}
