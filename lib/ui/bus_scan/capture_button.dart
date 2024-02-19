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
        width: 338,
        height: 63,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Color(0xFF101010),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: const Text(
          "capture now",
          style: TextStyle(
              fontFamily: 'PretendardSemiBold',
              fontSize: 30,
              color: Color(0xFFFFFFFF)),
        ),
      ),
    );
  }
}
