import 'package:flutter/material.dart';
import 'package:untitled1/Eski/Museum_Item.dart';
import 'package:untitled1/Model/Museums.dart';

import '../Data/Mydatas.dart';

class MuseumList extends StatelessWidget {
  late List<Museums> AllMuseums;
  MuseumList() {
    AllMuseums = CreateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.red,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Museums"),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return MuseumItem(museum_list: AllMuseums[index]);
            }, childCount: AllMuseums.length),
          )
        ],
      ),
    );
  }

  List<Museums> CreateData() {
    List<Museums> temporary = [];
    for (int i = 1; i <= 14; i++) {
      Museums addMuseum = Museums(
        Mydatas.Museums_Name[i],
        Mydatas.Museums_Place[i],
        Mydatas.Museums_Info[i],
      );
      temporary.add(addMuseum);
    }
    return temporary;
  }
}
