import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Muzeler/BottomNavigator.dart';
import 'package:Muzeler/Comment/comment_service.dart';
import 'package:Muzeler/Json_Museum.dart';
import 'package:Muzeler/Login/auth.dart';
import 'package:Muzeler/MainHomePage/MainHomePage.dart';
import 'package:Muzeler/Profile/UserAccontsDrawer.dart';
import 'package:Muzeler/Profile/profile.dart';

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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.linearToSrgbGamma(),
            image: AssetImage("images/galata-kulesi_m.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
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
                      style: GoogleFonts.libreCaslonDisplay(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        foreground: Paint()
                          ..style = PaintingStyle.fill
                          ..strokeWidth = 3
                          ..color = Colors.black,
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
      ),
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
                        Get.offAll(() => MyHomePage());
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
                        Get.offAll(() => MyHomePage());
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
