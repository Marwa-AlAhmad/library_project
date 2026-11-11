import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:library_project/firestore/quotes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_project/pages/viewQuote.dart';

class Subquotepage extends StatefulWidget {
  final String folderId;
  final String folderName;
  const Subquotepage({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  State<Subquotepage> createState() => _SubquotepageState();
}

class _SubquotepageState extends State<Subquotepage> {
  final DatabaseQuotes _databaseQuotes = DatabaseQuotes();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFE8DE),
      appBar: AppBar(
        backgroundColor: const Color(
          0xFFEFE8DE,
        ), // نفس لون الخلفية الدافئ لتطبيقكِ
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.folderName,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF462619), // اللون البني المعتمد
          ),
        ),
      ),

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
                      "قسم الاقتباسات المفضلة:",
                      style: TextStyle(fontSize: 25, color: Color(0xFF462619)),
                      textDirection: TextDirection.rtl,
                    ),
                  ),

                  SizedBox(height: 15),

                  StreamBuilder<QuerySnapshot>(
                    stream: _databaseQuotes.getQuotesStream(
                      folderId: widget.folderId,
                    ),
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
                          mainAxisSpacing: 12,
                        ),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          Color cardColor = index % 2 == 0
                              ? const Color(0xFFEED9C6)
                              : const Color( 0xFF462619);

                          Color textColor = index % 2 == 0
                              ? const Color( 0xFF462619,) // 🎨 النص فوق الكارت البيج: بني غامق ليظهر بوضوح
                              : const Color(0xFFEFE8DE);
                          return InkWell(
                                onLongPress: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                dialogBackgroundColor: Color(0xFFEFE8DE),

                                animType: AnimType.rightSlide,
                                title: 'تاكيد الحذف',
                                desc: 'هل أنت متأكد من حذف هذا الاقتباس؟',
                                btnCancelColor: Color.fromARGB(255, 238, 217, 198),
                                btnOkColor: Color(0xFF462619),
                                btnOkText: "حذف",
                                btnCancelText: "إلغاء",
                                btnCancelOnPress: () {},
                                btnOkOnPress: () async {
                                  _databaseQuotes.deleteQuoutes(folderId:widget.folderId , quoteId: docs[index].id);
                                },
                              ).show();
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Viewquote(
                                      // 👈 1. أضفنا كلمة return هنا إجبارياً
                                      quoteId: docs[index]
                                          .id, // 💡 نصيحة احترافية: مرري الـ id للمستند وليس آيدي اليوزر
                                      quoteText: docs[index]["text"],
                                    ); // 👈 2. استبدلي الفاصلة المنقوطة بفاصلة عادية , أو اتركيها هكذا بشرط وجود الـ return
                                  },
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
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          textDirection: TextDirection.rtl,
                                          "${docs[index]['text']}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color:textColor,
                                          ),
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
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // يرتفع فوق الكيبورد تلقائياً
                    backgroundColor: const Color(
                      0xFFEFE8DE,
                    ), // لون تطبيقكِ البيج الدافئ
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ), // حواف علوية مدورة
                    ),
                    builder: (context) {
                      // 1. معرّف حقل الإدخال لنص الاقتباس
                      final TextEditingController quoteController =
                          TextEditingController();

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(
                            context,
                          ).viewInsets.bottom, // حماية من الكيبورد
                          left: 20,
                          right: 20,
                          top: 20,
                        ),
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min, // يأخذ مساحة الكلمات فقط
                          children: [
                            const Text(
                              "أضف اقتباساً جديداً لـ هذا المجلد 📜",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF462619),
                              ),
                            ),
                            const SizedBox(height: 15),

                            // 2. حقل كتابة الاقتباس يتسع لـ 4 أسطر
                            TextField(
                              controller: quoteController,
                              textDirection: TextDirection.rtl,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: "اكتب هنا الكلمات التي لامست قلبك...",
                                hintTextDirection: TextDirection.rtl,
                                filled: true,
                                fillColor: const Color(0xFFF5EBE1),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: const Color(
                                      0xFF462619,
                                    ).withOpacity(0.3),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF462619),
                                    width: 1.8,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // 3. زر الحفظ البني الفخم
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF462619),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () async {
                                  if (quoteController.text.trim().isNotEmpty) {
                                    // 👈 4. استدعاء دالة الـ Subcollection وتغذيتها بالآيدي والنص
                                    await _databaseQuotes.addQuotes(
                                      folderId: widget
                                          .folderId, // نمرر آيدي المجلد الحالي عبر widget.
                                      quoteText: quoteController.text
                                          .trim(), // نص الاقتباس الجديد
                                    );

                                    Navigator.pop(
                                      context,
                                    ); // إغلاق الـ BottomSheet بنعومة بعد الحفظ
                                  }
                                },
                                child: const Text(
                                  "حفظ في المجلد",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
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
