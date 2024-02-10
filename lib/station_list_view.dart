import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isee/global_controller.dart';
import 'package:isee/login_controller.dart';
import 'package:isee/set_bus_controller.dart';

class StationListView extends StatefulWidget {
  const StationListView({super.key, required this.title});

  final String title;

  @override
  State<StationListView> createState() => _StationListViewState();
}

class _StationListViewState extends State<StationListView> {
  final SetBusController controller = Get.put(SetBusController());
  final GlobalController globalController = Get.put(GlobalController());
  final _stationInputController = TextEditingController();
  final _stationInputFocusNode = FocusNode();

  Timer? _debounce;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _debounce?.cancel();
    _stationInputController.dispose();
    _stationInputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        _stationInputFocusNode.unfocus();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.6),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "SETTING the BUS",
              style: TextStyle(
                  fontFamily: 'PretendardExtraBold',
                  fontSize: 36,
                  color: Color(0xFFF9F9F9)),
            ),
            const SizedBox(
              height: 54,
            ),
            Container(
              width: 338,
              height: 56,
              decoration: const BoxDecoration(
                  color: Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: TextField(
                controller: _stationInputController,
                maxLines: 1,
                focusNode: _stationInputFocusNode,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  if (_debounce?.isActive ?? false) _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    controller.searchStation(value);
                  });
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.setMyStation("105000091", "안암오거리");
              },
              child: Container(
                width: 100,
                height: 100,
                color: Colors.amber,
              ),
            ),
            GestureDetector(
              onTap: () async {
                controller.setMyBus("100100006", "101");
                await controller.setMyBusArriveTime();

                globalController.setMyBusTimer(
                    controller.arriveSec, controller.myBusName);
              },
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blueAccent,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
