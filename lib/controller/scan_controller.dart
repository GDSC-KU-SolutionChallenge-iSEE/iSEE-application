import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:get/state_manager.dart';
import 'package:image/image.dart' as imglib;
import 'package:image/image.dart';

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
    setTts();
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

      if (busIdList.isNotEmpty) {
        if (!_isCaptureReading) {
          // print(busIdText);
          ttsStream.stop();
          ttsStream.speak("Bus $busIdText is infront of you.");
          busIdList = [];
        }
      }
    });
  }

  Future<dynamic> requestBusNum(idToken, imageString) async {
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
    print("tset");
    var captureImage = convert();

    final idToken = await _auth.currentUser!.getIdToken();

    // var test = base64Decode(captureImage);
    // await ImageGallerySaver.saveImage(test);

    final res = await requestBusNum(idToken, captureImage);
    List busIds = [];
    String busIdText = "";

    if (res != null) {
      busIds = res["result"]["bus_ids"];
      if (busIds.isNotEmpty) {
        busIdText = busIds.join(", ");
      }
    }

    ttsStream.stop();
    ttsCapture.stop();

    _isCaptureReading = true;
    if (busIds.isNotEmpty) {
      ttsCapture.speak("The number of the bus you captured is $busIdText.");
    } else {
      ttsCapture.speak("There are no buses infront of you.");
    }

    _isCaptureReading = false;
  }

  // UInt8List to Base64
  String convert() {
    imglib.Image test = imglib.Image.fromBytes(
      width: _cameraImage!.width * 2 ~/ 3,
      height: _cameraImage!.height * 2 ~/ 3,
      bytes: _cameraImage!.planes[0].bytes.buffer,
      rowStride: _cameraImage!.planes[0].bytesPerRow,
      bytesOffset: 28,
      order: ChannelOrder.bgra,
    );

    Uint8List resized = Uint8List.fromList(imglib.encodeJpg(test));

    print(resized.lengthInBytes);

    String result = base64Encode(resized);

    return result;
  }
}
