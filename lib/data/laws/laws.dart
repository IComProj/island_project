import 'package:flutter/material.dart';

enum PoliticalSystem { democracy, anarchy, moarchy, communism }

extension PoliticalSystemExtentions on PoliticalSystem {
  Color getColorForSystem() {
    switch (this) {
      case PoliticalSystem.anarchy:
        return Colors.red;
      case PoliticalSystem.democracy:
        return Colors.blue;
      case PoliticalSystem.moarchy:
        return Colors.amber;
      case PoliticalSystem.communism:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class LawData {
  List<Paragraph> paragraphs = List.empty();

  ///stub
  PoliticalSystem getTypeOfSystem() {
    return PoliticalSystem.anarchy;
  }
}

class Paragraph {
  Paragraph(this.rule);

  String rule;

  Map<String, Object> serialize() {
    return {};
  }
}
