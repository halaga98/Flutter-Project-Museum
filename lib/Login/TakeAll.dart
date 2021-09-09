import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Muzeler/Comment/comment_service.dart';
import 'package:Muzeler/Login/auth.dart';

CommentServise _commentServise = CommentServise();
AuthService _authService = AuthService();

class TakeAll extends StatefulWidget {
  TakeAll({Key? key}) : super(key: key);

  @override
  _TakeAllState createState() => _TakeAllState();
}

class _TakeAllState extends State<TakeAll> {
  static List AllAcces = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: (_commentServise.getPerson()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot mypost = snapshot.data.docs[index];
                    if (mypost.id == _authService.CurrentUserId()) {
                      AllAcces.addAll({
                        mypost["email"],
                        mypost["userName"],
                        mypost["image"]
                      });
                    }
                    return TextField(
                        autofocus: true,
                        onChanged: (yazi) {
                          if (yazi == "") {
                            Get.back();
                          }
                        });
                  });
        });
  }
}
