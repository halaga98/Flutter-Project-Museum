import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/Model/Museum_Model.dart';
import 'package:untitled1/Pages/Comment/comment_service.dart';
import 'package:untitled1/Pages/Login/auth.dart';

import '../../Custom/custom_cached_network_image.dart';
import 'museum_detail.dart';

AuthService _authService = AuthService();
CommentServise _commentServise = CommentServise();

class MuseumCardSearch extends StatefulWidget {
  final List<Datum> data;

  MuseumCardSearch({required this.data});

  @override
  _MuseumCardSearchState createState() => _MuseumCardSearchState();
}

class _MuseumCardSearchState extends State<MuseumCardSearch> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
