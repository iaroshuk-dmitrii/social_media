import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String userId;
  String text;
  String imageUrl;
  DateTime dateTime;
  List<String> likesUserId;

  Post({
    required this.id,
    required this.userId,
    required this.text,
    required this.imageUrl,
    required this.dateTime,
    required this.likesUserId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'text': text,
      'imageUrl': imageUrl,
      'dateTime': Timestamp.fromDate(dateTime),
      'likesUserId': likesUserId,
    };
  }

  factory Post.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Post(
      id: snapshot.id,
      userId: data['userId'],
      text: data['text'],
      imageUrl: data['imageUrl'],
      dateTime: data['dateTime'].toDate(),
      likesUserId: data['likesUserId'],
    );
  }

  @override
  String toString() {
    return 'Post{id: $id, userId: $userId, text: $text, imageUrl: $imageUrl, dateTime: $dateTime, likesUserId: $likesUserId}';
  }
}
