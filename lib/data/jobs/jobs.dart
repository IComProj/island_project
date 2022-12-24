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

  static List<Job> get all => [Hunter(), Explorer()];
}

///Inherit this class to create your own Job.
///
///
abstract class Job {
  ///Should begin with: "job_"
  ///
  ///So name jobs like this:
  ///
  ///"job_${your job name HERE}"
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
  String get jobName => "job_craftsmen";

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
  String get jobName => "job_hunter";

  @override
  String get displayName => "Jäger";

  @override
  IconData? get iconData => UniconsLine.crosshair;

  @override
  String get description =>
      "Als Jäger/in kümmerst du dich um die Versorgung. Du weißt: Nur Fleisch macht Fleisch!";

  @override
  JobActionsList getActions() {
    var actions = super.getActions();

    actions.addAction(ActionCollection.instance.huntAction);
    actions.addAction(ActionCollection.instance.placeTrapAction);

    return actions;
  }
}

class Explorer extends Job {
  @override
  String get displayName => "Späher";

  @override
  String get jobName => "job_explorer";

  @override
  IconData? get iconData => Icons.explore_outlined;

  @override
  String get description =>
      "Als Späher/in erkundest du das Land. Du hast die Chance, Reichtümer, Gold und andere Wertgegenstände, aber auch Gefahren zu finden.";

  @override
  JobActionsList getActions() {
    var actions = super.getActions();

    //TODO: Implement actions...

    return actions;
  }
}
