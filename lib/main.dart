import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:isee/global_bindings.dart';
import 'package:isee/home.dart';
import 'package:isee/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   return GetMaterialApp(
  //     home: const LoginPage(title: "iSEE"),
  //     initialBinding: GlobalBindings(),
  //     getPages: [
  //       GetPage(name: '/home', page: () => const HomePage(title: "Home"))
  //     ],
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const LoginPage(
        title: "login",
      ),
      initialBinding: GlobalBindings(),
      getPages: [
        GetPage(name: '/home', page: () => const HomePage(title: "Home"))
      ],
    );
  }
}
