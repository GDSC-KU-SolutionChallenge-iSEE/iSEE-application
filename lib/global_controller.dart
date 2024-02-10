import 'dart:async';
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GlobalController extends GetxController {
  final FlutterTts tts = FlutterTts();
  Timer? myBusTimer;

  setMyBusTimer(arriveSeconds, busName) {
    if (arriveSeconds == -1) {
      tts.speak("현재 운행정보가 없습니다.");
    } else if (arriveSeconds <= 60) {
      tts.speak(busName + "번 버스가 곧 도착합니다.");
    } else {
      if (myBusTimer == null) {
        myBusTimer = Timer(Duration(seconds: arriveSeconds - 60), () {
          tts.speak(busName + "번 버스가 곧 도착합니다.");
        });
      } else {
        myBusTimer!.cancel();
        myBusTimer = Timer(Duration(seconds: arriveSeconds - 60), () {
          tts.speak(busName + "번 버스가 곧 도착합니다.");
        });
      }
    }
  }
}
