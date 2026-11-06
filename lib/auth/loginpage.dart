import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:library_project/mywidgets/mymaterialbutton.dart';
import 'package:library_project/mywidgets/mytextformfield.dart';
import 'package:library_project/pages/mainpage.dart';

class Loginpage extends StatefulWidget {
  Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isLoading = false;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    await GoogleSignIn.instance.initialize(
      serverClientId:
          "258532368812-uq754luioub52bpih217qig1lj83lbam.apps.googleusercontent.com",
    );
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();

      if (googleUser == null) {
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Homepage()));
    } catch (error) {
      print('===============Done sign out=============');
      print('خطأ التشغيل الفعلي هو: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: formState,
        child: isLoading == true
            ? Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.zero,
                children: [
                  // SizedBox(height:7),
                  Text(
                    "أدخل بريدك الإلكتروني:",
                    style: TextStyle(color: Color(0xFF4E342E),
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),

                  Mytextformfield(
                    hintText: "البريد الإلكتروني",
                    textDirection: TextDirection.rtl,
                    mycontroller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الرجاء إدخال البرد الإلكتروني، لا يمكن تركه فارغا";
                      }
                    },
                  ),

                  SizedBox(height: 10),

                  Text(
                    "أدخل كلمة المرور:",
                    style: TextStyle(color: Color(0xFF4E342E),
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),

                  Mytextformfield(
                    hintText: "كلمة المرور",
                    mycontroller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الرجاء إدخال كلمة المرور، لا يمكن تركها فارغة";
                      }
                    },
                  ),

                  InkWell(
                    onTap: () {},
                    child: Text(
                      "هل نسيت كلمة المرور؟",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4E342E),
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),

                  SizedBox(height: 10),

                  Mymaterialbutton(
                    title: "تسجيل دخول",
                    onPressed: () async {
                      if (formState.currentState!.validate()) {
                        try {
                          isLoading = true;
                          setState(() {});
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text,
                              );
                          isLoading = false;
                          setState(() {});
                          if (credential.user!.emailVerified) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => Mainpage()),
                              ),
                            );
                          } else {
                            await FirebaseAuth.instance.currentUser!
                                .sendEmailVerification();

                            AwesomeDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'Please check your email',
                            ).show();
                          }
                        } on FirebaseAuthException catch (e) {
                          isLoading = false;
                          setState(() {});
                          if (e.code == 'user-not-found') {
                            AwesomeDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'No user found for that email.',
                            ).show();
                            print('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            AwesomeDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'Wrong password provided for that user.',
                            ).show();
                            print('Wrong password provided for that user.');
                          }
                        }
                      }
                    },
                  ),

                  SizedBox(height: 6),

                  Center(
                    child: Text(
                      "أو تسجيل الدخول باستخدام:",
                      style: TextStyle(color: Color(0xFF4E342E)),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),

                  SizedBox(height: 10),

                  Mymaterialbutton(
                    title: "غوغل",
                    onPressed: () async {
                      await signInWithGoogle();
                      if (FirebaseAuth.instance.currentUser != null) {
                        isLoading = false;
                        setState(() {});
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Mainpage()),
                        );
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }
}




// هاد web client ID مشان استخدمو ل تسجيل الدخول عن طريق غوغل
// 258532368812-uq754luioub52bpih217qig1lj83lbam.apps.googleusercontent.com


  // Future signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   await GoogleSignIn.instance.initialize(
  //     serverClientId:
  //         "573818747152-gdu6fku19i7uku05b1vv6idsmgajlcu6.apps.googleusercontent.com",
  //   );
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
  //         .authenticate();

  //     if (googleUser == null) {
  //       return;
  //     }

  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser!.authentication;

  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       idToken: googleAuth.idToken,
  //     );

  //     // Once signed in, return the UserCredential
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: ((context) => Homepage())),
  //     );
  //   } catch (error) {
  //     print('Done sign out');
  //   }
  // }