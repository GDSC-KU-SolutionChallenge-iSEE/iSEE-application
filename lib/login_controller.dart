import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<dynamic> isNewUser(userId, idToken) async {
    final response = await http.get(
      Uri.parse('https://isee-server-3i3g4hvcqq-du.a.run.app/users/$userId'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(utf8.decode(response.bodyBytes));
      print(result);

      return result["success"];
    }
  }

  Future<dynamic> addUser(idToken) async {
    final response = await http.post(
      Uri.parse('https://isee-server-3i3g4hvcqq-du.a.run.app/users'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    print(response.statusCode);
    print(jsonDecode(utf8.decode(response.bodyBytes)));

    return response.statusCode;
  }

  Future<dynamic> resignUser(idToken) async {
    final response = await http.delete(
      Uri.parse('https://isee-server-3i3g4hvcqq-du.a.run.app/users'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    print(response.statusCode);
    print(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  googleLogin() async {
    print("google login");
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final authResult = await _auth.signInWithCredential(credential);

      final User? user = authResult.user;
      assert(!user!.isAnonymous);

      final idToken = await user!.getIdToken();
      assert(idToken != null);

      final User? currentUser = _auth.currentUser;
      assert(user.uid == currentUser!.uid);

      final isNew = await isNewUser(currentUser!.uid, idToken);

      if (!isNew) {
        final res = await addUser(idToken);

        if (res == 200) {
          Get.toNamed('/home');
        }
      } else {
        Get.toNamed('/home');
      }

      return;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  resign() async {
    final idToken = _auth.currentUser!.getIdToken();
    await resignUser(idToken);
  }

  Future<void> logoutGoogle() async {
    await googleSignIn.signOut();
    Get.back(); // navigate to your wanted page after logout.
  }
}
