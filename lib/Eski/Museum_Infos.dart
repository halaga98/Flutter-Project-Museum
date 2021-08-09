import 'package:flutter/material.dart';
import 'package:untitled1/Model/Museums.dart';

class MuseumInfo extends StatelessWidget {
  final Museums selectedMuseum;
  const MuseumInfo({required this.selectedMuseum, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                selectedMuseum.Museum_Name,
                style: TextStyle(color: Colors.black),
              ),
              background: Image.asset(
                "images/big-museum.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Text(selectedMuseum.Museum_Info),
            ),
          )
        ],
      ),
    );
  }
}
