import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:isee/ui/bus_scan/camera_screen.dart';
import 'package:isee/ui/set_bus/set_bus_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  double screenWidth = window.physicalSize.width / window.devicePixelRatio;

  bool _isScan = true;
  bool _isSetBus = false;
  double _scanBusBoxHeight = 380;
  double _scanBusboxWidthMargin = 56;
  double _setBusBoxHeight = 0;
  double _setBusBoxWidthMargin =
      window.physicalSize.width / window.devicePixelRatio;
  bool _scanBusTextShow = true;
  bool _setBusTextShow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 495,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            AnimatedOpacity(
                              opacity: !_isScan ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 800),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 24.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _scanBusBoxHeight = 380;
                                        _scanBusboxWidthMargin = 56;
                                        _setBusBoxHeight = 0;
                                        _setBusBoxWidthMargin = screenWidth;
                                        _isScan = true;
                                        _isSetBus = false;
                                        _setBusTextShow = false;
                                      });

                                      Timer(const Duration(milliseconds: 500),
                                          () {
                                        _scanBusTextShow = true;
                                        setState(() {});
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0x88101010)),
                                        ),
                                        const SizedBox(
                                          width: 22.0,
                                        ),
                                        const Text(
                                          "SCAN BUS",
                                          style: TextStyle(
                                              fontFamily: 'PretendardExtraBold',
                                              fontSize: 36,
                                              color: Color(0x88101010)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 28.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const CameraScreen()));
                                },
                                child: AnimatedOpacity(
                                  opacity: _isScan ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 400),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.easeInOut,
                                    width: screenWidth - _scanBusboxWidthMargin,
                                    height: _scanBusBoxHeight,
                                    decoration: const BoxDecoration(
                                        color: Color(0xFF101010),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    child: _scanBusTextShow
                                        ? AnimatedOpacity(
                                            opacity:
                                                _scanBusTextShow ? 1.0 : 0.0,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 24.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 25,
                                                  ),
                                                  Text(
                                                    "SCAN BUS",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'PretendardExtraBold',
                                                        fontSize: 36,
                                                        color:
                                                            Color(0xFFF9F9F9)),
                                                  ),
                                                  SizedBox(
                                                    height: 14,
                                                  ),
                                                  Text(
                                                    "Opening the camera\nand scan the bus arriving",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'PretendardSemiBold',
                                                        fontSize: 18,
                                                        color:
                                                            Color(0xFFF9F9F9),
                                                        height: 26 / 18),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 495,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomRight,
                          children: [
                            AnimatedOpacity(
                              opacity: !_isSetBus ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 800),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 24.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _scanBusBoxHeight = 0;
                                        _scanBusboxWidthMargin = screenWidth;
                                        _setBusBoxHeight = 380;
                                        _setBusBoxWidthMargin = 56;
                                        _isSetBus = true;
                                        _isScan = false;
                                        _scanBusTextShow = false;
                                      });

                                      Timer(const Duration(milliseconds: 500),
                                          () {
                                        _setBusTextShow = true;
                                        setState(() {});
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        const Text(
                                          "SET BUS",
                                          style: TextStyle(
                                              fontFamily: 'PretendardExtraBold',
                                              fontSize: 36,
                                              color: Color(0x88101010)),
                                        ),
                                        const SizedBox(
                                          width: 22.0,
                                        ),
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0x88101010)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 28.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const SetBusPage(
                                            title: "set bus",
                                          )));
                                },
                                child: AnimatedOpacity(
                                  opacity: _isSetBus ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 400),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.easeInOut,
                                    width: screenWidth - _setBusBoxWidthMargin,
                                    height: _setBusBoxHeight,
                                    decoration: const BoxDecoration(
                                        color: Color(0xFF101010),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    child: _setBusTextShow
                                        ? AnimatedOpacity(
                                            opacity:
                                                _setBusTextShow ? 1.0 : 0.0,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 24.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 25,
                                                  ),
                                                  Text(
                                                    "SET BUS",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'PretendardExtraBold',
                                                        fontSize: 36,
                                                        color:
                                                            Color(0xFFF9F9F9)),
                                                  ),
                                                  SizedBox(
                                                    height: 14,
                                                  ),
                                                  Text(
                                                    "Opening the camera\nand scan the bus arriving",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'PretendardSemiBold',
                                                        fontSize: 18,
                                                        color:
                                                            Color(0xFFF9F9F9),
                                                        height: 26 / 18),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
