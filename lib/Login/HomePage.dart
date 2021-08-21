import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/Comment/comment_service.dart';
import 'package:untitled1/Json_Museum.dart';
import 'package:untitled1/Login/auth.dart';
import 'package:untitled1/Profile/UserAccontsDrawer.dart';
import 'package:untitled1/Profile/profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService _authService = AuthService();
  CommentServise _commentServise = CommentServise();

  @override
  Widget build(BuildContext context) {
    //  late String mail = "";
    // late String image = "";
    // late String userName = "";
    int a = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: StreamBuilder(
          stream: (_commentServise.getPerson()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              late DocumentSnapshot mypost;

              mypost = (snapshot.data);

              return Column(
                children: [
                  Text(
                    'Favoriler',
                    style: TextStyle(
                      fontSize: 40,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3.5
                        ..color = Colors.blue.shade600,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  CarouselSlider.builder(
                    itemCount: mypost["müze"].length,
                    itemBuilder: (BuildContext context, int itemIndex,
                        int pageViewIndex) {
                      if (mypost["müze"].length == 0) {
                        return Container();
                      } else {
                        return Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                  width: 420,
                                  height: 370,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(mypost["müze"]
                                              [itemIndex]["resim"]))),
                                ),
                              ),
                              Container(
                                child: Text(
                                  mypost["müze"][itemIndex]["ad"],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      aspectRatio: 1.9,
                      initialPage: 1,
                    ),
                  ),
                ],
              );
            }
          }),
      drawer: StreamBuilder(
          stream: (_commentServise.getPerson()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              int a = 0;
              DocumentSnapshot mypost = snapshot.data;

              return Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    UserAccontsDrawer(
                        userName: mypost["userName"],
                        mail: mypost["email"],
                        image: mypost["image"]),
                    ListTile(
                      title: Text('Anasayfa'),
                      leading: Icon(Icons.home),
                      onTap: () {
                        Get.to(() => JsonMuseum());
                      },
                    ),
                    ListTile(
                      title: Text('Profilim'),
                      onTap: () {
                        Get.to(() => ProfilPage(
                              name: mypost["userName"],
                              mail: mypost["email"],
                              image: mypost["image"],
                            ));
                      },
                      leading: Icon(Icons.person),
                    ),
                    Divider(),
                    ListTile(
                      title: Text('Çıkış yap'),
                      onTap: () {
                        _authService.singOut();
                        Get.to(() => JsonMuseum());
                      },
                      leading: Icon(Icons.remove_circle),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
