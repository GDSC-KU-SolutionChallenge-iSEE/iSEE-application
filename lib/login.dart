import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isee/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController controller = Get.put(LoginController());

  double _width = 336;
  double _height = 336;
  double _bottom = 0;
  double _bottomLogin = 0;
  double _bottomText = 0;

  bool _isShow = false;

  @override
  void initState() {
    // TODO: implement initState
    Timer(const Duration(milliseconds: 50), () {
      setState(() {
        _isShow = true;
        _width = 192.0;
        _height = 192.0;
        _bottom = 200;
        _bottomText = 120;
      });
    });

    Timer(const Duration(milliseconds: 150), () {
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
                  bottom: (_bottomText +
                      (MediaQuery.of(context).size.height - 336) / 2 -
                      78),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                  child: SizedBox(
                      width: _width,
                      height: _height,
                      child: const Text(
                        "iSEE",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontFamily: 'PretendardExtraBold'),
                      )),
                ),
                AnimatedPositioned(
                  bottom: (_bottom +
                      (MediaQuery.of(context).size.height - 336) / 2),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                  child: AnimatedContainer(
                    width: _width,
                    height: _height,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    child: Image.asset("assets/logo.png"),
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
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                        child: Container(
                          height: 48,
                          width: 300,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xFF101010), width: 1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/google_login.png",
                                width: 22,
                                height: 22,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              const Text(
                                "Continue with Google",
                                style: TextStyle(
                                  fontFamily: 'PretendardSemiBold',
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ),
          ],
        ),
      )),
    );
  }
}
