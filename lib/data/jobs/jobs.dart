import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:island_project/data/thing.dart';
import 'package:island_project/utilities/firebase_utilities.dart';
import 'package:unicons/unicons.dart';

part 'actions.dart';

class JobAction {
  const JobAction(this.actionName,
      {this.onActivate,
      this.iconData,
      this.requirements,
      this.requirementIndicator});
  final String actionName;
  final Function()? onActivate;
  final IconData? iconData;
  final Map<String, int>? requirements;
  final Function<bool>()? requirementIndicator;

  void activate() {
    if (onActivate != null) {
      onActivate!();
    }
  }

  bool isActivateable(Things things) {
    if (requirements == null) return true;

    for (var requiredResource in requirements!.entries) {
      String resourceName = requiredResource.key;

      if (!things.content.containsKey(resourceName)) return false;

      if (things.content[resourceName]! < requiredResource.value) return false;
    }

    //we are through the loop: means we can de custom validation

    if (requirementIndicator != null) {
      return requirementIndicator!();
    }

    return true;
  }
}

///Static class for storing job data:
class Jobs {
  Jobs._();

  static Job? getJobByName(String jobName) {
    for (var job in all) {
      if (job.name == jobName) return job;
    }
    return null;
  }

  static List<Job> get all => [Hunter()];
}

///Inherit this class to create your own Job.
///
///
abstract class Job {
  String get name;
  IconData? iconData;
  String get description =>
      "Diesen  Text solltest du eigentlich nicht sehen. Bitte teile das deinen Projektleiter mit!";

  JobActionsList getActions() {
    return JobActionsList();
  }
}

///Provides basic actions everyone can execute like building a house,...
class Craftsmen extends Job {
  @override
  JobActionsList getActions() {
    var actions = super.getActions();

    actions.addAction(ActionCollection.instance.buildHouseAction);

    return actions;
  }

  @override
  String get name => "Handwerker";
}

class Hunter extends Job {
  @override
  String get name => "Jäger";

  @override
  IconData? get iconData => UniconsLine.crosshair;

  @override
  String get description =>
      "Als Jäger kümmerst du dich um die Versorgung. Du weißt: Nur Fleisch macht Fleisch!";

  @override
  JobActionsList getActions() {
    var actions = super.getActions();

    actions.addAction(ActionCollection.instance.huntAction);
    actions.addAction(ActionCollection.instance.placeTrapAction);

    return actions;
  }
}
