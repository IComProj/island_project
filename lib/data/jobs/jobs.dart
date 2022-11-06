import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:island_project/data/thing.dart';
import 'package:unicons/unicons.dart';

class JobAction {
  JobAction(this.actionName,
      {this.onActivate, this.iconData, this.requirements});
  String actionName;
  Function()? onActivate;
  IconData? iconData;
  Map<String, int>? requirements;

  void activate() {
    if (onActivate != null) {
      onActivate!();
    }
  }

  bool isActivateable(Things things) {
    //print(requirements);

    if (requirements == null) return true;

    for (var requiredResource in requirements!.entries) {
      String resourceName = requiredResource.key;

      //print("${things.content[resourceName]} : ${requiredResource.value}");

      if (!things.content.containsKey(resourceName)) return false;

      if (things.content[resourceName]! < requiredResource.value) return false;
    }

    return true;
  }
}

abstract class Job {
  String name = "";
  IconData? iconData;
  String description = "";

  List<JobAction> getActions() {
    return List.empty();
  }
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
  List<JobAction> getActions() {
    var huntAction =
        JobAction("Jagen", onActivate: () {}, iconData: Ionicons.locate);

    List<JobAction> result = List.from([huntAction]);

    result.addAll(super.getActions());

    return result;
  }
}

List<Job> get all => [Hunter()];

Job? getJobByName(String jobName) {
  for (var job in all) {
    if (job.name == jobName) return job;
  }
  return null;
}
