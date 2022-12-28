import 'dart:async';

import 'package:flutter/material.dart';
import 'package:island_project/data/jobs/jobs.dart';
import 'package:island_project/data/laws/law_cards.dart';
import 'package:island_project/layouts/primitive_layouts.dart';
import 'package:island_project/utilities/firebase_utilities.dart';
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
  static late LawStack instance;

  static Future pull() async {
    var laws = await FirebaseUtilities.instance.getLaws();

    instance = LawStack(laws);
  }

  static void push() {
    FirebaseUtilities.instance.updateLaws(instance.laws);
  }

  LawStack(this.laws);

  List<Law> laws = List.empty(growable: true);

  // void addLaw(Law rule) {
  //   laws.add(rule);
  // }

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

    ranking.remove(PoliticalSystem.none);

    return ranking.entries
        .reduce(
            (value, element) => value.value > element.value ? value : element)
        .key;
  }

  bool test(String expression) {
    for (var i = 0; i < laws.length; i++) {
      if (laws[i].check(expression, i)) return true;
    }

    return false;
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
      this.system = PoliticalSystem.none,
      this.data});

  final String lawName;
  final String Function()? displayName;

  ///Should return true if there's a trigger
  final bool Function(String expr, int lawstackIndex) check;
  final Function()? onStart;
  final Widget? Function(
      BuildContext context, int lawstackIndex, Function()? onDelete) buildCard;
  Map<String, String>? data;

  final PoliticalSystem system;

  void setData(Map<String, String> newData) => data = newData;

  //void onRegister(RuleStack stack);

  //if this triggers, return true
}

class Laws {
  Laws._();

  static Law get nationalisationLaw => _nationalisationLaw;
  static Law get disallowJobLaw => _disallowJobLaw;

  static final List<Law> laws = [_nationalisationLaw, _disallowJobLaw];
}

final _nationalisationLaw = Law("law_nationalisation",
    displayName: () => "Verstaatlichung",
    check: (expr, index) {
      return false;
    },
    buildCard: (context, lawstackIndex, onDelete) {
      return LawCard(
        onDelete: onDelete,
        system: PoliticalSystem.communism,
        title: "Verstaatlichung aller Eigentümer",
        children: const [Text("ALLES wird verstaatlicht.")],
      );
    },
    system: PoliticalSystem.communism);

final _disallowJobLaw = Law(
  "law_disallow_job",
  displayName: () => "Verbot von Beruf",
  check: (expr, index) {
    if (LawStack.instance.laws[index].data!["job"] == expr) return true;

    return false;
  },
  buildCard: (context, lawstackIndex, onDelete) {
    return DisallowJobCard(
      onDelete: onDelete,
      lawstackIndex: lawstackIndex,
    );
  },
);

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
