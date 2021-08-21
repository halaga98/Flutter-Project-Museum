import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/Login/HomePage.dart';
import 'package:untitled1/Login/LoginPageDesign.dart';
import 'package:untitled1/Model/Museum_Model.dart';

import 'City_card.dart';
import 'Login/auth.dart';

class JsonMuseum extends StatefulWidget {
  JsonMuseum({Key? key}) : super(key: key);

  @override
  _JsonMuseumState createState() => _JsonMuseumState();
}

class _JsonMuseumState extends State<JsonMuseum> {
  int indexs = -1;
  List<MuseumModel> _searchList = [];
  AuthService _authService = AuthService();

  Future _gonderi() async {
    final response = await http.get(
      Uri.parse(
          "https://eu-central-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/museum-yfasf/service/Api/incoming_webhook/webhook0?secret=halaga"),
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
    {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
                onTap: () {
                  if (_authService.CurrentUser() == null) {
                    Get.to(() => LoginPage());
                  } else {
                    Get.to(() => HomePage());
                  }
                },
                child: Icon(Icons.login)),
          ),
        ],
        title: Text("Museums"),
      ),
      body: FutureBuilder(
          future: _gonderi(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              for (int i = 0; i < snapshot.data!.length; i++)
                _searchList.add((snapshot.data![i] as MuseumModel));
              return GestureDetector(
                onPanCancel: () {
                  WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();
                },
                onTap: () {
                  WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();
                },
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 26, bottom: 4),
                      child: TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.search), labelText: "Şehir Ara"),
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
                          itemCount: (indexs == -1) ? snapshot.data.length : 1,
                          itemBuilder: (context, index) {
                            if (indexs == -1) {
                              return CityCard(
                                model: MuseumModel(
                                    id: (snapshot.data![index] as MuseumModel)
                                        .id,
                                    data: (snapshot.data![index] as MuseumModel)
                                        .data),
                              );
                            } else {
                              return CityCard(
                                  model: MuseumModel(
                                      id: (snapshot.data![index] as MuseumModel)
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
    );
  }
}
