import 'package:flutter/material.dart';
import 'package:library_project/auth/startscreen.dart';

class Welcomepage extends StatefulWidget {
  const Welcomepage({super.key});

  @override
  State<Welcomepage> createState() => _WelcomepageState();
}

class _WelcomepageState extends State<Welcomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 51, 29, 22),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/picc.webp"),
            fit: BoxFit.cover,
          ),
        ),

        child: Column(
          children: [
            SizedBox(height: 200),
            Center(child: Image.asset("images/logopic.png")),

            // SizedBox(height: 30,),
            Text(
              "مرحباً بك في عالمك الصغير بين الكتب... ",
              style: TextStyle(
                
                color: Color(0xFFD7C9B8),
                fontWeight: FontWeight(1000),
                fontSize:24,
              ),
                                textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
            ),

            SizedBox(height: 50),

            SizedBox(
              width: 150,
              height: 50,
              child: MaterialButton(
                color: Color(0xFFD7C9B8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(30),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => StartScreen()),
                  );
                },
                child: Text(
                  "إنشاء حساب",
                  style: TextStyle(
                    color: Colors.brown[900],
                    fontWeight: FontWeight(900),
                    fontSize: 26,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//  "images/finalpic.png",