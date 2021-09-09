import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:introduction_screen/introduction_screen.dart';
import 'package:Muzeler/Login/SignUp.dart';

import '../BottomNavigator.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {}

  Widget _buildFullscrenImage(String assetName) {
    return Image.asset(
      'images/$assetName',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalHeader: Align(
        alignment: Alignment.topRight,
      ),
      pages: [
        PageViewModel(
          title: "Müzeler",
          body:
              "Türkiyedeki 500 ' den fazla müze ve bunların detayları.\n\nÇalışma saatlerini,konumunu ve müzelere ait telefon numaralarına kolayca ulaşabilir",
          image: _buildFullscrenImage("Dolmabahçe1.jpg"),
          decoration: pageDecoration.copyWith(
            pageColor: Colors.white30,
            contentMargin: const EdgeInsets.symmetric(horizontal: 20),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
        ),
        PageViewModel(
          title: "Müzeler",
          body:
              "İstediğiniz müze hakkında yorum yapabilir,müzenin değerlendirilmesi için puan ,\n\nve müzelere müze kartı ile giriş yapılıp yapılamayacağını detaylar içerinde bulabilirisiniz.",
          image: _buildFullscrenImage("galata-kulesi_m.jpg"),
          decoration: pageDecoration.copyWith(
            pageColor: Colors.white30,
            contentMargin: const EdgeInsets.symmetric(horizontal: 20),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
        ),
        PageViewModel(
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    Get.to(() => RegisterPage());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.deepOrange.shade400,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    width: 200,
                    height: 30,
                    child: Center(
                      child: Text(
                        "Kayıt Olmak için Tıklayınız",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
            ],
          ),
          title: "Müzeler",
          body:
              "Kayıt olarak müzeler hakkında yorum yapabilir favori müzelerinizi profilinize ekliyebilir ve profilinizi düzenliyebilirsiniz.",
          image: _buildFullscrenImage("Kapadokya1.jpg"),
          decoration: pageDecoration.copyWith(
            pageColor: Colors.white30,
            contentMargin: const EdgeInsets.symmetric(horizontal: 20),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
        ),
      ],
      onDone: () => Get.to(() => MyHomePage()),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text('Atla'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Bitir!', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
