import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Muzeler/Comment/comment_service.dart';
import 'package:Muzeler/Login/auth.dart';
import 'package:Muzeler/Model/Museum_Model.dart';

import 'custom_cached_network_image.dart';
import 'museum_detail.dart';

AuthService _authService = AuthService();
CommentServise _commentServise = CommentServise();

class MuseumCard extends StatelessWidget {
  final Datum data;

  MuseumCard({required this.data});

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
                      SizedBox(
                        height: 12,
                      ),
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
