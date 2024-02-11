import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        width: 104,
        height: 104,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF101010),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.asset("assets/home_white.png"),
        ),
      ),
    );
  }
}
