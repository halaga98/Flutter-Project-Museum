import 'dart:convert';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/Model/Museum_Model.dart';
import 'package:untitled1/Pages/AllMusems/musem_card_search.dart';
import 'package:untitled1/Pages/AllMusems/museum_card.dart';
import 'package:untitled1/Pages/Login/auth.dart';

import 'Custom/custom_cached_network_image.dart';
import 'Pages/AllMusems/City_card.dart';
import 'Pages/AllMusems/museum_detail.dart';
import 'package:collection/collection.dart';

import 'Pages/Comment/comment_service.dart';

class JsonMuseum extends StatefulWidget {
  JsonMuseum({Key? key}) : super(key: key);

  @override
  _JsonMuseumState createState() => _JsonMuseumState();
}

class _JsonMuseumState extends State<JsonMuseum> with TickerProviderStateMixin {
  int indexs = -1;
  List<MuseumModel> _searchList = [];
  AuthService _authService = AuthService();
  TextEditingController _textEditingController = TextEditingController();
  Future _gonderi() async {
    final response = await http.get(
      Uri.parse(
          "https://raw.githubusercontent.com/halaga98/muzeDatalar/main/AllMuseum.json"),
    );
    if (response.statusCode == 200) {
      List<MuseumModel> _museumList = [];
      // json.decode(utf8.decode(response.bodyBytes))

      (json.decode(utf8.decode(response.bodyBytes)) as List).forEach((element) {
        _museumList.add(MuseumModel.fromJson(
            {'_id': element['_id'], 'data': element['data']}));
      });

      return _museumList;
    } else {
      throw Exception("Bağlanamadı ${response.statusCode}");
    }
  }

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  static const List<Tab> _tabs = [
    const Tab(child: const Text('Şehir')),
    const Tab(text: 'Müzeler'),
  ];
  CommentServise _commentServise = CommentServise();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Müzeler"),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: BouncingScrollPhysics(),
        dragStartBehavior: DragStartBehavior.down,
        children: [
          FutureBuilder(
              future: _gonderi(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  for (int i = 0; i < snapshot.data!.length; i++)
                    _searchList.add((snapshot.data![i] as MuseumModel));
                  return GestureDetector(
                    onPanCancel: () {
                      WidgetsBinding.instance!.focusManager.primaryFocus
                          ?.unfocus();
                    },
                    onTap: () {
                      WidgetsBinding.instance!.focusManager.primaryFocus
                          ?.unfocus();
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 26, bottom: 4),
                          child: TextFormField(
                            decoration: InputDecoration(
                                icon: Icon(Icons.search),
                                labelText: "Şehir Ara"),
                            onChanged: (yaz) {
                              setState(() {
                                if (yaz == "") {
                                  indexs = -1;
                                } else {
                                  for (int i = 0; i < _searchList.length; i++) {
                                    if (_searchList[i]
                                        .data[0]
                                        .sehir
                                        .toLowerCase()
                                        .contains(yaz.toLowerCase())) {
                                      indexs = i;
                                      break;
                                    }
                                  }
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              itemCount:
                                  (indexs == -1) ? snapshot.data.length : 1,
                              itemBuilder: (context, index) {
                                if (indexs == -1) {
                                  return CityCard(
                                    model: MuseumModel(
                                        id: (snapshot.data![index]
                                                as MuseumModel)
                                            .id,
                                        data: (snapshot.data![index]
                                                as MuseumModel)
                                            .data),
                                  );
                                } else {
                                  return CityCard(
                                      model: MuseumModel(
                                          id: (snapshot.data![index]
                                                  as MuseumModel)
                                              .id,
                                          data: _searchList[indexs].data));
                                }
                              }),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                      child: Column(
                    children: [CircularProgressIndicator()],
                  ));
                }
              }),
          FutureBuilder(
              future: _gonderi(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 26, bottom: 4),
                        child: TextFormField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.search), labelText: "Müze Ara"),
                          onChanged: (yaz) {
                            setState(() {
                              FilterMusem(snapshot.data);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: FilterMusem(snapshot.data).length,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            itemBuilder: (context, index) {
                              Datum museum = FilterMusem(snapshot.data)[index];
                              return museum.muzeAd.isNullOrBlank!
                                  ? Container()
                                  : _authService.CurrentUser() != null
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          height: 130,
                                          child: GestureDetector(
                                            onTap: () async {
                                              Get.to(() => MuseumDetailScreen(
                                                    data: museum,
                                                  ));
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              elevation: 4,
                                              margin: const EdgeInsets.all(0),
                                              color: Colors.white,
                                              child: Container(
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      height: 100,
                                                      width: 100,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      .7),
                                                              blurRadius: 1.0,
                                                              spreadRadius: 2.5,
                                                              offset:
                                                                  const Offset(
                                                                0.0,
                                                                0.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child:
                                                              museum.bresim !=
                                                                      ''
                                                                  ? Container(
                                                                      child:
                                                                          Hero(
                                                                        tag: museum
                                                                            .bresim,
                                                                        child:
                                                                            CustomCachedNetworkImage(
                                                                          url: museum
                                                                              .bresim,
                                                                          boxFit:
                                                                              BoxFit.cover,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      width: 50,
                                                                      height:
                                                                          50,
                                                                      child:
                                                                          Container(
                                                                        margin:
                                                                            EdgeInsets.all(8),
                                                                        child: Image.asset(
                                                                            'images/256px.png'),
                                                                      ),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                          Radius.circular(
                                                                              10),
                                                                        ),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.grey.withOpacity(0.7),
                                                                            spreadRadius:
                                                                                1,
                                                                            blurRadius:
                                                                                1,
                                                                            offset:
                                                                                const Offset(0, 1),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          StreamBuilder(
                                                              stream:
                                                                  _commentServise
                                                                      .getPerson(),
                                                              builder: (BuildContext
                                                                      context,
                                                                  AsyncSnapshot
                                                                      comment) {
                                                                if (!comment
                                                                    .hasData) {
                                                                  return Container();
                                                                } else {
                                                                  DocumentSnapshot
                                                                      mypost =
                                                                      comment
                                                                          .data;
                                                                  IconData a = Icons
                                                                      .favorite_border_rounded;
                                                                  (mypost["müze"]
                                                                          as List)
                                                                      .forEach(
                                                                          (element) {
                                                                    if (element[
                                                                            'ad'] ==
                                                                        museum
                                                                            .muzeAd) {
                                                                      a = Icons
                                                                          .favorite;
                                                                    }
                                                                  });

                                                                  return GestureDetector(
                                                                    onTap: () {
                                                                      //print((mypost["müze"] as List)[0]['ad']);
                                                                      //var list = (mypost["müze"] as List).removeAt(0);
                                                                      //_authService.DeleteFavMuseum();
                                                                      print(
                                                                          "asdasd");
                                                                      if ((mypost["müze"] as List)
                                                                              .length ==
                                                                          0) {
                                                                        _authService
                                                                            .FavMuseum(
                                                                          museum
                                                                              .muzeAd,
                                                                          museum
                                                                              .bresim,
                                                                          museum
                                                                              .muzeAciklama,
                                                                          museum
                                                                              .calismaSaatleri,
                                                                          museum
                                                                              .girisDetay,
                                                                          museum
                                                                              .latitude,
                                                                          museum
                                                                              .longitude,
                                                                          museum
                                                                              .muzeAdres,
                                                                          museum
                                                                              .muzeMail,
                                                                          museum
                                                                              .muzeTel,
                                                                          museum
                                                                              .muzeWebSite,
                                                                          museum
                                                                              .sehir,
                                                                          museum
                                                                              .ilce,
                                                                          museum
                                                                              .muzekart,
                                                                        );
                                                                        a = Icons
                                                                            .favorite;
                                                                        return;
                                                                      }
                                                                      for (int i =
                                                                              0;
                                                                          i < (mypost["müze"] as List).length;
                                                                          i++) {
                                                                        if ((mypost["müze"]
                                                                                as List)[i]['ad'] ==
                                                                            museum.muzeAd) {
                                                                          print(
                                                                              "if için");
                                                                          var x =
                                                                              (mypost["müze"] as List);

                                                                          x.removeAt(
                                                                              i);
                                                                          print(
                                                                              x);
                                                                          _authService.DeleteFavMuseum(
                                                                              x);
                                                                          print(
                                                                              "test2");
                                                                          a = Icons
                                                                              .favorite_border_rounded;
                                                                        } else {
                                                                          print(
                                                                              "else içi");
                                                                          print(
                                                                            museum.latitude,
                                                                          );
                                                                          _authService
                                                                              .FavMuseum(
                                                                            museum.muzeAd,
                                                                            museum.bresim,
                                                                            museum.muzeAciklama,
                                                                            museum.calismaSaatleri,
                                                                            museum.girisDetay,
                                                                            museum.latitude,
                                                                            museum.longitude,
                                                                            museum.muzeAdres,
                                                                            museum.muzeMail,
                                                                            museum.muzeTel,
                                                                            museum.muzeWebSite,
                                                                            museum.sehir,
                                                                            museum.ilce,
                                                                            museum.muzekart,
                                                                          );
                                                                          a = Icons
                                                                              .favorite;
                                                                        }
                                                                      }
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child:
                                                                          Icon(
                                                                        a,
                                                                        textDirection:
                                                                            TextDirection.rtl,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                              }),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        14),
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Text(
                                                                museum.muzeAd,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                maxLines: 5,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        14),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Text(
                                                                '${museum.sehir} / ${museum.ilce}',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 12,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                maxLines: 5,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        14),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Text(
                                                                "Telefon: ${museum.muzeTel}",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 12,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                maxLines: 5,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        14),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Text(
                                                                "Adres: ${museum.muzeAdres}",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 12,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
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
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          height: 130,
                                          child: GestureDetector(
                                            onTap: () async {
                                              Get.to(() => MuseumDetailScreen(
                                                    data: museum,
                                                  ));
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              elevation: 4,
                                              margin: const EdgeInsets.all(0),
                                              color: Colors.white,
                                              child: Container(
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      height: 100,
                                                      width: 100,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      .7),
                                                              blurRadius: 1.0,
                                                              spreadRadius: 2.5,
                                                              offset:
                                                                  const Offset(
                                                                0.0,
                                                                0.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child:
                                                              museum.bresim !=
                                                                      ''
                                                                  ? Container(
                                                                      child:
                                                                          Hero(
                                                                        tag: museum
                                                                            .bresim,
                                                                        child:
                                                                            CustomCachedNetworkImage(
                                                                          url: museum
                                                                              .bresim,
                                                                          boxFit:
                                                                              BoxFit.cover,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      width: 50,
                                                                      height:
                                                                          50,
                                                                      child:
                                                                          Container(
                                                                        margin:
                                                                            EdgeInsets.all(8),
                                                                        child: Image.asset(
                                                                            'images/256px.png'),
                                                                      ),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                          Radius.circular(
                                                                              10),
                                                                        ),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.grey.withOpacity(0.7),
                                                                            spreadRadius:
                                                                                1,
                                                                            blurRadius:
                                                                                1,
                                                                            offset:
                                                                                const Offset(0, 1),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 12,
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        14),
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Text(
                                                                museum.muzeAd,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                maxLines: 5,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        14),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Text(
                                                                '${museum.sehir} / ${museum.ilce}',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 12,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                maxLines: 5,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        14),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Text(
                                                                "Telefon: ${museum.muzeTel}",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 12,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                maxLines: 5,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        14),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Text(
                                                                "Adres: ${museum.muzeAdres}",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 12,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
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
                            }),
                      )
                    ],
                  );
                } else {
                  return Center(
                      child: Column(
                    children: [CircularProgressIndicator()],
                  ));
                }
              }),
        ],
      ),
    );
  }

  List<Datum> FilterMusem(List<MuseumModel> data) {
    List<Datum> fresh = [];
    if (_textEditingController.text.isEmpty) {
      fresh = [];
      data.forEach((element) {
        fresh.add(element.data.firstWhere((element) => true));
      });
    } else {
      fresh = [];
      data.forEach((element) {
        fresh.add(element.data.firstWhereOrNull((a) => a.muzeAd
                .toLowerCase()
                .contains(_textEditingController.text.toLowerCase())) ??
            Datum(
                muzeAd: "",
                muzeAciklama: "",
                calismaSaatleri: "",
                girisDetay: "",
                latitude: Itude(numberDouble: "12.0"),
                longitude: Itude(numberDouble: "12.0"),
                muzeAdres: "",
                muzeMail: "",
                muzeTel: "",
                muzeWebSite: "",
                sehir: "",
                ilce: "",
                muzekart: "",
                category: "",
                bresim: ""));
      });
    }
    return fresh;
  }
}
