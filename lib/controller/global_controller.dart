import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/state_manager.dart';

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
