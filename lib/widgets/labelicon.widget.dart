// ignore_for_file: prefer_const_constructors

import 'package:agenda/models/label.enum.dart';
import 'package:flutter/material.dart';

class LabelIcon extends StatelessWidget {
  const LabelIcon({super.key, this.labels});

  final List<String>? labels;

  @override
  Widget build(BuildContext context) {
    (labels ?? []).sort((a, b) => Label.parse(a).compareTo(Label.parse(b)));
    Label labelPriority = Label.parse(labels?[0] ?? 'other');

    return switch (labelPriority) {
      Label.pareja => Icon(Icons.favorite),
      Label.amistad => Icon(Icons.emoji_emotions),
      Label.familia => Icon(Icons.family_restroom),
      Label.trabajo => Icon(Icons.work),
      Label.deporte => Icon(Icons.fitness_center),
      Label.other => Icon(Icons.person),
    };
  }
}
