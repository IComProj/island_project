part of 'jobs.dart';

///A list of job actions
class JobActionsList {
  JobActionsList();

  List<JobAction> get actions => _actions;

  final List<JobAction> _actions = List.empty(growable: true);

  void addAction(JobAction action) {
    if (!_actions.contains(action)) {
      _actions.add(action);
    }
  }
}

///A collection of job actions
class ActionCollection {
  ActionCollection._();

  static ActionCollection instance = ActionCollection._();

  JobAction get buildHouseAction => all[0]!;
  JobAction get huntAction => all[1]!;
  JobAction get placeTrapAction => all[2]!;

  //TODO: Solve update anomaly
  final Map<int, JobAction> all = {
    0: _buildHouseAction,
    1: _huntAction,
    2: _placeTrapAction
  };
}

final _buildHouseAction = JobAction(
  "Haus bauen",
  onActivate: () {
    FirebaseUtilities.instance.setLastActivation();
  },
  requirements: {},
  iconData: UniconsLine.shovel,
);

final _huntAction = JobAction("Jagen", onActivate: () {
  FirebaseUtilities.instance.setLastActivation();
}, iconData: Ionicons.locate, requirements: {});

final _placeTrapAction = JobAction("Place Trap", onActivate: () {
  FirebaseUtilities.instance.setLastActivation();
}, iconData: Ionicons.locate, requirements: {
  ResourceName.shovel: 1,
});
