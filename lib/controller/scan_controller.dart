import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:get/state_manager.dart';

class ScanController extends GetxController {
  final RxBool _isInitialized = RxBool(false);
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  CameraImage? _cameraImage;

  bool get isInitialized => _isInitialized.value;
  CameraController get cameraController => _cameraController;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FlutterTts ttsStream = FlutterTts();
  final FlutterTts ttsCapture = FlutterTts();
  bool _isCaptureReading = false;
  var busIdList = [];

  var requestTimer;
  var ttsTimer;

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    _cameraController.initialize().then((_) {
      _isInitialized.value = true;

      _cameraController.startImageStream((image) {
        _cameraImage = image;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  void setTts() async {
    await ttsCapture.setLanguage("en-US");
    await ttsStream.setLanguage("en-US");
  }

  void setCamera() {
    _isInitialized.value = true;
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    await _initCamera();
    setTimer();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    remove();
    super.onClose();
  }

  void remove() async {
    requestTimer?.cancel();
    requestTimer = null;
    ttsTimer?.cancel();
    ttsTimer = null;
    print(requestTimer);
    print(ttsTimer);
    ttsStream.stop();
    ttsCapture.stop();
    // _isInitialized.value = false;
  }

  void requestOnTimer() async {
    var captureImage = convert();

    final idToken = await _auth.currentUser!.getIdToken();

    final res = await requestBusNum(idToken, captureImage);

    if (res != null) {
      busIdList.addAll(res["result"]["bus_ids"]);
    }
  }

  void setTimer() {
    requestTimer ??= Timer.periodic(const Duration(seconds: 3), (timer) {
      requestOnTimer();
    });

    ttsTimer ??= Timer.periodic(const Duration(seconds: 3), (timer) {
      var busIdText = busIdList.join(", ");
      busIdList = [];

      if (busIdList.isNotEmpty) {
        if (!_isCaptureReading) {
          ttsStream.stop();
          ttsStream.speak("Bus $busIdText is infront of you.");
        }
      }
    });
  }

  Future<dynamic> requestBusNum(idToken, imageString) async {
    print("request");
    final response = await http.post(
        Uri.parse('https://isee-server-3i3g4hvcqq-du.a.run.app/bus-image'),
        headers: {
          'Authorization': 'Bearer $idToken',
        },
        body: {
          'bus_image': imageString
        });

    print(response.statusCode);

    if (response.statusCode == 201) {
      final result = jsonDecode(utf8.decode(response.bodyBytes));
      print(result);
      return result;
    } else {
      return null;
    }
  }

  void capture() async {
    var captureImage = convert();

    final idToken = await _auth.currentUser!.getIdToken();

    final res = await requestBusNum(idToken, captureImage);
    var busIds;
    var busIdText;

    if (res != null) {
      busIds = res["result"]["bus_ids"];
      busIdText = busIds.join(", ");
    }

    print(busIds);

    print(busIdText);

    ttsStream.stop();
    ttsCapture.stop();

    _isCaptureReading = true;
    if (busIds != null) {
      ttsCapture.speak("The number of the bus you captured is $busIdText.");
    } else {
      ttsCapture.speak("There are no buses infront of you.");
    }

    _isCaptureReading = false;
  }

  // UInt8List to Base64
  String convert() {
    Uint8List imageUint8 = _cameraImage!.planes[0].bytes;

    String result = base64Encode(imageUint8);

    return result;
  }
}
