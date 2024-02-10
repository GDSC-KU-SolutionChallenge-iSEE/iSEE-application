import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isee/bus_list_view.dart';
import 'package:isee/global_controller.dart';
import 'package:isee/login_controller.dart';
import 'package:isee/set_bus_controller.dart';
import 'package:isee/station_list_view.dart';

class SetBusPage extends StatefulWidget {
  const SetBusPage({super.key, required this.title});

  final String title;

  @override
  State<SetBusPage> createState() => _SetBusPageState();
}

class _SetBusPageState extends State<SetBusPage> {
  final SetBusController controller = Get.put(SetBusController());
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Stack(
        children: [
          // BusListView(title: "buslist"),
          StationListView(title: "stationList"),
        ],
      ),
    ));
  }
}
