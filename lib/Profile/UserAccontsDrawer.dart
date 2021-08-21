import 'package:flutter/material.dart';

class UserAccontsDrawer extends StatefulWidget {
  final String userName;
  final String mail;
  final String image;
  const UserAccontsDrawer(
      {required this.userName, required this.mail, required this.image});

  @override
  _UserAccontsDrawerState createState() => _UserAccontsDrawerState();
}

class _UserAccontsDrawerState extends State<UserAccontsDrawer> {
  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: Text(widget.userName),
      accountEmail: Text(widget.mail),
      currentAccountPicture: CircleAvatar(
        backgroundImage: widget.image == ""
            ? AssetImage("images/person.png")
            : NetworkImage(widget.image) as ImageProvider,
      ),
    );
  }
}
