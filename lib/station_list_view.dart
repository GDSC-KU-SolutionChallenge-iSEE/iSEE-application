import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    _debounce!.cancel();
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
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 200,
            ),
            Container(
              width: 338,
              height: 56,
              color: Colors.white,
              child: TextField(
                controller: _stationInputController,
                maxLines: 1,
                focusNode: _stationInputFocusNode,
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
            )
          ],
        ),
      ),
    ));
  }
}
