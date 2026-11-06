import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_project/mywidgets/mymaterialbutton.dart';
import 'package:library_project/mywidgets/mytextformfield.dart';
import 'package:library_project/pages/mainpage.dart';

class Signuppage extends StatefulWidget {
  Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final TextEditingController userNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isLoading = false;

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
                    "أدخل اسم المستخدم",
                    style: TextStyle(color: Color(0xFF4E342E),
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),

                  Mytextformfield(
                    hintText: "اسم المستخدم",
                    mycontroller: userNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الرجاء إدخال الاسم، لا يمكن تركه فارغاً";
                      }
                    },
                  ),

                  SizedBox(height: 10),

                  Text(
                    "أدخل البريد الإلكتروني:",
                    style: TextStyle(color: Color(0xFF4E342E),
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),

                  Mytextformfield(
                    hintText: "البريد الإلكتروني",
                    mycontroller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الرجاء إدخال البريد الإلكتروني، لا يمكن تركه فارغاً";
                      }
                    },
                  ),

                  SizedBox(height: 10),

                  Text(
                    "أدخل كلمة المرور",
                    style: TextStyle(color: Color(0xFF4E342E),
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),

                  Mytextformfield(
                    hintText: "كلمة المرور",
                    mycontroller: passwordController,
                    textAlign:TextAlign.right,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الرجاء إدخال كلمة المرور، لا يمكن تركها فارغة";
                      }
                    },
                  ),

                  SizedBox(height: 15),
                  Mymaterialbutton(
                    title: "إنشاء حساب",
                    onPressed: () async {
                      if (formState.currentState!.validate()) {
                        try {
                          // 1. تشغيل مؤشر التحميل وتحديث الواجهة فوراً
                          setState(() {
                            isLoading = true;
                          });

                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );

                          // 2. إيقاف التحميل وتحديث الواجهة بعد النجاح
                          setState(() {
                            isLoading = false;
                          });

                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Mainpage(),
                              ),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          // 3. إيقاف التحميل فوراً في حال حدوث خطأ من الفايربيس لتستجيب الشاشة
                          setState(() {
                            isLoading = false;
                          });

                          if (e.code == 'weak-password') {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: "Warning",
                              desc:
                                  "The password is too weak! please try again",
                              btnOkOnPress: () {},
                              btnCancelOnPress: () {},
                            ).show();
                            print(
                              '===============The password provided is too weak.=========',
                            );
                          } else if (e.code == 'email-already-in-use') {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: "Warning",
                              desc: "The account already exists for that email",
                              btnOkOnPress: () {},
                              btnCancelOnPress: () {},
                            ).show();
                            print(
                              '===============The account already exists for that email.==============',
                            );
                          }
                        } catch (e) {
                          // 4. إيقاف التحميل في حال حدوث أي خطأ آخر عام
                          setState(() {
                            isLoading = false;
                          });
                          print(e);
                        }
                      }
                    },
                  ),

                  SizedBox(height: 6),
                ],
              ),
      ),
    );
  }
}
