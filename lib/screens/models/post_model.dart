import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userID;
  final String userName;
  final Timestamp timeStamp;
  final String imageURL;
  final String description;

  Post({
    required this.id,
    required this.userID,
    required this.userName,
    required this.timeStamp,
    required this.imageURL,
    required this.description,
  });
}