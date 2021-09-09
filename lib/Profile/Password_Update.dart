import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:Muzeler/Login/auth.dart';

AuthService _authService = AuthService();

class PasswordUpdate extends StatefulWidget {
  final String mail;
  const PasswordUpdate({required this.mail});

  @override
  _PasswordUpdateState createState() => _PasswordUpdateState();
}

class _PasswordUpdateState extends State<PasswordUpdate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpaceBar(
          background: Image.asset("images/big-museum.png"),
        ),
        title: Text("Şifre Değiştirme"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text(widget.mail),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(300), right: Radius.circular(300)),
              ),
              tileColor: Colors.grey,
            ),
            InkWell(
              onTap: () {
                _authService.UpdatePassword(widget.mail);
                Fluttertoast.showToast(
                    msg: "Mail Gönderildi",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 55,
                  width: 150,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(color: Colors.grey, width: 2),
                      //color: colorPrimaryShade,
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                        child: Text(
                      "Gönder",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
