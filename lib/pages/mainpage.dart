import 'package:flutter/material.dart';
import 'package:library_project/pages/Quotespage.dart';
import 'package:library_project/pages/homepage.dart';
import 'package:library_project/pages/myprogresspage.dart';
import 'package:library_project/pages/profilepage.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int currentPage = 0;
  final List<Widget> pages = [
    Homepage(),
    Quotespage(),
    Myprogresspage(),
    Profilepage(),
  ];

  final List<String> titles = ["مكتبتي", "اقتباساتي", "تقدمي", "ملفي الشخصي"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF462619),
        selectedItemColor: Color(0xFFEFE8DE),
        unselectedItemColor: Color.fromARGB(255, 119, 100, 95),
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "مكتبتي"),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_copy),
            label: "اقتباساتي",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_activity_outlined),
            label: "تقدمي",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "ملفي الشخصي",
          ),
        ],
      ),

      appBar: AppBar(
        backgroundColor: Color(0xFFEFE8DE),
        centerTitle: true,
        title: Text(
          titles[currentPage],
          style: TextStyle(
            color: Color(0xFF462619),
            fontSize: 35,
            fontWeight: FontWeight(900),
          ),
        ),
      ),
      body: pages[currentPage],
    );
  }
}
