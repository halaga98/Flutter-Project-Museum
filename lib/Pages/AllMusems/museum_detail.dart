import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:untitled1/Pages/Comment/CommentPage.dart';
import 'package:untitled1/Pages/Comment/comment_service.dart';
import 'package:untitled1/Pages/Login/LoginPageDesign.dart';
import 'package:untitled1/Pages/Login/auth.dart';
import 'package:untitled1/Pages/Profile/picture_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/Museum_Model.dart';
import '../../Custom/custom_cached_network_image.dart';

class MuseumDetailScreen extends StatefulWidget {
  final Datum data;
  MuseumDetailScreen({required this.data});

  @override
  _MuseumDetailScreenState createState() => _MuseumDetailScreenState();
}

class _MuseumDetailScreenState extends State<MuseumDetailScreen>
    with TickerProviderStateMixin {
  CommentServise _commentServise = CommentServise();
  StorageService _storageService = StorageService();

  AuthService _authService = AuthService();

  final TextEditingController _commentController = TextEditingController();
  Widget _showImage() {
    Widget widget1;

    if (widget.data.bresim != '') {
      widget1 = Hero(
        tag: widget.data.bresim,
        child: CustomCachedNetworkImage(
          url: widget.data.bresim,
        ),
      );
    } else {
      widget1 = Container(
        margin: EdgeInsets.all(40),
        child: Image.asset(
          'images/1024px.png',
          color: Colors.red,
        ),
      );
    }
    return widget1;
  }

  ScrollController _scrollController = new ScrollController();
  bool _showBackToTopButton = true;
  final ImagePicker _imagePicker = ImagePicker();
  dynamic _imagePick;
  XFile? profileImage;
  String Url = "";
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent) {
            _showBackToTopButton = false; // show the back-to-top button
          } else {
            _showBackToTopButton = true; // hide the back-to-top button
          }
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IconData a = Icons.star_border;
    double yildiz = 3;
    // TODO: implement build
    return Scaffold(
      floatingActionButton: _showBackToTopButton == false
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                    _scrollController.position.minScrollExtent,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.linear);
                setState(() {});
              },
              child: Icon(Icons.arrow_upward),
            )
          : FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.linear);
                setState(() {});
              },
              child: Icon(Icons.arrow_downward),
            ),
      body: Container(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () async {
                      final availableMaps = await MapLauncher.installedMaps;
                      await availableMaps.first.showMarker(
                        coords: Coords(
                            double.parse(widget.data.latitude.numberDouble),
                            double.parse(widget.data.longitude.numberDouble)),
                        title: widget.data.muzeAd,
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
              title: Text(widget.data.muzeAd),
              expandedHeight: 350,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.red,
                  child: _showImage(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.data.muzeAd,
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
                              widget.data.girisDetay,
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                        height: 15,
                        endIndent: 13,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          child: Text(
                            widget.data.muzeAciklama,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Times New Roman",
                                letterSpacing: 1.5,
                                wordSpacing: 4,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        height: 15,
                        thickness: 1,
                      ),
                      ListTile(
                        title: Text("Çalışma Saatleri :"),
                        subtitle: Text(widget.data.calismaSaatleri),
                        leading: Icon(Icons.info),
                      ),
                      ListTile(
                        title: Text("Adres : "),
                        subtitle: Text(widget.data.muzeAdres),
                        leading: Icon(Icons.museum_outlined),
                      ),
                      ListTile(
                        onTap: () async {
                          launch('tel://${widget.data.muzeTel}');
                        },
                        title: Text("Telefon : "),
                        subtitle: Text(
                          widget.data.muzeTel,
                        ),
                        leading: Icon(Icons.phone),
                      ),
                      ListTile(
                        leading: Icon(Icons.credit_card_sharp),
                        title: Text("Müze Kart :"),
                        subtitle: Text(widget.data.muzekart),
                      ),
                      ListTile(
                        title: Text("E-Posta : "),
                        subtitle: Text(widget.data.muzeMail == "muze@asist.com "
                            ? "mobil.muzeler@gmail.com"
                            : widget.data.muzeMail),
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
                                builder: (context) => StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return Padding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                title: TextField(
                                                  controller:
                                                      _commentController,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Yorum yazınız...",
                                                  ),
                                                  autofocus: true,
                                                ),
                                                leading: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _showPicker(context);
                                                    });
                                                  },
                                                  child: CircleAvatar(
                                                      child: Icon(
                                                          Icons.photo_camera)),
                                                ),
                                                trailing: GestureDetector(
                                                    onTap: () async {
                                                      await _commentServise
                                                          .addStatus(
                                                              _authService
                                                                  .CurrentUserId(),
                                                              yildiz,
                                                              _commentController
                                                                  .text,
                                                              widget.data.muzeAd
                                                                  .toLowerCase(),
                                                              Url.isNullOrBlank!
                                                                  ? ""
                                                                  : Url);
                                                      setState(() {
                                                        Url = "";
                                                        _commentController
                                                            .clear();
                                                      });

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
                                      );
                                    }));
                          }
                        },
                      ),
                      ListTile(
                        title: Text("Yorumlar "),
                        leading: Icon(Icons.comment_sharp),
                        subtitle: Text("Tüm Yorumları Görüntüle..."),
                        onTap: () {
                          Get.to(() => CommentPage(
                                data: widget.data,
                              ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () async {
                        await _onImageButtonPressed(ImageSource.gallery,
                            context: context);

                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      await _onImageButtonPressed(ImageSource.camera,
                          context: context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {required BuildContext context}) async {
    print("set sttaeeasease üstü");
    setState(() {});

    final pickedFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 75,
    );
    print("set sttaeeasease");
    profileImage = pickedFile;
    print("dosyaya geldim: $profileImage");
    var image = await _authService.UploadMediaForComment(profileImage!);
    Url = image;
    print("image" + image);
    if (profileImage != null) {
      setState(() {});

      /* var myValueListenable;
          ValueListenableBuilder(
              valueListenable: myValueListenable,
              builder: (context, value, _) {
                return Provider.value(
                  value: value,
                  child: HomePage(),
                );
              });*/
    }

    print('aaa');
    try {} catch (e) {
      setState(() {
        print("Image Error: ");
      });
    }
  }
}
