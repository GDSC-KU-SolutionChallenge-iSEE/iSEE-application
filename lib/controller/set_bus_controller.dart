import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/state_manager.dart';
import 'package:isee/model/arriving_item.dart';
import 'package:isee/model/route_item.dart';
import 'package:isee/model/station_item.dart';

class SetBusController extends GetxController {
  late String stationSearchWord;
  late int myStationId;
  late String myStationName;
  late int myBusId;
  late String myBusName;

  late int arriveSec;

  List<StationItem> stationList = [];
  List<RouteItem> busList = [];
  List<ArrivingItem> arrivingTimeList = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  setStationSearchWord(input) {
    stationSearchWord = input;
  }

  Future<dynamic> getStationList(idToken, keyword) async {
    Map<String, String> param = {"keyword": keyword};

    final response = await http.get(
      Uri.parse('https://isee-server-3i3g4hvcqq-du.a.run.app/nodes/search')
          .replace(queryParameters: param),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(utf8.decode(response.bodyBytes));
      return result;
    }

    return null;
  }

  Future<dynamic> getBusList(idToken, nodeId) async {
    final response = await http.get(
      Uri.parse(
          'https://isee-server-3i3g4hvcqq-du.a.run.app/nodes/route/$nodeId'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      final result = jsonDecode(utf8.decode(response.bodyBytes));
      print(result);
      return result;
    }

    return null;
  }

  Future<dynamic> getArrivingList(idToken, nodeId) async {
    final response = await http.get(
      Uri.parse(
          'https://isee-server-3i3g4hvcqq-du.a.run.app/nodes/route/arrive/$nodeId'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      final result = jsonDecode(utf8.decode(response.bodyBytes));
      print(result);
      return result;
    }

    return null;
  }

  Future<List<StationItem>> searchStation(input) async {
    setStationSearchWord(input);

    final idToken = await _auth.currentUser!.getIdToken();

    final stationListResponse =
        await getStationList(idToken, stationSearchWord);

    if (stationListResponse != null) {
      stationList = stationListResponse["result"]
          .map<StationItem>((json) => StationItem.fromJson(json))
          .toList();
    } else {
      stationList = [];
    }

    print(stationList);

    return stationList;
  }

  Future<List<RouteItem>> setMyStation(stationId, stationName) async {
    myStationId = stationId;
    myStationName = stationName;

    final idToken = await _auth.currentUser!.getIdToken();

    final busListResponse = await getBusList(idToken, myStationId);

    if (busListResponse != null) {
      busList = busListResponse["result"]
          .map<RouteItem>((json) => RouteItem.fromJson(json))
          .toList();
    } else {
      busList = [];
    }

    final arrivingListResponse = await getArrivingList(idToken, myStationId);

    if (arrivingListResponse != null) {
      arrivingTimeList = arrivingListResponse["result"]
          .map<ArrivingItem>((json) => ArrivingItem.fromJson(json))
          .toList();
    }

    return busList;
  }

  setMyBus(routeId, routeName) {
    myBusId = routeId;
    myBusName = routeName;
  }

  setMyBusArriveTime() {
    final myArriveItem =
        arrivingTimeList.firstWhere((element) => element.routeId == myBusId);

    print(myArriveItem.firstArriveMsg);
    final arriveText = myArriveItem.firstArriveMsg;

    if (arriveText == "곧 도착") {
      arriveSec = 1;
    } else if (arriveText == "출발대기" || arriveText == "운행종료") {
      arriveSec = -1;
    } else {
      final splittedMinute = arriveText.split('분');
      final minute = int.parse(splittedMinute[0]);

      final splittedSecond = splittedMinute[1].split('초');
      final second = int.parse(splittedSecond[0]);

      print(minute);
      print(second);

      arriveSec = 60 * minute + second;
    }
  }
}
