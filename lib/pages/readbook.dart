import 'dart:async';
import 'package:flutter/material.dart';
import 'package:library_project/firestore/booksinfo.dart';
import 'package:library_project/mywidgets/mymaterialbutton.dart';
import 'package:library_project/pages/pdfViewScreen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';

class Readbook extends StatefulWidget {
  final String title;
  final String author;
  final String imageUrl;
  final String pdfUrl;
  final String bookDocId; // معرف مستند الكتاب في الفايرستور
  final String
  currentStatus; // الحالة الحالية المخزنة بالفايرستور (none, reading, completed)

  const Readbook({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.pdfUrl,
    required this.bookDocId,
    required this.currentStatus,
  });

  @override
  State<Readbook> createState() => _ReadbookState();
}

class _ReadbookState extends State<Readbook> {
  final DatabaseBooksInfo _dbInfo = DatabaseBooksInfo();
  Set<String> _selectedBookStatus = {'none'};

  int secondsPassed = 0;
  bool isTimerRunning = false;
  Timer? readingTimer;

  @override
  void initState() {
    _selectedBookStatus = {widget.currentStatus};
    super.initState();
  }

  void startOrStopTimer() {
    // إذا كان المؤقت يعمل، نقوم بإيقافه
    if (isTimerRunning) {
      readingTimer?.cancel(); // إيقاف المحرك الخلفي للساعة
      setState(() {
        isTimerRunning = false;
      });
    }
    // إذا كان المؤقت متوقفاً، نقوم بتشغيله
    else {
      setState(() {
        isTimerRunning = true;
      });

      // تشغيل دالة دورية تتكرر كل ثانية واحدة بالضبط
      readingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          secondsPassed++; // زيادة العداد ثانية واحدة وتحديث الشاشة فوراً
        });
      });
    }
  }

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60; // حساب الدقائق
    int seconds = totalSeconds % 60; // حساب الثواني المتبقية

    // دمجهم بشكل نصي مع إضافة صفر على اليسار إذا كان الرقم أقل من 10
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

  void showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        double myRating = 3.0; // رقم افتراضي للنجوم قبل أن يغيره اليوزر

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Color(0xFFEFE8DE),
              title: const Text(
                "ما هو تقييمك للكتاب؟",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF462619)),
              ),
              content: RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 28.0,
                itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 226, 174, 19),
                ),
                onRatingUpdate: (rating) {
                  setDialogState(() {
                    myRating = rating; // لتغيير إضاءة النجوم فوراً عند اللمس
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await _dbInfo.completeBookWithRating(
                      bookDocId:
                          widget.bookDocId, // أو متغير الآيدي المتوفر بصفحتك
                      bookRating: myRating,
                    );

                    Navigator.pop(context);
                  },
                  child: Text(
                    "حفظ التقييم",
                    style: TextStyle(color: Color(0xFF462619)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
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
          "قراءة الكتاب",
          style: TextStyle(
            color: Color(0xFF462619),
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF462619),
            ), // السهم المودرن المتجه لليمين
            onPressed: () {
              Navigator.pop(context); // العودة للخلف
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          child: Column(
            children: [
              // SizedBox(height: 10),
              Center(
                child: Container(
                  width: 250,
                  height: 340,
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
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    widget.imageUrl,
                    height: 330,
                    width: 250, // ارتفاع أنيق ومكبر للغلاف بصفحة التفاصيل
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: 15),

              Text(
                widget.title, // ⭐ قراءة اسم الكتاب الممرر
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight(900),
                  color: Color(0xFF462619),
                ),
              ),

              // SizedBox(height: 10),
              Text(
                widget.author,
                style: TextStyle(fontSize:20, color: Colors.grey[600]),
              ),

              // SizedBox(height: 10),

              SegmentedButton<String>(
                segments: const [
                  ButtonSegment<String>(
                    value: 'none',
                    label: Text(
                      'لم يبدأ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(Icons.bookmark_border, size: 18),
                  ),
                  ButtonSegment<String>(
                    value: 'reading',
                    label: Text(
                      'قيد القراءة',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(Icons.menu_book, size: 18),
                  ),

                  ButtonSegment<String>(
                    value: 'completed',
                    label: Text(
                      'تم القراءة',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(Icons.check_circle_outline, size: 18),
                  ),
                ],

                // الخيار النشط حالياً
                selected: _selectedBookStatus,

                // عند تبديل المستخدم بين الخانات الثلاث
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _selectedBookStatus = newSelection;
                  });

                  if (newSelection.contains('completed')) {
                    showRatingDialog();
                  }

                  // تحديث الفايرستور بالحالة الجديدة فوراً والدقائق المضافة 0 لأننا نغير الحالة فقط
                  DatabaseBooksInfo().updateBookProgress(
                    bookDocId: widget
                        .bookDocId, // 👈 تأكدي من تمرير معرف مستند الكتاب لهذه الشاشة
                    newStatus: newSelection.first,
                    newMinutes: 0.0,
                  );
                },

                // التنسيق والألوان البنية الأنيقة
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: const Color(
                    0xff462619,
                  ), // اللون البني عند التحديد
                  selectedForegroundColor:
                      Colors.white, // لون النص والأيقونة عند التحديد
                  backgroundColor:
                      Colors.white, // لون الخلفية للخيار غير المحدد
                  foregroundColor: const Color(
                    0xff462619,
                  ), // لون النص غير المحدد
                  side: const BorderSide(
                    color: Color(0xff462619),
                    width: 1.2,
                  ), // الإطار
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                ),
              ),

              SizedBox(height: 20),
              Mymaterialbutton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Pdfviewscreen(
                        pdfUrl: widget.pdfUrl,
                        bookTitle: widget.title,
                        secondsPassed: secondsPassed,
                        isTimerRunning: isTimerRunning,
                        startOrStopTimer: startOrStopTimer,
                      ),
                    ),
                  ).then((dynamic updatedSeconds) {
                    if (updatedSeconds != null && updatedSeconds is int) {
                      setState(() {
                        secondsPassed = updatedSeconds;
                        isTimerRunning = false;

                        // 1. تحويل الثواني الفعلية إلى دقائق (هنا داخل الـ setState بأمان)
                        double minutesRead = updatedSeconds / 60.0;

                        // 2. تحديث الدقائق الكلية التراكمية في الفايرستور فوراً
                        DatabaseBooksInfo().updateBookProgress(
                          bookDocId: widget.bookDocId,
                          newStatus: _selectedBookStatus.first,
                          newMinutes: minutesRead,
                        );
                      });
                    }
                  });
                },
                title: "إبدأ القراءة",
                
              ),

              SizedBox(height: 10),

              secondsPassed > 0
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF462619,
                          ).withOpacity(0.06), // خلفية بنية ناعمة جداً وخفيفة
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              color: Color(0xFF462619),
                              size: 17,
                            ), // أيقونة الوقت
                            const SizedBox(width: 8),
                            Text(
                              "لقد قضيت ${secondsPassed ~/ 60} دقيقة و ${secondsPassed % 60} ثانية بالقراءة",
                              style: const TextStyle(
                                color: Color(0xFF462619),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
