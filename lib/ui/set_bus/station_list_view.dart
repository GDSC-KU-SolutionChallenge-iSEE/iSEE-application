import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:isee/controller/global_controller.dart';
import 'package:isee/controller/set_bus_controller.dart';
import 'package:isee/model/arriving_item.dart';
import 'package:isee/model/route_item.dart';
import 'package:isee/model/station_item.dart';
import 'package:isee/ui/home_button.dart';

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

  var focusBackgroundColor = Colors.transparent;

  bool _isSetStation = true;

  List<StationItem> stationList = [];
  List<RouteItem> busList = [];
  List<ArrivingItem> arrivingTimeList = [];

  var myStationId;
  var myStationName;

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
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
            onTap: () {
              _stationInputFocusNode.unfocus();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: const Color(0xFF101010).withOpacity(0.6),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_isSetStation)
                    Column(
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
                          height: 14,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: _stationInputFocusNode.hasFocus &&
                                  stationList.isEmpty
                              ? 118
                              : MediaQuery.of(context).size.height -
                                  (164 +
                                      MediaQuery.of(context).viewInsets.bottom),
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                              color: _stationInputFocusNode.hasFocus ||
                                      stationList.isNotEmpty
                                  ? const Color(0xFFF9F9F9)
                                  : Colors.transparent,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: 338,
                                height: 56,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFF9F9F9),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    border: _stationInputFocusNode.hasFocus ||
                                            stationList.isNotEmpty
                                        ? Border.all(
                                            color: const Color(0xFF101010),
                                            width: 2)
                                        : null),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: TextField(
                                      controller: _stationInputController,
                                      maxLines: 1,
                                      focusNode: _stationInputFocusNode,
                                      style: const TextStyle(
                                          fontFamily: 'PretendardSemibold',
                                          fontSize: 25,
                                          color: Color(0xFF101010)),
                                      cursorColor: const Color(0xFF101010),
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(0.0),
                                          isDense: true),
                                      onChanged: (value) {
                                        if (_debounce?.isActive ?? false) {
                                          _debounce?.cancel();
                                        }
                                        _debounce = Timer(
                                            const Duration(milliseconds: 500),
                                            () {});
                                      },
                                      onSubmitted: (value) {
                                        showCupertinoDialog(
                                            context: context,
                                            builder:
                                                (BuildContext buildContext) {
                                              return StationSelectAlert(value);
                                            });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              if (!_stationInputFocusNode.hasFocus &&
                                  stationList.isEmpty)
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 18.0,
                                    ),
                                    Image.asset(
                                      "assets/arrow_up.png",
                                      width: 18.0,
                                    ),
                                    const SizedBox(
                                      height: 18.0,
                                    ),
                                    const Text(
                                      "click the bar above to search the \n BUS STATION",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'PretendardSemibold',
                                          fontSize: 18,
                                          color: Color(0xFFF9F9F9)),
                                    )
                                  ],
                                ),
                              Container(
                                height: stationList.isEmpty ? 30 : 68,
                              ),
                              if (stationList.isNotEmpty)
                                Container(
                                  height: 2,
                                  color:
                                      const Color(0xFF101010).withOpacity(0.3),
                                ),
                              if (stationList.isNotEmpty)
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics: const ClampingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    child: StationItemView(),
                                  ),
                                )
                            ],
                          ),
                        ),

                        // GestureDetector(
                        //   onTap: () async {
                        //     controller.setMyBus("100100006", "101");
                        //     await controller.setMyBusArriveTime();

                        //     globalController.setMyBusTimer(
                        //         controller.arriveSec, controller.myBusName);
                        //   },
                        //   child: Container(
                        //     width: 100,
                        //     height: 100,
                        //     color: Colors.blueAccent,
                        //   ),
                        // )
                      ],
                    ),
                  if (!_isSetStation)
                    Column(
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
                          height: 14,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 56,
                          height: 156,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF9F9F9),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 44.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      myStationName,
                                      style: const TextStyle(
                                          fontFamily: 'PretendardSemibold',
                                          fontSize: 22,
                                          color: Color(0xFF101010)),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xFF101010)),
                                      child: Text(
                                        myStationId.toString(),
                                        style: const TextStyle(
                                            fontFamily: 'PretendardSemibold',
                                            fontSize: 22,
                                            color: Color(0xFFF9F9F9)),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 315,
                          height: 1,
                          color: const Color(0xFF101010),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 56,
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height - 420),
                          decoration: BoxDecoration(
                            color: const Color(0xFF101010).withOpacity(0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Expanded(
                            child: SingleChildScrollView(child: BusItemView()),
                          ),
                        )
                      ],
                    ),
                  if (!_stationInputFocusNode.hasFocus)
                    Column(
                      children: [
                        const Expanded(child: SizedBox()),
                        const HomeButton(),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom,
                        )
                      ],
                    )
                ],
              ),
            )));
  }

  Widget StationSelectAlert(value) {
    return CupertinoAlertDialog(
      title: const Text(
        "Are you sure?",
        style: TextStyle(color: Colors.black),
      ),
      content: const Text(
        "If you select yes, we will search\nthe station you want.",
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text(
              "No",
              style: TextStyle(color: Color(0xFF007AFF)),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        CupertinoDialogAction(
            child: const Text(
              "Yes",
              style: TextStyle(color: Color(0xFF007AFF)),
            ),
            onPressed: () async {
              Navigator.pop(context);
              stationList = await controller.searchStation(value);
              setState(() {});
            })
      ],
    );
  }

  Widget BusSelectAlert(busId, busName) {
    return CupertinoAlertDialog(
      title: const Text(
        "Are you sure?",
        style: TextStyle(color: Colors.black),
      ),
      content: const Text(
        "If you select yes, we will tell you\nthe bus you are looking for.",
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text(
              "No",
              style: TextStyle(color: Color(0xFF007AFF)),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        CupertinoDialogAction(
            child: const Text(
              "Yes",
              style: TextStyle(color: Color(0xFF007AFF)),
            ),
            onPressed: () async {
              Navigator.pop(context);
              controller.setMyBus(busId, busName);
              await controller.setMyBusArriveTime();

              globalController.setMyBusTimer(
                  controller.arriveSec, controller.myBusName);

              Navigator.pop(context);
            })
      ],
    );
  }

  Widget StationItemView() {
    return Column(
      children: List.of(stationList).map((e) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            busList = await controller.setMyStation(e.nodeId, e.nodeName);
            _isSetStation = false;
            myStationId = e.nodeId;
            myStationName = e.nodeName;
            setState(() {});
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 28.0, vertical: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          e.nodeName,
                          style: const TextStyle(
                              fontFamily: 'PretendardSemibold',
                              fontSize: 22,
                              color: Color(0xFF101010)),
                        ),
                        const Expanded(child: SizedBox()),
                        Container(
                          decoration:
                              const BoxDecoration(color: Color(0xFF101010)),
                          child: Text(
                            e.nodeId.toString(),
                            style: const TextStyle(
                                fontFamily: 'PretendardSemibold',
                                fontSize: 22,
                                color: Color(0xFFF9F9F9)),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 44.0,
                    ),
                  ],
                ),
              ),
              Container(
                height: 2,
                color: const Color(0xFF101010).withOpacity(0.3),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget BusItemView() {
    return Column(
      children: List.of(busList).map((e) {
        return SizedBox(
          width: MediaQuery.of(context).size.width - 56,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Text(
                          e.routeName,
                          style: const TextStyle(
                              fontFamily: 'PretendardSemiBold',
                              fontSize: 22,
                              color: Color(0xFFF9F9F9)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        GestureDetector(
                          onTap: () {
                            showCupertinoDialog(
                                context: context,
                                builder: (BuildContext buildContext) {
                                  return BusSelectAlert(e.routeId, e.routeName);
                                });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color:
                                    const Color(0xFFF9F9F9).withOpacity(0.5)),
                            child: const Text(
                              "SELECT",
                              style: TextStyle(
                                  fontFamily: 'PretendardSemiBold',
                                  fontSize: 22,
                                  color: Color(0xFF101010)),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
              Container(
                height: 2.0,
                decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9).withOpacity(0.3)),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}
