import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Muzeler/Comment/ListTile.dart';
import 'package:Muzeler/Login/auth.dart';
import 'package:Muzeler/Model/Museum_Model.dart';

import 'comment_service.dart';

CommentServise _commentServise = CommentServise();
AuthService _authService = AuthService();

class CommentPage extends StatefulWidget {
  final Datum data;
  CommentPage({required this.data});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.muzeAd),
      ),
      body: StreamBuilder(
        stream: (_commentServise.getStatus(widget.data.muzeAd.toLowerCase())),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot mypost = snapshot.data.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTileWidget(
                            comment: mypost["comment"],
                            star: mypost["star"],
                            uid: mypost["id"],
                            muzeAd: widget.data.muzeAd.toLowerCase(),
                            Ruid: mypost.id,
                          ),
                          Divider(
                            thickness: 1,
                          )
                        ],
                      ),
                    );
                  });
        },
      ),
    );
  }
}
