import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:Muzeler/Login/auth.dart';

AuthService _authService = AuthService();

class UpdateName extends StatefulWidget {
  final String name;
  const UpdateName({required this.name});

  @override
  _UpdateNameState createState() => _UpdateNameState();
}

class _UpdateNameState extends State<UpdateName> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController =
        TextEditingController(text: widget.name);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpaceBar(
          background: Image.asset("images/big-museum.png"),
        ),
        title: Text("Kullanıcı Adı Değiştirme"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: TextField(
                controller: _nameController,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(300), right: Radius.circular(300)),
              ),
              tileColor: Colors.grey,
            ),
            InkWell(
              onTap: () {
                _authService.UpdateUserName(_nameController.text);
                Fluttertoast.showToast(
                    msg: "Kaydedildi",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Get.back(result: _nameController.text);
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
                      "Kaydet",
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
