import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_project/firestore/booksinfo.dart';
import 'package:library_project/mywidgets/myiconbutton.dart';
import 'package:library_project/mywidgets/mytextformfield.dart';
import 'package:library_project/pages/addbook.dart';
import 'package:library_project/pages/readbook.dart';
import 'package:library_project/variables.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  final DatabaseBooksInfo _dbInfo = DatabaseBooksInfo();
  String searchQuery = ""; // لحفظ نص البحث
  final TextEditingController searchController =
      TextEditingController(); // للتحكم بالحقل

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFE8DE),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // SizedBox(height: 15),
                    Mytextformfield(
                      hintText: "ابحث عن كتابك",
                      showShadow: false,
                      textDirection: TextDirection.rtl,
                      mycontroller: searchController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "الرجاء إدخال البرد الإلكتروني، لا يمكن تركه فارغا";
                        }
                      },

                      onChanged: (value) {
                        setState(() {
                          searchQuery = value
                              .trim(); // 👈 هذا السطر يمرر الحروف المكتوبة للفلترة بالأسفل
                        });
                      },
                    ),

                    SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF462619).withOpacity(
                              0.6,
                            ), // لون الظل ودرجة شفافيته (يف462619ضل أن يكون خفيفاً)
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
                        image: DecorationImage(
                          image: AssetImage("images/wallpaper.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Text(
                              textDirection: TextDirection.rtl,
                              "عدد الكتب في مكتبتك:  ",
                              style: TextStyle(
                                color: Color(0xFFEFE8DE),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            StreamBuilder<QuerySnapshot>(
                              stream: _dbInfo.getBooksStream(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text(
                                    "...",
                                    style: TextStyle(
                                      color: Color(0xFFEFE8DE),
                                      fontSize: 25,
                                    ),
                                  );
                                }
                                int totalBooks =
                                    snapshot.data?.docs.length ?? 0;

                                return Text(
                                  "$totalBooks", // طبع الرقم الحقيقي هنا بأمان كامل!
                                  style: const TextStyle(
                                    color: Color(0xFFEFE8DE),
                                    fontSize: 33,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Container(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        textDirection: TextDirection.rtl,
                        "الكتب:",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xFF462619),
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 330,
                      // padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        // color: Color(0xFF4E342E),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ListView(
                        children: [
                          StreamBuilder(
                            stream: _dbInfo.getBooksStream(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text("حدث خطأ أثناء تحميل الكتب ❌"),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFEFE8DE),
                                  ),
                                );
                              }

                              var docs = snapshot.data?.docs ?? [];
                              final filteredDocs = docs.where((doc) {
                                final title = doc['title']
                                    .toString()
                                    .toLowerCase();
                                final author = doc['author']
                                    .toString()
                                    .toLowerCase();
                                final search = searchQuery.toLowerCase();

                                return title.contains(search) ||
                                    author.contains(search);
                              }).toList();
                              docs = filteredDocs;

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisExtent: 200,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                itemCount: filteredDocs.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Readbook(
                                            title: docs[index]['title'],
                                            author: docs[index]['author'],
                                            imageUrl: docs[index]['image_url'],
                                            pdfUrl: docs[index]['pdf_url'],
                                            bookDocId: docs[index].id,
                                            currentStatus:
                                                docs[index]['status'] ?? 'none',
                                          ),
                                        ),
                                      );
                                    },
                                    onLongPress: () {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.warning,
                                        dialogBackgroundColor: Color(
                                          0xFFEFE8DE,
                                        ),

                                        animType: AnimType.rightSlide,
                                        title: 'تاكيد الحذف',
                                        desc: 'هل أنت متأكد من حذف هذا الكتاب؟',
                                        btnCancelColor: Color.fromARGB(255, 238, 217, 198),
                                        btnOkColor: Color(0xFF462619),
                                        btnOkText: "حذف",
                                        btnCancelText: "إلغاء",
                                        btnCancelOnPress: () {},
                                        btnOkOnPress: () async {
                                          await FirebaseFirestore.instance
                                              .collection("BooksDetails")
                                              .doc(docs[index].id)
                                              .delete();
                                        },
                                      ).show();
                                    },
                                    child: Card(
                                      color: const Color.fromARGB(
                                        255,
                                        238,
                                        217,
                                        198,
                                      ),
                                      elevation: 8.0,
                                      shadowColor: Color(0xFF462619),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          children: [
                                            Container(
                                              clipBehavior: Clip.antiAlias,
                                              width: 110,
                                              height: 140,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),

                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0xFF462619)
                                                        .withOpacity(
                                                          0.3,
                                                        ), // لون الظل ودرجة شفافيته (يفضل أن يكون خفيفاً)
                                                    spreadRadius:
                                                        1, // مدى انتشار وتوسع الظل حول الكونتينر
                                                    blurRadius:
                                                        15, // درجة نعومة وتغبيش الظل (كلما زاد، أصبح الظل أنعم وأكثر واقعية)
                                                    offset: const Offset(
                                                      0,
                                                      4,
                                                    ), // مكان تموضع الظل (X: لليمين/اليسار , Y: للأعلى/الأسفل) هنا مائل للأسفل قريلاً
                                                  ),
                                                ],
                                              ),
                                              child: Image.network(
                                                docs[index]['image_url'],
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => const Center(
                                                      child: Icon(
                                                        Icons.broken_image,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                              ),
                                            ),

                                            Text(
                                              "${docs[index]['title']}",
                                              maxLines:
                                                  1, // لمنع خروج النص عن الكارت
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight(900),
                                                fontSize: 17,
                                                color: Color(0xFF462619),
                                              ),
                                            ),
                                            Text(
                                              "${docs[index]['author']}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // color: Color(0xFFEFE8DE),
                                      // child: Text("her your books"),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),

                      // ListView(children: [
                      //   Card(child:Text("Her your books"))

                      // ],)
                    ),
                  ],
                ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: ((context) => Addbook())),
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
