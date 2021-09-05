import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:untitled1/BottomNavigator.dart';
import 'package:untitled1/Json_Museum.dart';
import 'package:untitled1/Login/ForgetPassword.dart';
import 'package:untitled1/Login/SignUp.dart';
import 'package:untitled1/Login/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          height: size.height * .5,
          width: size.width * .85,
          decoration: BoxDecoration(
              color: Colors.blue.withOpacity(.75),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.75),
                    blurRadius: 10,
                    spreadRadius: 2)
              ]),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                      controller: _emailController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Colors.white,
                        ),
                        hintText: 'E-Mail',
                        prefixText: ' ',
                        hintStyle: TextStyle(color: Colors.white),
                        focusColor: Colors.white,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                      )),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  TextField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Colors.white,
                        ),
                        hintText: 'Parola',
                        prefixText: ' ',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        focusColor: Colors.white,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                      )),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => ForgetPassword());
                        },
                        child: Text(
                          "Şifremi Unuttum",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  InkWell(
                    onTap: () {
                      _authService
                          .singIn(
                              _emailController.text, _passwordController.text)
                          .then((value) {
                        Fluttertoast.showToast(
                            msg: value == null
                                ? "Giriş Başarısız"
                                : "Giriş Başarılı",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        if (value == null)
                          return Get.off(() => LoginPage());
                        else
                          return Get.off(() => MyHomePage());
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          //color: colorPrimaryShade,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                            child: Text(
                          "Giriş yap",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => RegisterPage());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 1,
                          width: 75,
                          color: Colors.white,
                        ),
                        Text(
                          "Kayıt ol",
                          style: TextStyle(color: Colors.white),
                        ),
                        Container(
                          height: 1,
                          width: 75,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
