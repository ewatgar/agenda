import 'package:flutter/material.dart';

class BackgroundMessage extends StatelessWidget {
  const BackgroundMessage(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon});

  final Text title;
  final Text subtitle;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 20,
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [icon, title, subtitle],
      ),
    );
  }
}
