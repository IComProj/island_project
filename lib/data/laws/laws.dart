import 'dart:async';

import 'package:flutter/material.dart';
import 'package:island_project/utilities/law_utility.dart' as utils;

enum PoliticalSystem { democracy, anarchy, monarchy, communism, none }

extension PoliticalSystemExtentions on PoliticalSystem {
  Color getColorForSystem() {
    switch (this) {
      case PoliticalSystem.anarchy:
        return Colors.red;
      case PoliticalSystem.democracy:
        return Colors.blue;
      case PoliticalSystem.monarchy:
        return Colors.amber;
      case PoliticalSystem.communism:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getNameForSystem() {
    switch (this) {
      case PoliticalSystem.anarchy:
        return "Anarchie";
      case PoliticalSystem.democracy:
        return "Demokratie";
      case PoliticalSystem.monarchy:
        return "Monarchie";
      case PoliticalSystem.communism:
        return "Kommunismus";
      default:
        return "Nix";
    }
  }
}

class LawStack {
  //TODO: Deserialisation
  static LawStack instance = LawStack([]);

  LawStack(this.laws);

  List<Law> laws = List.empty(growable: true);

  void addLaw(Law rule) {
    laws.add(rule);
  }

  ///stub
  PoliticalSystem getTypeOfSystem() {
    //PoliticalSystem.values.

    if (laws.isEmpty) return PoliticalSystem.anarchy;

    var ranking = {
      for (var element in PoliticalSystem.values)
        element: 0 //PoliticalSystem.values.indexOf(element);
    };

    for (var rule in laws) {
      ranking[rule.system] = ranking[rule.system]! + 1;
    }

    return ranking.entries
        .reduce(
            (value, element) => value.value > element.value ? value : element)
        .key;
  }
}

//enum RuleOperator { disallow, constant, none }

///The rule object. With this, you can check for allowances, constants, etc...
class Law {
  Law(this.lawName,
      {required this.displayName,
      required this.check,
      this.onStart,
      required this.buildCard,
      this.system = PoliticalSystem.none});

  final String lawName;
  final String Function()? displayName;

  ///Should return true if there's a trigger
  final bool Function(String expr) check;
  final Function()? onStart;
  final Widget? Function() buildCard;

  final PoliticalSystem system;

  //void onRegister(RuleStack stack);

  //if this triggers, return true
}

class Laws {
  Laws._();

  static Law get nationalisationLaw => _nationalisationLaw;

  static final List<Law> laws = [_nationalisationLaw];
}

final _nationalisationLaw = Law("law_nationalisation",
    displayName: () => "Verstaatlichung",
    check: (expr) {
      return false;
    },
    buildCard: () {
      return const Text("Verstaatlichung");
    },
    system: PoliticalSystem.communism);

// class NationalisationRule extends Law {
//   //@override
//   //void onRegister(RuleStack stack) {}

//   @override
//   PoliticalSystem get system => PoliticalSystem.communism;

//   @override
//   bool check(String expression) {
//     if (utils.isVar(expression, RuleVariables.nationalizationVar.varName)) {
//       //trigger!
//       return true;
//     }

//     return false;
//   }
// }

// class RuleVar {
//   const RuleVar(this.varName, this.description, this.systemType);

//   final PoliticalSystem systemType;
//   final String varName;
//   final String description;
// }

// class RuleVariables {
//   static const RuleVar nationalizationVar = RuleVar(
//       "Verstaatlichung jedes Eigentums",
//       "Alles, was irgendwie erwirtschaftet wird, erhält der Staat.",
//       PoliticalSystem.communism);
// }
