import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isee/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController controller = Get.put(LoginController());

  double _width = 200;
  double _height = 200;
  double _bottom = 300;
  double _bottomLogin = 0;
  double _bottomText = 300;

  bool _isShow = false;

  @override
  void initState() {
    // TODO: implement initState
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _isShow = true;
        _width = 100.0;
        _height = 100.0;
        _bottom = 600.0;
        _bottomText = 500.0;
      });
    });

    Timer(const Duration(milliseconds: 3100), () {
      setState(() {
        _bottomLogin = 300.0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedPositioned(
                  bottom: _bottomText,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: SizedBox(
                      width: _width,
                      height: _height,
                      child: const Text(
                        "iSEE",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      )),
                ),
                AnimatedPositioned(
                  bottom: _bottom,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: AnimatedContainer(
                    width: _width,
                    height: _height,
                    color: Colors.blueAccent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: const Text("로고 박스"),
                  ),
                ),
              ],
            ),
            if (_isShow)
              GestureDetector(
                onTap: () {
                  controller.googleLogin();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedPositioned(
                        bottom: _bottomLogin,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        child: Container(
                          height: 48,
                          width: 300,
                          color: Colors.redAccent,
                        )),
                  ],
                ),
              ),
            Positioned(
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  controller.resign();
                },
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.amber,
                  child: const Text("탈퇴하기"),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
