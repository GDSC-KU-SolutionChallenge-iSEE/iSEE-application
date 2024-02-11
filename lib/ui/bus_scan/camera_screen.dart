import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isee/ui/bus_scan/camera_viewer.dart';
import 'package:isee/ui/bus_scan/capture_button.dart';
import 'package:isee/controller/scan_controller.dart';
import 'package:isee/ui/home_button.dart';

class CameraScreen extends GetView<ScanController> {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const CameraVeiwer(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xFF101010).withOpacity(0.5),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "SCANNING THE BUS",
                  style: TextStyle(
                      fontFamily: 'PretendardExtraBold',
                      fontSize: 36,
                      color: Color(0xFFF9F9F9)),
                ),
                const SizedBox(
                  height: 32,
                ),
                const CaptureButton(),
                const Expanded(child: SizedBox()),
                const HomeButton(),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 10,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
