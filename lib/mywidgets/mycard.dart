import 'package:flutter/material.dart';

class Mycard extends StatelessWidget {
  final String title;
  final IconData iconLeading;
  final IconData iconTrailling;
  final void Function()? onPressed;

  const Mycard({
    super.key,
    required this.title,
    required this.iconLeading,
    required this.iconTrailling,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 238, 217, 198),
      elevation: 5.0, // قوة الظل وبروزه (5 أو 6 ممتاز لكي لا يكون ضخماً)
      shadowColor: const Color(0xFF462619).withOpacity(0.6),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(fontSize: 20, color: Color(0xFF462619)),
            textDirection: TextDirection.rtl,
          ),

          leading: Icon(iconLeading, color: Color(0xFF462619)),
          trailing: IconButton(
            icon: Icon(iconTrailling, color: Color(0xFF462619)),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
