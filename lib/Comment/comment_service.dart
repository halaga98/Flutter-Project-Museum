import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Muzeler/Login/auth.dart';
import 'package:Muzeler/Model/comment_model.dart';

class CommentServise {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthService _authService = AuthService();

// ekleme kısmı

  Future addStatus(
      String id, double star, String comment, String collection) async {
    var ref = _firestore.collection(collection);

    var documentRef =
        await ref.add(({"id": id, "star": star, "comment": comment}));
    return commentmodel(id: id, star: star, comment: comment);
  }

  //okuma kısmı
  Stream<QuerySnapshot> getStatus(String collection) {
    var ref = _firestore.collection(collection).snapshots();
    var def = _firestore.collection("Person").snapshots();
    return ref;
  }

  Stream getPerson() {
    //var def = _firestore.collection("Person").snapshots();
    var def = _firestore
        .collection("Person")
        .doc(_authService.CurrentUserId())
        .snapshots();
    return def;
  }

  Stream<QuerySnapshot> GetQueryPerson() {
    var def = _firestore.collection("Person").snapshots();
    return def;
  }

  Future<void> RemoveComment(String docId, String muzaAd) {
    var ref = _firestore.collection(muzaAd).doc(docId).delete();
    return ref;
  }
}
