import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:library_project/firestore/booksinfo.dart';
import 'package:library_project/mywidgets/myiconbutton.dart';
import 'package:library_project/mywidgets/mymaterialbutton.dart';
import 'package:library_project/mywidgets/mytextformfield.dart';
import 'package:library_project/variables.dart';

class Addbook extends StatefulWidget {
  const Addbook({super.key});

  @override
  State<Addbook> createState() => _AddbookState();
}

class _AddbookState extends State<Addbook> {
  final DatabaseBooksInfo databaseBooksInfo = DatabaseBooksInfo();
  bool isLoading = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  PlatformFile? selectedFile;
  File? mySelectedImage;
  String saveBookTitle = "";
  String saveAuthorName = "";
  final TextEditingController bookName = TextEditingController();
  final TextEditingController authorName = TextEditingController();
  String? pdfFileName; // لحفظ اسم الملف وعرضه للمستخدم
  String? uploadedPdfUrl;
  // لحفظ الرابط النهائي المرفوع من كلودينري
  String? uploadedImageUrl;

  //  var cloudinaryUrl = Uri.parse("https://api.cloudinary.com/v1-1/hlxdoemh/auto/upload");

  Future<void> pickPdfFile() async {
    try {
      PlatformFile? file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (file == null) return; // إذا ألغى المستخدم العملية

      setState(() {
        selectedFile = file; // حفظ الملف في المتغير العام
        pdfFileName = file.name; // عرض الاسم فوراً للمستخدم على الشاشة
      });

      print("تم اختيار المستند بنجاح: ${file.name}");
    } catch (e) {
      print("حدث خطأ أثناء اختيار الملف: $e");
    }
  }

  Future<void> uploadSelectedPdf() async {
    // نتحقق أولاً أن المستخدم اختار ملفاً بالفعل قبل بدء الرفع
    if (selectedFile == null || selectedFile!.path == null) {
      print("⚠️ الرجاء اختيار ملف أولاً قبل الضغط على الرفع!");
      return;
    }

    try {
      setState(() {
        isLoading = true; // تشغيل مؤشر التحميل عند بدء الرفع الفعلي
      });

      // استخدام الحزمة المضمونة والذكية التي نجحت معكِ
      final cloudinary = CloudinaryPublic(
        'hlxdoemh',
        'marwa_preset',
        cache: false,
      );

      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          selectedFile!.path!,
          resourceType:
              CloudinaryResourceType.Raw, // مخصص للملفات الخام كالـ PDF
        ),
      );

      setState(() {
        uploadedPdfUrl = response.secureUrl; // استقبال الرابط السحابي
        isLoading = false; // إيقاف مؤشر التحميل بعد النجاح
      });

      print("🚀 تم الرفع بنجاح باهر! الرابط هو: $uploadedPdfUrl");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("❌ حدث خطأ أثناء عملية الرفع السحابي: $e");
    }
  }

  Future<void> uploadImageToCloudStorage(File imageFile) async {
    try {
      String cloudName = "hlxdoemh";
      String uploadPreset = "marwa_preset";

      var uri = Uri.parse(
        "https://api.cloudinary.com/v1_1/hlxdoemh/image/upload",
      );
      var request = http.MultipartRequest("POST", uri);

      request.fields['upload_preset'] = uploadPreset;
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      print("⏳ جاري إرسال الصورة إلى سيرفر Cloudinary السحابي...");
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        // ⭐ التعديل هنا: حفظ الرابط مباشرة داخل المتغير العام عبر setState
        setState(() {
          uploadedImageUrl = jsonResponse['secure_url'];
        });

        print("تم رفع الصورة وحفظها سحابياً بنجاح باهر! 🎉🚀");
        print("🔗 رابط صورتك المباشر هو: $uploadedImageUrl");
      } else {
        print("فشل الرفع، رمز خطأ السيرفر: ${response.statusCode}");
      }
    } catch (e) {
      print("حدث خطأ غير متوقع أثناء الرفع: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFE8DE),
      appBar: AppBar(
        backgroundColor: Color(0xFFEFE8DE),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "إضافة كتاب",
          style: TextStyle(
            color: Color(0xFF462619),
            fontSize: 35,
            fontWeight: FontWeight(900),
            fontFamily: "tharwat-emara-ruqaa"
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,color: Color(0xFF462619),
            ), // السهم المودرن المتجه لليمين
            onPressed: () {
              Navigator.pop(context); // العودة للخلف
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          Form(
            key: formState,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child: ListView(
                  children: [
                    SizedBox(height: 20),

                    Text(
                      "أضف كتاباً جديداً لمكتبتك الخاصة: ",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight(900),
                        color: Color(0xFF462619),
                      ),
                    ),

                    SizedBox(height: 15),

                    mySelectedImage == null
                        ? Container(
                            width: 300,
                            height: 200,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF462619).withOpacity(
                                    0.6,
                                  ), // لون الظل ودرجة شفافيته (يفضل أن يكون خفيفاً)
                                  spreadRadius:
                                      2, // مدى انتشار وتوسع الظل حول الكونتينر
                                  blurRadius:
                                      10, // درجة نعومة وتغبيش الظل (كلما زاد، أصبح الظل أنعم وأكثر واقعية)
                                  offset: const Offset(
                                    0,
                                    4,
                                  ), // مكان تموضع الظل (X: لليمين/اليسار , Y: للأعلى/الأسفل) هنا مائل للأسفل قريلاً
                                ),
                              ],
                            ),
                            child: DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                dashPattern: [8, 5],
                                strokeWidth: 2,
                                radius: Radius.circular(16),
                                color: Color(0xFF462619),
                                padding: EdgeInsets.all(16),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Myiconbutton(
                                      onPressed: () async {
                                        final picker = ImagePicker();
                                        final XFile? imagePickerResult =
                                            await picker.pickImage(
                                              source: ImageSource.gallery,
                                              imageQuality: 80,
                                              maxWidth: 1200,
                                            );

                                        if (imagePickerResult != null) {
                                          setState(() {
                                            mySelectedImage = File(
                                              imagePickerResult.path,
                                            );
                                          });
                                        }
                                      },
                                      icon: Icons.add_photo_alternate_outlined,
                                    ),
                                    SizedBox(height: 10),

                                    Text(
                                      "ارفع صورة غلاف الكتاب",
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Color(0xFF462619),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Container(
                              width: 150,
                              height: 220,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors
                                    .white, // إضافة لون خلفية أبيض يحمي ظهور الظل بشكل ناصع
                                // 1. إضافة الظل الفخم المتناسق مع بقية واجهات تطبيقكِ
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF462619,
                                    ).withOpacity(0.9), // ظل بني خفيف ناعم
                                    blurRadius: 10,
                                    offset: const Offset(
                                      0,
                                      5,
                                    ), // دفع الظل للأسفل ليعطي عمقاً (3D)
                                  ),
                                ],
                              ),
                              // 2. السطر السحري لإجبار الصورة على الانقصاص داخل الحواف الدائرية للكونتينر
                              clipBehavior: Clip.antiAlias,

                              child: Image.file(
                                mySelectedImage!,
                                // 3. تغيير fit إلى BoxFit.cover مهم جداً هنا لكي تملأ الصورة الغلاف بالكامل بدون فراغات مشوهة
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                    SizedBox(height: 20),

                    selectedFile == null
                        ? InkWell(
                            onTap: () async {
                              await pickPdfFile();
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: 300,
                              height: 65,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF462619).withOpacity(
                                      0.6,
                                    ), // لون الظل ودرجة شفافيته (يفضل أن يكون خفيفاً)
                                    spreadRadius:
                                        2, // مدى انتشار وتوسع الظل حول الكونتينر
                                    blurRadius:
                                        10, // درجة نعومة وتغبيش الظل (كلما زاد، أصبح الظل أنعم وأكثر واقعية)
                                    offset: const Offset(
                                      0,
                                      4,
                                    ), // مكان تموضع الظل (X: لليمين/اليسار , Y: للأعلى/الأسفل) هنا مائل للأسفل قريلاً
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      // ظظظظظظ
                                      "اختار ملف لرفعه",
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Color(0xFF462619),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.attach_file_rounded,
                                      color: Color(0xFF462619),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(10),
                            width: 300,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(25),
                               boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF462619).withOpacity(
                                      0.6,
                                    ), // لون الظل ودرجة شفافيته (يفضل أن يكون خفيفاً)
                                    spreadRadius:
                                        2, // مدى انتشار وتوسع الظل حول الكونتينر
                                    blurRadius:
                                        10, // درجة نعومة وتغبيش الظل (كلما زاد، أصبح الظل أنعم وأكثر واقعية)
                                    offset: const Offset(
                                      0,
                                      4,
                                    ), // مكان تموضع الظل (X: لليمين/اليسار , Y: للأعلى/الأسفل) هنا مائل للأسفل قريلاً
                                  ),
                                ],
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.red,
                                size: 30,
                              ), // أيقونة المستند
                              title: Text(
                                selectedFile!.name,
                              ), // اسم المستند تلقائياً
                              trailing: const Icon(
                                Icons.verified,
                                color: Colors.green,
                                size: 30,
                              ), // علامة الحفظ
                            ),
                          ),

                    SizedBox(height: 20),

                    Mytextformfield(
                      hintText: "اسم الكتاب",
                      mycontroller: bookName,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      hintTextDirection: TextDirection.rtl,

                      onChanged: (value) {
                        setState(() {
                          saveBookTitle = value;
                        });
                      },

                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Please enter title";
                        return null;
                      },
                    ),

                    SizedBox(height: 20),

                    Mytextformfield(
                      hintText: "اسم المؤلف",
                      mycontroller: authorName,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      hintTextDirection: TextDirection.rtl,

                      onChanged: (value) {
                        setState(() {
                          saveAuthorName = value;
                        });
                      },

                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Please enter auther name";
                        return null;
                      },
                    ),

                    SizedBox(height: 40),
                    Mymaterialbutton(
                      onPressed: () async {
                        try {
                          // 1. التحقق الفوري داخل الشاشة (آمن ومستحيل يكون null هنا)
                          if (formState.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });

                            // 2. رفع الملفات السحابية
                            await Future.wait([
                              uploadSelectedPdf(),
                              if (mySelectedImage != null)
                                uploadImageToCloudStorage(mySelectedImage!),
                            ]);

                            // 3. التأكد من توفر رابط الـ PDF الأساسي
                            if (uploadedPdfUrl != null) {
                              // 👈 أسطر الفحص والطباعة هنا بالضبط بدون تغيير أي كود آخر:
                              print(
                                "=================== فحص القيم قبل الحفظ ===================",
                              );
                              print("Book Title Controller: ${bookName.text}");
                              print(
                                "Author Name Controller: ${authorName.text}",
                              );
                              print("Uploaded PDF Url: $uploadedPdfUrl");
                              print("Uploaded Image Url: $uploadedImageUrl");
                              print(
                                "Current User Auth ID: ${FirebaseAuth.instance.currentUser?.uid}",
                              );
                              print(
                                "==========================================================",
                              );

                              // 4. استدعاء الدالة النظيفة بدون تمرير فورم ستايت
                              await databaseBooksInfo.AddBooksDelails(
                                bookTitle: bookName.text,
                                authorName: authorName.text,
                                pdfUrl: uploadedPdfUrl!,
                                imageUrl:
                                    uploadedImageUrl ??
                                    "https://placeholder.com",
                              );

                              setState(() {
                                numBooks = numBooks + 1;
                              });

                              Navigator.pop(context);
                            }
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          print("حدث خطأ غير متوقع: $e");
                        }
                      },
                      title: "إضافة إلى المكتبة",
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (isLoading == true)
            Container(
              color: Colors.black.withOpacity(
                0.3,
              ), // خلفية شفافة تمنع المستخدم من لمس أي زر أثناء الرفع
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF462619), // لون الدائرة المتناسق مع تطبيقكِ
                ),
              ),
            ),
        ],
      ),
    );
  }
}
