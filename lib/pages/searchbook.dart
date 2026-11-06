import 'package:flutter/material.dart';

class Searchbook extends StatefulWidget {
  const Searchbook({super.key});

  @override
  State<Searchbook> createState() => _SearchbookState();
}

class _SearchbookState extends State<Searchbook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEFE8DE),
        centerTitle: true,
        title: Text(
          "Search Books",
          style: TextStyle(
            color: Color(0xFF4E342E),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
