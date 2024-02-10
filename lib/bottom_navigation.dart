import 'package:flutter/material.dart';
import 'package:isee/camera/camera_screen.dart';
import 'package:isee/global_controller.dart';
import 'package:isee/home.dart';
import 'package:isee/set_bus_screen.dart';

class BottomNavigationView extends StatefulWidget {
  const BottomNavigationView({super.key});

  @override
  State<BottomNavigationView> createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState extends State<BottomNavigationView> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: SizedBox(
          width: 83,
          height: 83,
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF101010),
              shape: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  "assets/home_white.png",
                ),
              ),
              onPressed: () {
                setState(() {
                  index = 0;
                });
              },
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(38),
            topLeft: Radius.circular(38),
          ),
          child: BottomAppBar(
            color: const Color(0xFF101010),
            elevation: 0.0,
            shape: const CircularNotchedRectangle(),
            notchMargin: 14.0,
            padding: const EdgeInsets.all(0.0),
            height: 138 - (MediaQuery.of(context).padding.bottom),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset("assets/bookmark_white.png"),
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        index = 2;
                      });
                    },
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset("assets/setting_white.png"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: const HomePage());
  }
}
