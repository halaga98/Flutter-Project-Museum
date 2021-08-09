import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Json_Museum.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  /*final String api = 'https://tr.wikipedia.org/api/rest_v1/page/summary';

  List<String> getLinks({required List<String> mousems}) {
    List<String> pictures = [];

    mousems.forEach((mouse) async {
      final response =
          await http.get(Uri.parse('$api/${mouse.replaceAll(' ', '_')}'));
      pictures.add(jsonDecode(response.body)['originalimage']['source']);
    });

    return pictures;
  }*/

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JsonMuseum(),
    );
  }
}
