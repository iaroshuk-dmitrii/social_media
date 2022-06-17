import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/models/post_model.dart';

class StoreRepository {
  final FirebaseFirestore _firebaseFirestore;

  StoreRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot?> postsSnapshot({String? userId}) {
    if (userId == null) {
      return _firebaseFirestore.collection('posts').snapshots();
    } else {
      return _firebaseFirestore.collection('posts').where('userId', isEqualTo: userId).snapshots();
    }
  }

  Stream<QuerySnapshot?> postsForPeriodSnapshot({
    String? userId,
    required DateTime startDateTime,
    required DateTime finalDateTime,
  }) {
    if (userId == null) {
      return _firebaseFirestore
          .collection('posts')
          .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startDateTime))
          .where('dateTime', isLessThan: Timestamp.fromDate(finalDateTime))
          .snapshots();
    } else {
      return _firebaseFirestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startDateTime))
          .where('dateTime', isLessThan: Timestamp.fromDate(finalDateTime))
          .snapshots();
    }
  }

  Future<String> addPost({required Post post}) async {
    try {
      DocumentReference reference = await _firebaseFirestore.collection('posts').add(post.toMap());
      return reference.id;
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<void> deletePost({required Post post}) async {
    try {
      await _firebaseFirestore.collection('posts').doc(post.id).delete();
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
