part of 'jobs.dart';

class JobAction {
  const JobAction(
    this.actionName, {
    required this.displayName,
    this.onActivate,
    this.checkAllowance,
    this.iconData,
    this.requirements,
    //this.requirementIndicator
  });

  ///Action name should begin with "act_${...}"
  final String actionName;
  final IconData? iconData;
  final String Function() displayName;
  final Function(UserData user, Things things)? onActivate;
  final bool Function(UserData user, Things things)? checkAllowance;
  final RequirementLabel Function(UserData user, Things things)? requirements;
  //final Map<String, int>? requirements;
  // final Function<bool>()? requirementIndicator;

  Future? activate(UserData user, Things things) async {
    if (onActivate != null) {
      await onActivate!(user, things);
    }

    return null;
  }

  bool isAllowed(UserData user, Things things) {
    if (checkAllowance == null) return true;

    return checkAllowance!(user, things);
  }
}

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

final _buildHouseAction = JobAction(
  "act_build_house",
  displayName: () => "Haus bauen",
  onActivate: (user, things) {
    FirebaseUtilities.instance.setLastActivation();
  },
  iconData: UniconsLine.shovel,
);

final _huntAction = JobAction("act_hunt",
    displayName: () => "Jagen",
    onActivate: (user, things) {
      FirebaseUtilities.instance.setLastActivation();
    },
    iconData: Ionicons.locate);

final _placeTrapAction = JobAction(
  "act_place_trap",
  displayName: () => "Falle platzieren",
  onActivate: (user, things) {
    FirebaseUtilities.instance.setLastActivation();
  },
  iconData: Ionicons.locate,
  requirements: (user, things) {
    return RequirementLabel(
      requirements: [
        Requirement(ResourceName.shovel, 1,
            availiable: things.hasResources(ResourceName.shovel, 1))
      ],
    );
  },
// {
//   ResourceName.shovel: 1,
// }
);

///A collection of job actions
class ActionCollection {
  ActionCollection._();

  static ActionCollection instance = ActionCollection._();

  //to register an new action:

  //insert the created action instance
  //HERE:
  JobAction get buildHouseAction => _buildHouseAction;
  JobAction get huntAction => _huntAction;
  JobAction get placeTrapAction => _placeTrapAction;

  //AND HERE:
  final List<JobAction> all = [
    _buildHouseAction,
    _huntAction,
    _placeTrapAction
  ];
}
