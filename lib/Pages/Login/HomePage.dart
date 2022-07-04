import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/BottomNavigator.dart';
import 'package:untitled1/Json_Museum.dart';
import 'package:untitled1/Model/Museum_Model.dart';
import 'package:untitled1/Pages/AllMusems/museum_detail.dart';
import 'package:untitled1/Pages/Comment/comment_service.dart';
import 'package:untitled1/Pages/Profile/UserAccontsDrawer.dart';
import 'package:untitled1/Pages/Profile/picture_service.dart';
import 'package:untitled1/Pages/Profile/profile.dart';

import 'auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService _authService = AuthService();
  CommentServise _commentServise = CommentServise();
  StorageService _storageService = StorageService();

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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      child: Text(
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
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => MuseumDetailScreen(
                                    data: Datum(
                                        muzeAd: mypost["müze"][itemIndex]["ad"],
                                        bresim: mypost["müze"][itemIndex]
                                            ["resim"],
                                        muzeAciklama: mypost["müze"][itemIndex]
                                            ["muzeAciklama"],
                                        calismaSaatleri: mypost["müze"]
                                            [itemIndex]["calismaSaatleri"],
                                        girisDetay: mypost["müze"][itemIndex]
                                            ["girisDetay"],
                                        latitude: Itude(
                                            numberDouble: mypost["müze"]
                                                [itemIndex]["latitude"]),
                                        longitude: Itude(
                                            numberDouble: mypost["müze"]
                                                [itemIndex]["longitude"]),
                                        muzeAdres: mypost["müze"][itemIndex]
                                            ["muzeAdres"],
                                        muzeMail: mypost["müze"][itemIndex]
                                            ["muzeMail"],
                                        muzeTel: mypost["müze"][itemIndex]
                                            ["muzeTel"],
                                        muzeWebSite: mypost["müze"][itemIndex]["muzeWebSite"],
                                        sehir: mypost["müze"][itemIndex]["sehir"],
                                        ilce: mypost["müze"][itemIndex]["ilce"],
                                        muzekart: mypost["müze"][itemIndex]["muzekart"],
                                        category: ""),
                                  ));
                            },
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 420,
                                      height: 370,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                            ),
                          );
                        }
                      },
                      options: CarouselOptions(
                        autoPlayCurve: Curves.easeInOutBack,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.75,
                        aspectRatio: 1.75,
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
                      title: Text('Profilimi Düzenle'),
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
