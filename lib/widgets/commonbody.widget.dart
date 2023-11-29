import 'package:flutter/material.dart';

class CommonBody extends StatelessWidget {
  final Widget child;
  const CommonBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              theme.colorScheme.background,
              theme.colorScheme.secondary.withAlpha(100)
            ])),
        child: Container(alignment: Alignment.topCenter, child: child));
  }
}
