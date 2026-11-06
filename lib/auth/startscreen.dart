import 'package:flutter/material.dart';
import 'package:library_project/auth/loginpage.dart';
import 'package:library_project/auth/signuppage.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFEFE8DE),
        body: Column(
          children: [
            SizedBox(height: 40),

            Text(
              "مكتبتي",
              style: TextStyle(
                color: Color(0xFF4E342E),
                fontWeight: FontWeight.bold,
                fontSize: 33,
              ),
            ),

            Expanded(
              flex: 5, // مساحة من اعلى الصورة
              child: Stack(
                children: [
                  // تأثير التمويه والتلاشي للصورة
                  ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        // التدرج يبدأ بلون كامل وينتهي بشفاف تماماً ليحدث التلاشي
                        colors: [Colors.brown, Colors.transparent],
                        stops: [0.6, 1.0], // يبدأ التلاشي بعد 60% من طول الصورة
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstIn, // نوع الدمج لإخفاء أسفل الصورة
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25), // انحناء من أعلى اليسار
                        topRight: Radius.circular(25), // انحناء من أعلى اليمين
                      ),
                      child: Image.asset(
                        "images/mainpic.jpg",
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const Positioned(top: 60, left: 0, right: 0, child: Center()),
                ],
              ),
            ),

            // 2. النصف السفلي: مساحة فارغة ومريحة جداً تسع كل حقول الإدخال والـ TabBar
            Expanded(
              flex: 7, // مساحة أكبر في الأسفل للحقول والأزرار دون انضغاط
              child: Container(
                width: double.infinity,
                color: Colors.transparent, // شفافة لتظهر لون الخلفية الأساسي
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Color(0xFF4E342E),
                      unselectedLabelColor: const Color.fromARGB(
                        255,
                        153,
                        150,
                        150,
                      ),
                      indicatorColor: Color(0xFF4E342E),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 17,
                      ),

                      tabs: [
                        Tab(text: "تسجيل الدخول"),
                        Tab(text: "إنشاء حساب"),
                      ],
                    ),

                    // محتوى التبويبات (هنا ستضع حقول الإدخال لاحقاً)
                    Expanded(
                      child: TabBarView(children: [Loginpage(), Signuppage()]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//  Image.asset("images/lib.png"