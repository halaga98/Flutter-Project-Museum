import 'package:flutter/material.dart';
import 'package:Muzeler/Eski/Museum_Infos.dart';
import 'package:Muzeler/Model/Museums.dart';

class MuseumItem extends StatelessWidget {
  final Museums museum_list;
  const MuseumItem({required this.museum_list, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MuseumInfo(selectedMuseum: museum_list),
            ),
          );
        },
        leading: Image.asset(
          "images/256px.png",
        ),
        title: Text(museum_list.Museum_Name),
        subtitle: Text(museum_list.Museum_Place),
        trailing: Icon(Icons.arrow_forward_ios_sharp),
      ),
    );
  }
}
