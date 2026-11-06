import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseBooksInfo {
  CollectionReference booksInfo = FirebaseFirestore.instance.collection(
    "BooksDetails",
  );

  Future<void> AddBooksDelails({
    required String bookTitle,
    required String authorName,
    required String pdfUrl,
    required String imageUrl,
  }) async {
    try {
      DocumentReference details = await booksInfo.add({
        "id": FirebaseAuth.instance.currentUser!.uid,
        "title": bookTitle,
        "author": authorName,
        "pdf_url": pdfUrl,
        "image_url": imageUrl,
        "status": "none",
        "rating": 0.0,
        "total_minutes": 0.0,
        "created_at": FieldValue.serverTimestamp(),
      });
      print("✅ تم حفظ الكتاب بنجاح في الفايربيس! المعرف هو: ${details.id}");
    } catch (e) {
      print("❌ حدث خطأ أثناء الحفظ بداخل الفايربيس: $e");
    }
  }

  Future<List<QueryDocumentSnapshot>> getBooksDetails() async {
    try {
      QuerySnapshot querySnapshot = await booksInfo.get();
      return querySnapshot.docs;
    } catch (e) {
      print("❌ حدث خطأ أثناء جلب البيانات: $e");
      return [];
    }
  }

  Stream<QuerySnapshot> getBooksStream() {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return FirebaseFirestore.instance
        .collection("BooksDetails")
        .where("id", isEqualTo: currentUserId) // 👈 السطر الجديد والمهم للفلترة
        .snapshots();
  }


  Future<void> updateBookProgress({
  required String bookDocId,     // معرف المستند للكتاب
  required String newStatus,     // الحالة المحددة الجديدة
  required double newMinutes,    // الدقائق المضافة من جلسة القراءة الأخيرة
}) async {
  try {
    await booksInfo.doc(bookDocId).update({
      "status": newStatus,
      "total_minutes": FieldValue.increment(newMinutes), // 👈 يزيد الدقائق تراكمياً بالفايربيز تلقائياً
    });
    print("✅ تم تحديث حالة ووقت الكتاب بنجاح!");
  } catch (e) {
    print("❌ حدث خطأ أثناء تحديث التقدم: $e");
  }
}

Future<void> completeBookWithRating({
  required String bookDocId,
  required double bookRating,
}) async {
  try {
    await booksInfo.doc(bookDocId).update({
      "status": "completed",
      "rating": bookRating, // 👈 سيقوم بإنشاء الحقل وتحديثه تلقائياً حتى للكتب القديمة!
    });
    print("✅ تم إنهاء الكتاب وحفظ التقييم بنجاح!");
  } catch (e) {
    print("❌ حدث خطأ أثناء حفظ التقييم: $e");
  }
}




}



