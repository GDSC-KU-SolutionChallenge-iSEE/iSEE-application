import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isee/login_controller.dart';
import 'package:isee/set_bus_controller.dart';

class BusListView extends StatefulWidget {
  const BusListView({super.key, required this.title});

  final String title;

  @override
  State<BusListView> createState() => _BusListViewState();
}

class _BusListViewState extends State<BusListView> {
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
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const SizedBox(
            height: 500,
          ),
          Container(
            width: 338,
            height: 56,
            color: Colors.amber,
          )
        ],
      ),
    ));
  }
}
