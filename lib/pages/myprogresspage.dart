import 'package:flutter/material.dart';
import 'package:library_project/firestore/booksinfo.dart';

class Myprogresspage extends StatefulWidget {
  const Myprogresspage({super.key});

  @override
  State<Myprogresspage> createState() => _MyprogresspageState();
}

class _MyprogresspageState extends State<Myprogresspage> {
  final DatabaseBooksInfo _dbInfo = DatabaseBooksInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFE8DE),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            StreamBuilder(
              stream: _dbInfo.getBooksStream(), // استدعاء الستريم
              builder: (context, snapshot) {
                final docs = snapshot.data?.docs ?? [];

                // حساب عدد الكتب التي قيد القراءة حالياً (تأكدي من الكلمة المعتمدة عندكِ مثل 'none' أو 'reading')
                final currentReadingCount = docs
                    .where((doc) => doc['status'] == 'reading')
                    .length;

                return Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "كتب أقرأها حالياً: ($currentReadingCount)", // عرض العدد هنا تلقائياً
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight(900),
                      color: Color(0xFF462619),
                    ),
                  ),
                );
              },
            ),

            // SizedBox(height: 10),
            Container(
              height: 240,
              child: StreamBuilder(
                stream: _dbInfo.getBooksStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF462619),
                      ),
                    );
                  }

                  final docs = snapshot.data?.docs ?? [];
                  final readingDocs = docs
                      .where((doc) => doc['status'] == 'reading')
                      .toList();

                  if (readingDocs.isEmpty) {
                    return const Center(
                      child: Text("لا توجد كتب قيد القراءة حالياً 📖"),
                    );
                  }

                  // 3. البيلدر العرضي يقرأ الآن من القائمة المفلترة
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        readingDocs.length, // نستخدم طول القائمة المفلترة
                    itemBuilder: (context, index) {
                      double totalMinutes =
                          (readingDocs[index]['total_minutes'] ?? 0.0)
                              as double;
                      int hours =
                          totalMinutes ~/ 60; // حساب الساعات بالقسمة الصحيحة
                      int minutes = (totalMinutes % 60).toInt(); // باقي الدقائق

                      // 2. صياغة النص بذكاء: إذا كان هناك ساعات يكتبها، وإلا يكتفي بالدقائق فقط
                      String timeText = hours > 0
                          ? "$hours ساعة و $minutes دقيقة"
                          : "$minutes دقيقة";
                      // 👈 هنا بداخل الـ itemBuilder هترجعي كرت الكتاب (Card)
                      // المكون من الصورة واسم الكتاب والدقائق بنفس نمط الهوم تماماً
                      // وتستخدمين بداخلها متغير: readingDocs[index] لقرائة البيانات
                      return Container(
                        width: 150,
                        child: Card(
                          color: const Color.fromARGB(255, 238, 217, 198),
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
                                    borderRadius: BorderRadius.circular(10),

                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF462619).withOpacity(
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
                                    readingDocs[index]['image_url'],
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                              ),
                                            ),
                                  ),
                                ),
                                SizedBox(height: 6),

                                Text(
                                  "${readingDocs[index]['title']}",
                                  maxLines: 1, // لمنع خروج النص عن الكارت
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight(900),
                                    fontSize: 19,
                                    color: Color(0xFF462619),
                                  ),
                                ),

                                SizedBox(height: 6),

                                // شريط التقدم المودرن
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ), // حواف مستديرة ونظيفة للشريط
                                  child: LinearProgressIndicator(
                                    // نقوم بحساب النسبة المئوية مباشرة داخل قيمة الـ value (نفترض الهدف 60 دقيقة كمثال)
                                    // دالة clamp تضمن بقاء النسبة بين 0.0 و 1.0 لكي لا يحدث أي خطأ برمي
                                    value:
                                        (((readingDocs[index]['total_minutes'] ??
                                                        0.0)
                                                    as double) /
                                                120.0)
                                            .clamp(0.0, 1.0),
                                    backgroundColor: const Color(0xFF462619)
                                        .withOpacity(
                                          0.15,
                                        ), // لون خلفية الشريط الباهت
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF4E342E),
                                        ), // لون الامتلاء البني الفخم
                                    minHeight: 8, // سُمك الشريط النحيف والمودرن
                                  ),
                                ),

                                SizedBox(height: 4),

                                // 👈 هذا هو السطر البرمجي المحدث ليكون تحت شريط التقدم مباشرة:
                                const SizedBox(height: 6),

                                Center(
                                  child: Container(
                                    alignment: Alignment
                                        .center, // يضمن محاذاة النص العربي من اليمين لليسار بنظافة
                                    child: Text(
                                      "مدة القراءة: $timeText",
                                      textDirection: TextDirection
                                          .rtl, // لمنع خربطة الحروف مع الأرقام تماماً
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF462619),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            StreamBuilder(
              stream: _dbInfo.getBooksStream(), // استدعاء نفس الستريم
              builder: (context, snapshot) {
                // 1. جلب المستندات أو وضع قائمة فارغة إذا لم تكن البيانات جاهزة بعد
                final docs = snapshot.data?.docs ?? [];

                // 2. حساب عدد الكتب التي حالتها مكتملة فقط في هذا السطر
                final completedCount = docs
                    .where((doc) => doc['status'] == 'completed')
                    .length;

                return Container(
                  alignment:
                      Alignment.centerRight, // محاذاة لليمين لتتناسب مع العربي
                  // مسافة جانبية للعنوان
                  child: Text(
                    "كتب أنهيتها بنجاح: ($completedCount)", // عرض الرقم المحسوب تلقائياً هنا
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight(900),
                      color: Color(0xFF462619),
                    ),
                  ),
                );
              },
            ),

            Expanded(
              // width:double.infinity,
              child: StreamBuilder(
                stream: _dbInfo.getBooksStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF462619),
                      ),
                    );
                  }

                  final docs = snapshot.data?.docs ?? [];
                  final doneDocs = docs
                      .where((doc) => doc['status'] == 'completed')
                      .toList();

                  if (doneDocs.isEmpty) {
                    return const Center(
                      child: Text("لا توجد كتب تم قرائتها..."),
                    );
                  }

                  return ListView.builder(
                    itemCount: doneDocs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Color.fromARGB(255, 238, 217, 198),
                          child: Row(
                            textDirection: TextDirection.rtl,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                width: 80,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF462619).withOpacity(
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
                                  doneDocs[index]['image_url'],
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                              ),

                              SizedBox(width: 20),

                              Expanded(
                                child: Column(
                                  textDirection: TextDirection.rtl,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${doneDocs[index]['title']}",
                                      maxLines: 1, // لمنع خروج النص عن الكارت
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight(900),
                                        fontSize: 24,
                                        color: Color(0xFF462619),
                                      ),
                                    ),

                                    // SizedBox(height: 6),
                                    Text(
                                      "${doneDocs[index]['author']}",
                                      maxLines: 1, // لمنع خروج النص عن الكارت
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        // fontWeight: FontWeight(900),
                                        fontSize: 17,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    SizedBox(height: 5),

                                    Text(
                                      () {
                                        // 1. جلب الرقم الكلي للدقائق من السيرفر وتحويله لعدد صحيح
                                        final int totalMinutes =
                                            (docs[index]['total_minutes'] ?? 0)
                                                .toInt();

                                        // 2. حساب الساعات والدقائق المتبقية رياضياً
                                        final int hours =
                                            totalMinutes ~/
                                            60; // القسمة الصحيحة لجلب الساعات
                                        final int minutes =
                                            totalMinutes %
                                            60; // باقي القسمة لجلب الدقائق المتبقية

                                        // 3. طريقة العرض الذكية بناءً على وجود ساعات أو دقائق فقط
                                        if (hours > 0 && minutes > 0) {
                                          return "وقت القراءة: $hours ساعة و $minutes دقيقة";
                                        } else if (hours > 0) {
                                          return "وقت القراءة: $hours ساعة";
                                        } else {
                                          return "وقت القراءة: $minutes دقيقة";
                                        }
                                      }(), // 👈 علامة القوسين هذه إجبارية لتشغيل الدالة الفورية بداخل الـ Text
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(
                                          0xFF462619,
                                        ), // لونكِ البني الفخم المعتمد
                                      ),
                                    ),

                                    SizedBox(height: 6),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: List.generate(5, (starIndex) {
                                        // 1. جلب التقييم من المستند (إذا كان فارغاً نعتبره 0)
                                        final bookRating =
                                            doneDocs[index]['rating'] ?? 0.0;

                                        // 2. إذا كان رقم النجمة الحالية أصغر من تقييم الكتاب تلون بالأصفر، وإلا بالرمادي
                                        return Icon(
                                          Icons.star,
                                          color: starIndex < bookRating
                                              ? Colors.amber
                                              : Colors.grey[400],
                                          size: 18,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: 10),

                              Icon(
                                Icons.verified_rounded,
                                color: Colors
                                    .amber
                                    .shade700, // لون ذهبي دافئ متناسق
                                size: 33,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
