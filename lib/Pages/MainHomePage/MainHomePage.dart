import 'dart:convert';
import 'dart:core';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:untitled1/Model/Museum_Model.dart';
import 'package:untitled1/Pages/AllMusems/museum_detail.dart';
import 'package:untitled1/Pages/Comment/comment_service.dart';
import 'package:untitled1/Pages/Login/auth.dart';

class MainHomePage extends StatefulWidget {
  MainHomePage({Key? key}) : super(key: key);

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

List<String> imgList = [];

class _MainHomePageState extends State<MainHomePage> {
  int indexs = -1;
  List<MuseumModel> _searchList = [];
  AuthService _authService = AuthService();
  CommentServise _commentServise = CommentServise();
  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<String> a = [];

  Future _gonderi() async {
    final response = await http.get(
      Uri.parse(
          "https://raw.githubusercontent.com/halaga98/FavoriMuzeler/main/FavoriMüzeler.json"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Müzeler"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.linearToSrgbGamma(),
            image: AssetImage("images/Destin.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
            future: _gonderi(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Seçilmiş Müzeler',
                            style: GoogleFonts.libreCaslonDisplay(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              foreground: Paint()
                                ..style = PaintingStyle.fill
                                ..color = Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: CarouselSlider.builder(
                              itemCount:
                                  (snapshot.data[0] as MuseumModel).data.length,
                              itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => MuseumDetailScreen(
                                          data:
                                              (snapshot.data[0] as MuseumModel)
                                                  .data[itemIndex],
                                        ));
                                  },
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(),
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage((snapshot
                                                        .data[0] as MuseumModel)
                                                    .data[itemIndex]
                                                    .bresim),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          child: Text(
                                            (snapshot.data[0] as MuseumModel)
                                                .data[itemIndex]
                                                .muzeAd,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 700),
                                autoPlayCurve: Curves.easeInOutBack,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 0.75,
                                aspectRatio: 1.75,
                                initialPage: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /* SizedBox(height: 10),
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(height: 10),*/
                    Expanded(
                      flex: 0,
                      child: Container(
                        height: 20,
                        child: Divider(
                          thickness: 1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'En Çok Beğenilen Müzeler',
                            style: GoogleFonts.libreCaslonDisplay(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              foreground: Paint()
                                ..style = PaintingStyle.fill
                                ..color = Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: CarouselSlider.builder(
                              itemCount:
                                  (snapshot.data[1] as MuseumModel).data.length,
                              itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => MuseumDetailScreen(
                                        data: (snapshot.data[1] as MuseumModel)
                                            .data[itemIndex],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: 420,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(),
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage((snapshot
                                                        .data[1] as MuseumModel)
                                                    .data[itemIndex]
                                                    .bresim),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          child: Text(
                                            (snapshot.data[1] as MuseumModel)
                                                .data[itemIndex]
                                                .muzeAd,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                autoPlayCurve: Curves.easeInOutBack,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 0.75,
                                aspectRatio: 1.75,
                                initialPage: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
