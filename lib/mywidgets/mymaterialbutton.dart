import 'package:flutter/material.dart';

class Mymaterialbutton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;

  const Mymaterialbutton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Center(
        child: SizedBox(
          width: 200,
          child: MaterialButton(
            height: 50,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              
            ),
            color: Color(0xFF462619),
            onPressed: onPressed,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight(900),
                color: Color(0xFFEFE8DE),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
