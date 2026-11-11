import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:library_project/auth/welcomepage.dart';
import 'package:library_project/pages/mainpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print(
          '================= 👤 المستخدم الحالي: مسجّل خروجه (Null) =================',
        );
      } else {
        print(
          '================= 🔓 المستخدم الحالي: مسجّل دخوله بنجاح! ID: ${user.uid} =================',
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "tharwat-emara-ruqaa"
      ),

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 1. إذا كان الفايربيس لسا عم يتصل بالإنترنت، نTransition شاشة تحميل بيضاء دائرية
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // 2. إذا وجد يوزر مسجل دخول ومؤكد الإيميل، يثبته بصفحة الرئيسية فوراً
          if (snapshot.hasData ) {
            return const Mainpage();
          }

          // 3. إذا لم يجد يوزر (أو سجل خروجه)، يفتحه على صفحة الترحيب
          return const Welcomepage();
        },
      ),

      // (FirebaseAuth.instance.currentUser != null &&
      //     FirebaseAuth.instance.currentUser!.emailVerified)
      // ? const Mainpage() // الشاشة الرئيسية للكتب
      // : const Welcomepage(), // شاشة الدخول وإنشاء الحساب
    );
  }
}
