class _RulesKeywords {
  _RulesKeywords._();

  static String get disallowJobPrefix => "${disallowKey}_$jobKey";
  static String get disallowActionPrefix => "${disallowKey}_$actionKey";

  static const String disallowKey = "disallow";
  static const String jobKey = "job";
  static const String actionKey = "action";
  static const String variableKey = "setvar";
  //static const String ... = "etc";

}

//disallow jobs

String disallowJob(String jobName) {
  return "${_RulesKeywords.disallowJobPrefix}_$jobName";
}

bool isDisallowJobRule(String rule) {
  return rule.startsWith(_RulesKeywords.disallowJobPrefix);
}

bool isJobDisallowed(String rule, String jobName) {
  if (!isDisallowJobRule(rule)) return false;

  if (rule.endsWith(jobName)) return true;

  return false;
}

//disallow actions

String disallowAction(String actionName) {
  return "${_RulesKeywords.disallowActionPrefix}_$actionName";
}

bool isDisallowActionRule(String rule) {
  return rule.startsWith(_RulesKeywords.disallowActionPrefix);
}

bool isActionDisallowed(String rule, String actionName) {
  if (!isDisallowJobRule(rule)) return false;

  if (rule.endsWith(actionName)) return true;

  return false;
}

//set variables

///
///[varname] is not allowed to have underscores.
///
///
String setVar(String varName) {
  if (varName.contains("_")) {
    throw Exception(
        "Varname $varName contains underscores! This is not allowed.");
  }

  return "${_RulesKeywords.variableKey}_$varName";
}

bool isSetVarRule(String rule) {
  return rule.startsWith(_RulesKeywords.variableKey);
}

bool isVar(String rule, String varName) {
  if (!isSetVarRule(rule)) return false;

  if (rule.endsWith(varName)) return true;

  return false;
}
