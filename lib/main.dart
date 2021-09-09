import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Muzeler/BottomNavigator.dart';
import 'package:Muzeler/Json_Museum.dart';

import 'introduction_screen/introductionscreen.dart';

late bool a = false;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Prefs() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getBool("key") == null) {
      prefs.setBool("key", true);
      a = false;
    } else {
      a = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Prefs();
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Text("HATA-*-" + snapshot.hasError.toString()),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                primarySwatch: Colors.grey,
                appBarTheme: AppBarTheme(color: Colors.grey.shade500)),
            home: (a == true) ? MyHomePage() : OnBoardingPage(),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
