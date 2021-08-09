import 'package:flutter/material.dart';
import 'package:untitled1/Model/Museum_Model.dart';

import 'museum_card.dart';

class CityMusems extends StatelessWidget {
  final MuseumModel model;
  const CityMusems({required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.data[0].sehir),
      ),
      body: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: model.data.length,
          itemBuilder: (context, index) {
            return MuseumCard(
              data: model.data[index],
            );
          }),
    );
  }
}
