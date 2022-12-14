part of 'jobs.dart';

class JobAction {
  const JobAction(this.actionName,
      {this.displayName,
      this.onActivate,
      this.checkAllowance,
      this.iconData,
      this.requirements,
      this.requirementIndicator});
  final String actionName;
  final IconData? iconData;
  final String Function()? displayName;
  final Function(UserData, Things)? onActivate;
  final bool Function(UserData, Things)? checkAllowance;
  final Map<String, int>? requirements;
  final Function<bool>()? requirementIndicator;

  void activate(UserData user, Things things) {
    if (onActivate != null) {
      onActivate!(user, things);
    }
  }

  bool isAllowed(UserData user, Things things) {
    if (checkAllowance == null) return true;

    return checkAllowance!(user, things);
  }

  // bool isActivateable(Things things) {
  //   if (requirements == null) return true;

  //   for (var requiredResource in requirements!.entries) {
  //     String resourceName = requiredResource.key;

  //     if (!things.content.containsKey(resourceName)) return false;

  //     if (things.content[resourceName]! < requiredResource.value) return false;
  //   }

  //   //we are through the loop: means we can de custom validation

  //   if (requirementIndicator != null) {
  //     return requirementIndicator!();
  //   }

  //   return true;
  // }
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
  onActivate: (user, things) {
    FirebaseUtilities.instance.setLastActivation();
  },
  requirements: {},
  iconData: UniconsLine.shovel,
);

final _huntAction = JobAction("act_hunt", onActivate: (user, things) {
  FirebaseUtilities.instance.setLastActivation();
}, iconData: Ionicons.locate, requirements: {});

final _placeTrapAction =
    JobAction("act_place_trap", onActivate: (user, things) {
  FirebaseUtilities.instance.setLastActivation();
}, iconData: Ionicons.locate, requirements: {
  ResourceName.shovel: 1,
});

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
