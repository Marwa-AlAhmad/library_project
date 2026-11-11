import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Pdfviewscreen extends StatefulWidget {
  final String pdfUrl;
  final String bookTitle;
  final int secondsPassed;
  final bool isTimerRunning;
  final void Function() startOrStopTimer;

  const Pdfviewscreen({
    super.key,
    required this.pdfUrl,
    required this.bookTitle,
    required this.secondsPassed,
    required this.isTimerRunning,
    required this.startOrStopTimer,
  });

  @override
  State<Pdfviewscreen> createState() => _PdfviewscreenState();
}

class _PdfviewscreenState extends State<Pdfviewscreen> {
  // 1. تعريف المتغيرات المحلية داخل شاشة الـ PDF لتتحرك ثانية بثانية
  int localSeconds = 0;
  late bool localIsRunning;
  Timer? localTimer;

  @override
  void initState() {
    super.initState();
    // أخذ القيم الابتدائية القادمة من شاشة التفاصيل عند الفتح
    localSeconds = widget.secondsPassed;
    localIsRunning = widget.isTimerRunning;

    // إذا كان المؤقت قادماً بحالة تشغيل، نشغل المحرك المحلي فوراً
    if (localIsRunning) {
      startLocalTimer();
    }
  }

  // 2. دالة تشغيل العداد المحلي ثانية بثانية
  void startLocalTimer() {
    localTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        localSeconds++; // زيادة العداد وتحديث الشاشة فوراً في نفس اللحظة
      });
    });
  }

  // 3. دالة التحكم بالزر (Play / Pause) من داخل الكتاب
  void toggleLocalTimer() {
    if (localIsRunning) {
      localTimer?.cancel();
      setState(() {
        localIsRunning = false;
      });
    } else {
      setState(() {
        localIsRunning = true;
      });
      startLocalTimer();
    }
  }

  @override
  void dispose() {
    localTimer?.cancel(); // إغلاق المؤقت لحماية الذاكرة عند الخروج
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      
      canPop: false, // 🎯 نمنع الخروج التلقائي الفارغ
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
         return;
        }

        Navigator.pop(context, localSeconds);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.bookTitle,style:TextStyle(color:Color(0xFFEFE8DE),)),
          backgroundColor: const Color(0xFF462619),
          iconTheme: const IconThemeData(color: Color(0xFFEFE8DE)), 
        ),
        body: Stack(
          children: [
            SfPdfViewer.network(widget.pdfUrl),

            // 2. 👈 هنا بالظبط تحت كود الكتاب تضعين كود المؤقت لكي يطفو فوقه:
            Positioned(
              top: 40, // مسافة من الأعلى
              left: 20, // مسافة من اليسار ليظهر في الزاوية
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF462619,
                  ).withOpacity(0.9), // بني شفاف فخم
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // نص الوقت (يقرأ من الكونستركتر عبر widget)
                    Text(
                      "${(localSeconds ~/ 60).toString().padLeft(2, '0')}:${(localSeconds % 60).toString().padLeft(2, '0')}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // الزر الدائري الصغير
                    GestureDetector(
                      onTap: () {
                        toggleLocalTimer(); // استدعاء الدالة الممررة
                        setState(() {}); // تحديث شكل الزر داخل الكتاب فوراً
                      },
                      child: Icon(
                        (localIsRunning
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled),

                        color: Colors.white,
                        size: 22,
                      ),
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
