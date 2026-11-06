import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:library_project/auth/startscreen.dart';
import 'package:library_project/mywidgets/mycard.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFFEFE8DE),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Image.asset(
                    "images/piccc.png",
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Text("Marwa"),

              SizedBox(height: 10),
              Mycard(
                title: "Account",
                iconLeading: Icons.account_box_outlined,
                iconTrailling: Icons.arrow_back_ios_new,
              ),

              SizedBox(height: 10),
              Mycard(
                title: "Language",
                iconLeading: Icons.language,
                iconTrailling: Icons.arrow_back_ios_new,
              ),

              SizedBox(height: 10),
              Mycard(
                title: "Setting",
                iconLeading: Icons.settings,
                iconTrailling: Icons.arrow_back_ios_new,
              ),

              SizedBox(height: 10),
              Mycard(
                title: "Notifications",
                iconLeading: Icons.notification_add_outlined,
                iconTrailling: Icons.arrow_back_ios_new,
              ),

              SizedBox(height: 10),
              Mycard(
                title: "Sign out",
                iconLeading: Icons.outbond,
                iconTrailling: Icons.arrow_back_ios_new,
                onPressed: () async {
                  // 1. تسجيل الخروج من الفايربيس
                  await FirebaseAuth.instance.signOut();

                  // 2. تسجيل الخروج من حساب غوغل (لتنظيف الكاش ومسح الجلسة المعلقة)
                  await GoogleSignIn.instance.signOut();

                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => StartScreen()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// leading: IconButton(
//           onPressed: () async {
//             await FirebaseAuth.instance.signOut();
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => StartScreen()),
//             );
//           },
//           icon: const Icon(Icons.arrow_back),
//         ),
