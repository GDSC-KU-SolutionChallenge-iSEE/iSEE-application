import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SetBusController extends GetxController {
  late String stationSearchWord;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  setStationSearchWord(input) {
    stationSearchWord = input;
    print(stationSearchWord);
  }

  Future<dynamic> requestStationList(idToken, keyword) async {
    print("request");
    Map<String, String> param = {"keyword": keyword};

    final response = await http.get(
      Uri.parse('https://isee-server-3i3g4hvcqq-du.a.run.app/nodes/search')
          .replace(queryParameters: param),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      final result = jsonDecode(utf8.decode(response.bodyBytes));
      print(result);
    }
  }

  searchStation(input) async {
    setStationSearchWord(input);

    final idToken = await _auth.currentUser!.getIdToken();

    await requestStationList(idToken, stationSearchWord);
  }
}
