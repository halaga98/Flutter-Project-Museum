import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/Custom/custom_cached_network_image.dart';

import 'package:untitled1/Model/Museum_Model.dart';
import 'package:untitled1/Pages/Login/auth.dart';

import 'ListTile.dart';
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
              ? Center(child: CircularProgressIndicator())
              : snapshot.data!.docs.length == 0
                  ? Center(
                      child: Text(
                      "Herhangi Bir Yorum Bulunamadı",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ))
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
                              mypost["imageUrl"].toString().isEmpty
                                  ? Container()
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 250,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: CustomCachedNetworkImage(
                                        url: mypost["imageUrl"],
                                        boxFit: BoxFit.cover,
                                        borderRadius: 5,
                                      ),
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
