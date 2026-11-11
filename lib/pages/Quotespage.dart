import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_project/firestore/quotes.dart';
import 'package:library_project/pages/subQuotepage.dart';

class Quotespage extends StatefulWidget {
  const Quotespage({super.key});

  @override
  State<Quotespage> createState() => _QuotespageState();
}

class _QuotespageState extends State<Quotespage> {
  final DatabaseQuotes _databaseQuotes = DatabaseQuotes();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFE8DE),

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.centerRight,

                    child: Text(
                      "مجلدات الاقتباسات:",
                      style: TextStyle(fontSize: 25, color: Color(0xFF462619)),
                      textDirection: TextDirection.rtl,
                    ),
                  ),

                  SizedBox(height: 15),

                  StreamBuilder<QuerySnapshot>(
                    stream: _databaseQuotes.getCatetoryQuotesStream(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("حدث خطأ أثناء تحميل المجلدات ❌"),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFEFE8DE),
                          ),
                        );
                      }

                      var docs = snapshot.data?.docs ?? [];

                      return GridView.builder(
                        shrinkWrap:
                            true, // 👈 إجبار الـ GridView على أخذ مساحة عناصره فقط
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: 80,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 7,
                        ),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          Color cardColor = index % 2 == 0
                              ? const Color(0xFFEED9C6)
                              : const Color(0xFF462619);

                          Color textColor = index % 2 == 0
                              ? const Color(
                                  0xFF462619,
                                ) // 🎨 النص فوق الكارت البيج: بني غامق ليظهر بوضوح
                              : const Color(0xFFEFE8DE);
                          return InkWell(
                            onLongPress: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                dialogBackgroundColor: Color(0xFFEFE8DE),

                                animType: AnimType.rightSlide,
                                title: 'تاكيد الحذف',
                                desc: 'هل أنت متأكد من حذف هذا المجلد؟',
                                btnCancelColor: Color.fromARGB(255, 238, 217, 198),
                                btnOkColor: Color(0xFF462619),
                                btnOkText: "حذف",
                                btnCancelText: "إلغاء",
                                btnCancelOnPress: () {},
                                btnOkOnPress: () async {
                                  _databaseQuotes.deleteCategoryQuoutes(
                                    docId: docs[index].id,
                                  );
                                },
                              ).show();
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Subquotepage(
                                    folderId: docs[index].id,
                                    folderName:
                                        docs[index]['categoryQuoteTitle'], // 👈 إرسال آيدي المجلد تلقائياً للصفحة الثانية
                                  ),
                                ),
                              );
                            },

                            child: Card(
                              color: cardColor,
                              elevation: 5.0,
                              shadowColor: const Color(
                                0xFF462619,
                              ).withOpacity(0.6),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        textDirection: TextDirection.rtl,
                                        "${docs[index]['categoryQuoteTitle']}",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 20),

                                    Text(
                                      docs[index]['created_at'] != null
                                          ? "${(docs[index]['created_at'] as Timestamp).toDate().year}-${(docs[index]['created_at'] as Timestamp).toDate().month}-${(docs[index]['created_at'] as Timestamp).toDate().day}"
                                          : "جاري التحميل...",
                                      // حماية في حال كان السيرفر يحسب الوقت حالياً
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom:
                5, // المسافة الارتفاعية للزر فوق شريط القائمة السفلية المشترك
            left: 0,
            right:
                0, // تصفير اليمين واليسار مع الـ Center يضمن السنتر الأفقي التام
            child: Center(
              child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      // معرّف حقل الإدخال لاسم المجلد
                      final TextEditingController folderController =
                          TextEditingController();

                      return AlertDialog(
                        backgroundColor: const Color(
                          0xFFEFE8DE,
                        ), // لون الخلفية البيج الدافئ لتطبيقكِ
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            15,
                          ), // الحواف المدورة الأنيقة
                        ),
                        title: const Text(
                          "إضافة مجلد جديد 📁",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF462619), // اللون البني المعتمد
                          ),
                        ),
                        content: TextField(
                          controller: folderController,
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            // hintText: "مثال: روايات، تطوير ذات...",
                            hintTextDirection: TextDirection.rtl,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFF462619),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        actions: [
                          // زر إلغاء
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "إلغاء",
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                          // زر حفظ البني
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF462619,
                              ), // الزر باللون البني الفخم
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              if (folderController.text.trim().isNotEmpty) {
                                // استدعاء دالتكِ الصحيحة لحفظ اسم المجلد فقط في الفايرستور!
                                await _databaseQuotes.addCategoryQuotes(
                                  categoryName: folderController.text.trim(),
                                );
                                Navigator.pop(
                                  context,
                                ); // إغلاق الصندوق بعد الحفظ
                              }
                            },
                            child: const Text(
                              "حفظ",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                backgroundColor: const Color(0xFF462619),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
