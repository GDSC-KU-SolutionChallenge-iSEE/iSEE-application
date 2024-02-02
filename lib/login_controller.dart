import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<dynamic> addUser(idToken) async {
    final response = await http.post(
      Uri.parse('https://isee-server-3i3g4hvcqq-du.a.run.app/users'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    print(response.statusCode);
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

      final res = await addUser(idToken);

      Get.toNamed('/home'); // navigate to your wanted page
      return;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> logoutGoogle() async {
    await googleSignIn.signOut();
    Get.back(); // navigate to your wanted page after logout.
  }
}
