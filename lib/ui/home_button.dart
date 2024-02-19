import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isee/controller/scan_controller.dart';

class HomeButton extends StatefulWidget {
  const HomeButton({Key? key}) : super(key: key);

  @override
  State<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  final ScanController controller = Get.put(ScanController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        controller.remove();
        Navigator.of(context).pop();
      },
      child: Container(
        width: 104,
        height: 104,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF101010),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.asset("assets/home_white.png"),
        ),
      ),
    );
  }
}
