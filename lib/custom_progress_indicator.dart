import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double size;
  CustomProgressIndicator({this.size = 50});

  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(
      color: Colors.red,
      size: size,
    );
  }
}
