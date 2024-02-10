import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isee/global_bindings.dart';
import 'package:isee/bottom_navigation.dart';
import 'package:isee/global_controller.dart';
import 'package:isee/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalController globalController = Get.put(GlobalController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const LoginPage(
        title: "login",
      ),
      initialBinding: GlobalBindings(),
      getPages: [
        GetPage(name: '/home', page: () => const BottomNavigationView())
      ],
    );
  }
}
