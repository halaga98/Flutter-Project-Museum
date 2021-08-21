import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/Comment/comment_service.dart';
import 'package:untitled1/Login/auth.dart';
import 'package:untitled1/Profile/UpdateName.dart';
import 'package:untitled1/Profile/picture_service.dart';

import 'Password_Update.dart';

AuthService _authService = AuthService();
CommentServise _commentServise = CommentServise();
StorageService _storageService = StorageService();

class ProfilPage extends StatefulWidget {
  final String mail;
  String name;
  String image;
  ProfilPage({required this.mail, required this.name, required this.image});

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  final ImagePicker _imagePicker = ImagePicker();
  dynamic _imagePick;
  XFile? profileImage;

  Widget ImagePlace() {
    double height = MediaQuery.of(context).size.height;
    if (profileImage != null) {
      return CircleAvatar(
        backgroundImage: FileImage(
          File(profileImage!.path),
        ),
        radius: height * 0.065,
      );
    }
    if (widget.image != "") {
      return CircleAvatar(
        backgroundImage: NetworkImage(widget.image),
        radius: height * 0.065,
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.white,
        radius: height * 0.065,
        child: Image.asset("images/person.png"),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              title: Text("Profil"),
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage("images/Profile-Museum.jpg"),
                        fit: BoxFit.cover),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImagePlace(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () async {
                              var result = await Get.to(
                                  () => UpdateName(name: widget.name));

                              if (result != null) {
                                setState(() {
                                  widget.name = result;
                                });
                              }
                            },
                            leading: Icon(Icons.person),
                            title: Text(widget.name),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(300),
                                  right: Radius.circular(300)),
                            ),
                            tileColor: Colors.grey,
                            trailing: Icon(Icons.arrow_forward_outlined),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Icon(Icons.mail),
                            title: Text(widget.mail),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(300),
                                  right: Radius.circular(300)),
                            ),
                            tileColor: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Icon(Icons.vpn_key),
                            title: Text("Şifre Değiştirme"),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(300),
                                  right: Radius.circular(300)),
                            ),
                            trailing: Icon(Icons.arrow_forward_outlined),
                            tileColor: Colors.grey,
                            onTap: () {
                              Get.to(() => PasswordUpdate(mail: widget.mail));
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 1,
              ),
            )
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
                      onTap: () {
                        _onImageButtonPressed(ImageSource.gallery,
                            context: context);

                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _onImageButtonPressed(ImageSource.camera,
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

  void _onImageButtonPressed(ImageSource source,
      {required BuildContext context}) async {
    print("set sttaeeasease üstü");
    setState(() {});

    final pickedFile = await _imagePicker.pickImage(source: source);
    print("set sttaeeasease");
    profileImage = pickedFile;
    print("dosyaya geldim: $profileImage");
    var image = await _authService.UploadMedia(profileImage!);
    if (profileImage != null) {
      _storageService.deleteImage(widget.image);
      widget.image = image;
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
