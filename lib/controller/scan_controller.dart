import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
  FlutterTts shutterSound = FlutterTts();
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
    await shutterSound.setLanguage("en-US");
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
      busIdList = busIdList.toSet().toList();
    }
  }

  void setTimer() {
    requestTimer ??= Timer.periodic(const Duration(seconds: 3), (timer) {
      requestOnTimer();
    });

    ttsTimer ??= Timer.periodic(const Duration(seconds: 6), (timer) {
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
    ttsStream.stop();
    ttsCapture.stop();
    shutterSound.speak("captured");

    var captureImage = convert();

    final idToken = await _auth.currentUser!.getIdToken();

    // var test = base64Decode(captureImage);
    // await ImageGallerySaver.saveImage(test);

    final res = await requestBusNum(idToken, captureImage);
    List busIds = [];
    String busIdText = "";

    if (res != null) {
      busIds = res["result"]["bus_ids"];
      busIds = busIds.toSet().toList();
      if (busIds.isNotEmpty) {
        busIdText = busIds.join(", ");
      }
    }

    ttsStream.stop();
    ttsCapture.stop();

    _isCaptureReading = true;
    if (busIds.isNotEmpty) {
      await ttsCapture
          .speak("The number of the bus you captured is $busIdText.");
    } else {
      await ttsCapture.speak("There are no buses infront of you.");
    }

    _isCaptureReading = false;
  }

  // UInt8List to Base64
  String convert() {
    imglib.Image formattedImage;

    if (Platform.isIOS) {
      formattedImage = imglib.Image.fromBytes(
        width: _cameraImage!.width * 2 ~/ 3,
        height: _cameraImage!.height * 2 ~/ 3,
        bytes: _cameraImage!.planes[0].bytes.buffer,
        rowStride: _cameraImage!.planes[0].bytesPerRow,
        bytesOffset: 28,
        order: ChannelOrder.bgra,
      );
    } else {
      var setImage = _cameraImage;

      final int width = setImage!.width;
      final int height = setImage.height;
      final int uvRowStride = setImage.planes[1].bytesPerRow;
      final int? uvPixelStride = setImage.planes[1].bytesPerPixel;
      const shift = (0xFF << 24);

      print("uvRowStride: $uvRowStride");
      print("uvPixelStride: $uvPixelStride");

      formattedImage =
          imglib.Image(width: height, height: width); // Create Image buffer

      // Fill image buffer with plane[0] from YUV420_888
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          final int uvIndex =
              uvPixelStride! * (x / 2).floor() + uvRowStride * (y / 2).floor();
          final int index = y * width + x;

          final yp = setImage.planes[0].bytes[index];
          final up = setImage.planes[1].bytes[uvIndex];
          final vp = setImage.planes[2].bytes[uvIndex];
          // Calculate pixel color
          int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
          int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

          if (formattedImage.isBoundsSafe(height - y, x)) {
            formattedImage.setPixelRgba(height - y, x, r, g, b, shift);
          }
        }
      }
    }

    Uint8List resized = Uint8List.fromList(imglib.encodeJpg(formattedImage));

    print(resized.lengthInBytes);

    String result = base64Encode(resized);

    return result;
  }
}
