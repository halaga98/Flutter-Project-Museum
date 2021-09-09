import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:Muzeler/Json_Museum.dart';
import 'package:Muzeler/Login/HomePage.dart';
import 'package:Muzeler/Login/LoginPageDesign.dart';
import 'package:Muzeler/Login/auth.dart';
import 'package:Muzeler/MainHomePage/MainHomePage.dart';

AuthService _authService = AuthService();

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;

  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: _getPage(currentPage),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.home, title: "Ana Sayfa"),
          TabData(
            iconData: Icons.search,
            title: "Arama",
          ),
          TabData(iconData: Icons.account_circle, title: "Profil")
        ],
        initialSelection: 0,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return MainHomePage();
      case 1:
        return JsonMuseum();
      default:
        return _authService.CurrentUser() != null ? HomePage() : LoginPage();
    }
  }
}
