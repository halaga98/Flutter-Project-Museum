import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/Model/Museum_Model.dart';

import 'City_card.dart';

class JsonMuseum extends StatefulWidget {
  const JsonMuseum({Key? key}) : super(key: key);

  @override
  _JsonMuseumState createState() => _JsonMuseumState();
}

class _JsonMuseumState extends State<JsonMuseum> {
  Future _gonderi() async {
    final response = await http.get(
      Uri.parse(
          "https://eu-central-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/museum-yfasf/service/Api/incoming_webhook/webhook0?secret=halaga"),
    );
    if (response.statusCode == 200) {
      List<MuseumModel> _searchList = [];
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
      appBar: AppBar(
        title: Text("Museums"),
      ),
      body: FutureBuilder(
          future: _gonderi(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return CityCard(
                      model: MuseumModel(
                          id: (snapshot.data![index] as MuseumModel).id,
                          data: (snapshot.data![index] as MuseumModel).data),
                    );
                  });
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
