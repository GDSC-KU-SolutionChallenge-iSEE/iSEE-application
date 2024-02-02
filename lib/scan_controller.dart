import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:get/state_manager.dart';
import 'package:image/image.dart' as img;

class ScanController extends GetxController {
  final RxBool _isInitialized = RxBool(false);
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  late CameraImage _cameraImage;

  bool get isInitialized => _isInitialized.value;
  CameraController get cameraController => _cameraController;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    _cameraController.initialize().then((_) {
      _isInitialized.value = true;

      _cameraController.startImageStream((image) {
        _cameraImage = image;
        print(image);
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

  @override
  void onInit() {
    _initCamera();
    super.onInit();
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
  }

  void capture() async {
    var captureImage = convert();

    final idToken = await _auth.currentUser!.getIdToken();

    final res = await requestBusNum(idToken, captureImage);
  }

  // UInt8List to Base64
  String convert() {
    Uint8List imageUint8 = _cameraImage.planes[0].bytes;

    String result = base64Encode(imageUint8);

    return result;
  }
}
