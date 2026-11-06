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
      child: ListTile(
        title: Text(title),
        leading: Icon(iconLeading),
        trailing: IconButton(icon: Icon(iconTrailling), onPressed: onPressed),
      ),
    );
  }
}
