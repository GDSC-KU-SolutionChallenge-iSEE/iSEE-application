import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isee/controller/login_controller.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.title});

  final String title;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          const SizedBox(
            height: 80,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 56,
            height: 170,
            decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                border: Border.all(color: const Color(0xFF101010), width: 2)),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 22.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Logout",
                    style: TextStyle(
                        fontFamily: 'PretendardExtraBold',
                        fontSize: 36,
                        color: Color(0xFF101010)),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    "If you want to logout,\ndouble touch this box",
                    style: TextStyle(
                        fontFamily: 'PretendardSemiBold',
                        fontSize: 18,
                        color: Color(0xFF101010)),
                  )
                ],
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          Container(
            width: MediaQuery.of(context).size.width - 56,
            height: 100,
            decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                border: Border.all(color: const Color(0xFF101010), width: 2)),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 22.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quit Service",
                    style: TextStyle(
                        fontFamily: 'PretendardExtraBold',
                        fontSize: 36,
                        color: Color(0xFF101010)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 46,
          )
        ],
      )),
    );
  }
}
