import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:island_project/data/thing.dart';
import 'package:island_project/data/userdata.dart';
import 'package:island_project/layouts/primitive_layouts.dart';
import 'package:island_project/utilities/firebase_utilities.dart';
import 'package:unicons/unicons.dart';

part 'actions.dart';

///Static class for storing job data:
class Jobs {
  Jobs._();

  static Job? getJobByName(String jobName) {
    for (var job in all) {
      if (job.displayName == jobName) return job;
    }
    return null;
  }

  static List<Job> get all => [Hunter()];
}

///Inherit this class to create your own Job.
///
///
abstract class Job {
  String get jobName;
  String get displayName;
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
  String get jobName => "craftsmen";

  @override
  String get displayName => "Handwerker";

  @override
  JobActionsList getActions() {
    var actions = super.getActions();

    actions.addAction(ActionCollection.instance.buildHouseAction);

    return actions;
  }
}

class Hunter extends Job {
  @override
  String get jobName => "hunter";

  @override
  String get displayName => "Jäger";

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
