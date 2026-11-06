import 'package:flutter/material.dart';

class Myiconbutton extends StatelessWidget {
  final void Function()? onPressed;
  final IconData icon;

  const Myiconbutton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(15),
    //     color: Color.fromARGB(255, 119, 100, 95),
    //   ),
    //   child:
      return IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 40,
        color: Color.fromARGB(255, 119, 100, 95),
      );
    // );
  }
}
