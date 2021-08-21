import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:untitled1/Comment/comment_service.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Comment/CommentPage.dart';
import 'Login/LoginPageDesign.dart';
import 'Login/auth.dart';
import 'Model/Museum_Model.dart';
import 'custom_cached_network_image.dart';

class MuseumDetailScreen extends StatelessWidget {
  final Datum data;
  MuseumDetailScreen({required this.data});
  CommentServise _commentServise = CommentServise();
  AuthService _authService = AuthService();

  final TextEditingController _commentController = TextEditingController();
  Widget _showImage() {
    Widget widget;

    if (data.bresim != '') {
      widget = Hero(
        tag: data.bresim,
        child: CustomCachedNetworkImage(
          url: data.bresim,
        ),
      );
    } else {
      widget = Container(
        margin: EdgeInsets.all(40),
        child: Image.asset(
          'images/1024px.png',
          color: Colors.red,
        ),
      );
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    IconData a = Icons.star_border;
    double yildiz = 3;
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () async {
                      final availableMaps = await MapLauncher.installedMaps;
                      await availableMaps.first.showMarker(
                        coords: Coords(double.parse(data.latitude.numberDouble),
                            double.parse(data.longitude.numberDouble)),
                        title: data.muzeAd,
                      );
                    },
                    child: Icon(
                      Icons.location_on,
                      size: 26.0,
                    ),
                  ),
                ),
              ],
              pinned: true,
              title: Text(data.muzeAd),
              expandedHeight: 350,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.red,
                  child: _showImage(),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  data.muzeAd,
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                data.girisDetay,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                          height: 15,
                          thickness: 1,
                        ),
                        Text(
                          data.muzeAciklama,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Times New Roman",
                              letterSpacing: 1.5,
                              wordSpacing: 4,
                              fontWeight: FontWeight.w400),
                        ),
                        Divider(
                          color: Colors.black,
                          height: 15,
                          thickness: 1,
                        ),
                        ListTile(
                          title: Text("Çalışma Saatleri :"),
                          subtitle: Text(data.calismaSaatleri),
                          leading: Icon(Icons.info),
                        ),
                        ListTile(
                          title: Text("Adres : "),
                          subtitle: Text(data.muzeAdres),
                          leading: Icon(Icons.museum_outlined),
                        ),
                        ListTile(
                          onTap: () async {
                            launch('tel://${data.muzeTel}');
                          },
                          title: Text("Telefon : "),
                          subtitle: Text(
                            data.muzeTel,
                          ),
                          leading: Icon(Icons.phone),
                        ),
                        ListTile(
                          title: Text("E-Posta : "),
                          subtitle: Text(data.muzeMail),
                          leading: Icon(Icons.mail),
                        ),
                        ListTile(
                          //login değilse login page e yönlendir
                          title: Text("Yorum ekle..."),
                          leading: Icon(Icons.comment),
                          trailing: Icon(Icons.star),
                          onTap: () {
                            if (_authService.CurrentUser() == null) {
                              Get.to(() => LoginPage());
                            } else {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                backgroundColor: Colors.white,
                                builder: (context) => Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          title: TextField(
                                            controller: _commentController,
                                            decoration: InputDecoration(
                                                hintText: "Yorum yazınız..."),
                                            autofocus: true,
                                          ),
                                          leading: CircleAvatar(
                                              child: Icon(Icons.face)),
                                          trailing: GestureDetector(
                                              onTap: () {
                                                _commentServise.addStatus(
                                                    _authService
                                                        .CurrentUserId(),
                                                    yildiz,
                                                    _commentController.text,
                                                    data.muzeAd.toLowerCase());
                                                _commentController.clear();
                                                Get.back();
                                              },
                                              child: Icon(Icons.send)),
                                        ),
                                      ),
                                      RatingBar.builder(
                                        initialRating: 3,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          yildiz = rating;
                                          print(rating);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        ListTile(
                          title: Text("Yorumlar "),
                          leading: Icon(Icons.comment_sharp),
                          subtitle: Text("Tüm Yorumları Görüntüle..."),
                          onTap: () {
                            Get.to(() => CommentPage(
                                  data: data,
                                ));
                          },
                        ),
                      ],
                    ),
                  );
                },
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
