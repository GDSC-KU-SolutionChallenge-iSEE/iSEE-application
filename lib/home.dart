import 'package:flutter/material.dart';
import 'package:isee/camera/camera_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CameraScreen()));
            },
            child: Container(
              width: 100,
              height: 80,
              color: Colors.blueAccent,
              child: const Text("스캔 버튼"),
            ),
          ),
          Container(
            width: 100,
            height: 80,
            color: Colors.purpleAccent,
            child: const Text("탑승 설정"),
          )
        ],
      )),
    );
  }
}
