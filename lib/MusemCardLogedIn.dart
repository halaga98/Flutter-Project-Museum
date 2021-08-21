import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/Comment/comment_service.dart';
import 'package:untitled1/Login/auth.dart';
import 'package:untitled1/Model/Museum_Model.dart';

import 'custom_cached_network_image.dart';
import 'museum_detail.dart';

AuthService _authService = AuthService();
CommentServise _commentServise = CommentServise();

class MuseumCardLogedIn extends StatelessWidget {
  final Datum data;

  MuseumCardLogedIn({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      height: 130,
      child: GestureDetector(
        onTap: () async {
          Get.to(() => MuseumDetailScreen(
                data: data,
              ));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
          margin: const EdgeInsets.all(0),
          color: Colors.white,
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 100,
                  width: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.7),
                          blurRadius: 1.0,
                          spreadRadius: 2.5,
                          offset: const Offset(
                            0.0,
                            0.0,
                          ),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: data.bresim != ''
                          ? Container(
                              child: Hero(
                                tag: data.bresim,
                                child: CustomCachedNetworkImage(
                                  url: data.bresim,
                                  boxFit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              child: Container(
                                margin: EdgeInsets.all(8),
                                child: Image.asset('images/256px.png'),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      StreamBuilder(
                          stream: _commentServise.getPerson(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            } else {
                              DocumentSnapshot mypost = snapshot.data;
                              IconData a = Icons.favorite_border_rounded;
                              (mypost["müze"] as List).forEach((element) {
                                if (element['ad'] == data.muzeAd) {
                                  a = Icons.favorite;
                                }
                              });

                              return GestureDetector(
                                onTap: () {
                                  //print((mypost["müze"] as List)[0]['ad']);
                                  //var list = (mypost["müze"] as List).removeAt(0);
                                  //_authService.DeleteFavMuseum();
                                  print("asdasd");
                                  if ((mypost["müze"] as List).length == 0) {
                                    _authService.FavMuseum(
                                        data.muzeAd, data.bresim);
                                    a = Icons.favorite;
                                    return;
                                  }
                                  for (int i = 0;
                                      i < (mypost["müze"] as List).length;
                                      i++) {
                                    if ((mypost["müze"] as List)[i]['ad'] ==
                                        data.muzeAd) {
                                      print("if için");
                                      var x = (mypost["müze"] as List);

                                      x.removeAt(i);
                                      print(x);
                                      _authService.DeleteFavMuseum(x);
                                      print("test2");
                                      a = Icons.favorite_border_rounded;
                                    } else {
                                      print("else içi");
                                      _authService.FavMuseum(
                                          data.muzeAd, data.bresim);
                                      a = Icons.favorite;
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  alignment: Alignment.topRight,
                                  child: Icon(
                                    a,
                                    textDirection: TextDirection.rtl,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            }
                          }),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        alignment: Alignment.topLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            data.muzeAd,
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.left,
                            maxLines: 5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            '${data.sehir} / ${data.ilce}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.left,
                            maxLines: 5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            "Telefon: ${data.muzeTel}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.left,
                            maxLines: 5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            "Adres: ${data.muzeAdres}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.left,
                            maxLines: 5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
