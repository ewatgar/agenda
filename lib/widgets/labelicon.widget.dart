// ignore_for_file: prefer_const_constructors

import 'package:agenda/models/label.enum.dart';
import 'package:flutter/material.dart';

class LabelIcon extends StatelessWidget {
  const LabelIcon({super.key, this.labels, this.size});

  final List<String>? labels;
  final double? size;

  @override
  Widget build(BuildContext context) {
    (labels ?? []).sort((a, b) => Label.parse(a).compareTo(Label.parse(b)));
    Label labelPriority = Label.parse(labels?[0] ?? 'other');

    return switch (labelPriority) {
      Label.pareja => Icon(Icons.favorite, size: size),
      Label.amistad => Icon(Icons.emoji_emotions, size: size),
      Label.familia => Icon(Icons.family_restroom, size: size),
      Label.trabajo => Icon(Icons.work, size: size),
      Label.deporte => Icon(Icons.fitness_center, size: size),
      Label.other => Icon(Icons.person, size: size),
    };
  }
}
