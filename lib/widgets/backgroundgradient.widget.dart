// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  final Widget child;
  final Color primary;
  final Color background;
  const BackgroundGradient(
      {super.key,
      required this.child,
      required this.primary,
      required this.background});

  @override
  Widget build(BuildContext context) {
    return Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [background, primary],
        )),
        child: Container(alignment: Alignment.topCenter, child: child));
  }
}
