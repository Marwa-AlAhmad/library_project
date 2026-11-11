import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseQuotes {
  CollectionReference categoryQuotes = FirebaseFirestore.instance.collection(
    "categoryQuotes",
  );

  Future<void> addCategoryQuotes({required String categoryName}) async {
    await categoryQuotes.add({
      "id": FirebaseAuth.instance.currentUser!.uid,
      "categoryQuoteTitle": categoryName,
      "created_at": FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getCatetoryQuotesStream() {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return FirebaseFirestore.instance
        .collection("categoryQuotes")
        .where("id", isEqualTo: currentUserId) // 👈 السطر الجديد والمهم للفلترة
        .snapshots();
  }

  deleteCategoryQuoutes({required String docId}) async {
    await FirebaseFirestore.instance
        .collection("categoryQuotes")
        .doc(docId)
        .delete();
  }

  Future<void> addQuotes({
    required String folderId,
    required String quoteText,
  }) async {
    await FirebaseFirestore.instance
        .collection("categoryQuotes")
        .doc(folderId)
        .collection("quotes")
        .add({
          "id": FirebaseAuth.instance.currentUser!.uid,
          "text": quoteText,
          "created_at": FieldValue.serverTimestamp(),
        });
  }

  Stream<QuerySnapshot> getQuotesStream({required String folderId}) {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return FirebaseFirestore.instance
        .collection("categoryQuotes")
        .doc(folderId)
        .collection("quotes")
        .where("id", isEqualTo: currentUserId)
        .snapshots();
  }

  deleteQuoutes({required String folderId, required String quoteId}) async {
    await FirebaseFirestore.instance
        .collection("categoryQuotes")
        .doc(folderId)
        .collection("quotes")
        .doc(quoteId)
        .delete();
  }

  updateQuotes({
    required String nowQuoteText,
    required String folderId,
    required String quoteId,
  }) async {
    await FirebaseFirestore.instance
        .collection("categoryQuotes")
        .doc(folderId)
        .collection("quotes")
        .doc(quoteId)
        .update({"text": nowQuoteText});
  }



}
