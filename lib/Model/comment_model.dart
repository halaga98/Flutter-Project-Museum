import 'package:cloud_firestore/cloud_firestore.dart';

class commentmodel {
  late String id;
  late double star;
  late String comment;

  commentmodel({required this.id, required this.star, required this.comment});

  factory commentmodel.fromSnapshot(DocumentSnapshot snapshot) {
    return commentmodel(
        id: snapshot.id, star: snapshot["star"], comment: snapshot["comment"]);
  }
}
