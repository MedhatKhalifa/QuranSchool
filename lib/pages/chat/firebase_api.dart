import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models/userChat_model.dart';

final _db = FirebaseFirestore.instance;

Stream<List<UserChat>> userStream() {
  try {
    return _db.collection("users").snapshots().map((notes) {
      final List<UserChat> allchatusers = <UserChat>[];
      for (final DocumentSnapshot<Map<String, dynamic>> doc in notes.docs) {
        allchatusers.add(UserChat.fromDocumentSnapshot(doc: doc));
      }
      return allchatusers;
    });
  } catch (e) {
    rethrow;
  }
}
