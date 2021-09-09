import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Muzeler/Login/auth.dart';

import 'comment_service.dart';

CommentServise _commentServise = CommentServise();
AuthService _authService = AuthService();

class ListTileWidget extends StatefulWidget {
  final String comment;
  final double star;
  final String uid;
  final String muzeAd;
  final String Ruid;
  ListTileWidget(
      {required this.comment,
      required this.star,
      required this.uid,
      required this.muzeAd,
      required this.Ruid});

  @override
  _ListTileWidgetState createState() => _ListTileWidgetState();
}

class _ListTileWidgetState extends State<ListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _commentServise.GetQueryPerson(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            late DocumentSnapshot mypost = snapshot.data.docs[0];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              mypost = snapshot.data.docs[i];
              if (mypost.id == widget.uid) {
                break;
              }
            }
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: mypost["image"] == ""
                    ? AssetImage("images/person.png")
                    : NetworkImage(mypost["image"]) as ImageProvider,
              ),
              title: Text(mypost["userName"]),
              subtitle: Text(widget.comment),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.star.toString()),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                if (_authService.CurrentUser() != null) {
                  if (widget.uid == _authService.CurrentUserId()) {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext bc) {
                          return SafeArea(
                            child: Container(
                              child: new Wrap(
                                children: <Widget>[
                                  new ListTile(
                                      leading: new Icon(Icons.delete),
                                      title: new Text("Yorumu Sil"),
                                      onTap: () {
                                        setState(() {
                                          _commentServise.RemoveComment(
                                              widget.Ruid, widget.muzeAd);
                                        });

                                        Navigator.of(context).pop();
                                      }),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                }
              },
            );
          }
        });
  }
}
/*
*/
