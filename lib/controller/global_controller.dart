import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/state_manager.dart';

class GlobalController extends GetxController {
  final FlutterTts tts = FlutterTts();
  Timer? myBusTimer;

  setMyBusTimer(arriveSeconds, busName) {
    if (myBusTimer != null) {
      myBusTimer!.cancel();
    }

    if (arriveSeconds == -1) {
      tts.speak("There is no arriving information");
    } else if (arriveSeconds <= 60) {
      tts.speak(busName + "will arrive soon");
    } else {
      if (myBusTimer == null) {
        myBusTimer = Timer(Duration(seconds: arriveSeconds - 60), () {
          tts.speak(busName + "will arrive soon");
        });
      } else {
        myBusTimer!.cancel();
        myBusTimer = Timer(Duration(seconds: arriveSeconds - 60), () {
          tts.speak(busName + "will arrive soon");
        });
      }
    }
  }
}
