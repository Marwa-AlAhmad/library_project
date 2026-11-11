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
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: 10),

              Text(
                // 👈 هذا السطر يقرأ اسم المستخدم من حساب جوجل المسجل حالياً، وإذا لم يجده يضع نصاً بدعاً
                FirebaseAuth.instance.currentUser?.displayName ??
                    "قارئ متميز ✨",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF462619), // لونكِ البني الفخم المعتمد
                ),
              ),

              SizedBox(height: 10),
              Mycard(
                title: "حسابي",
                iconLeading: Icons.account_box_outlined,
                iconTrailling: Icons.arrow_back_ios_new,
              ),

              SizedBox(height: 10),
              Mycard(
                title: "اللغة",
                iconLeading: Icons.language,
                iconTrailling: Icons.arrow_back_ios_new,
              ),

              SizedBox(height: 10),
              Mycard(
                title: "الإعدادات",
                iconLeading: Icons.settings,
                iconTrailling: Icons.arrow_back_ios_new,
              ),

              SizedBox(height: 10),
              Mycard(
                title: "الإشعارات",
                iconLeading: Icons.notification_add_outlined,
                iconTrailling: Icons.arrow_back_ios_new,
              ),

              SizedBox(height: 10),
              Mycard(
                title: "تسجيل الخروج",
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
