import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:island_project/data/preference_constants.dart';
import 'package:unicons/unicons.dart';

class Things {
  Things(this.owner, this.content);

  Map<String, int> content;
  String owner;

  bool get isEmpty => owner == "" || content.isEmpty;

  static Things fromSnapshot(DataSnapshot snapshot) {
    if (!snapshot.exists) {
      return Things.empty();
    }

    Things thing = Things.empty();

    for (var child in snapshot.children) {
      if (child.key == PreferenceConstants.thingsOwnerID) {
        thing.owner = child.value as String;
      }

      if (child.key == PreferenceConstants.thingsContentParent) {
        var keys = child.children.map((e) => e.key ?? "");
        var counts = child.children.map((e) => e.value as int);

        thing.content = Map.fromIterables(keys, counts);
      }
    }

    return thing;
  }

  ///Returns a dictionary of the serialized variables of this object.
  Map<String, Object?> serialize() {
    var res = {
      PreferenceConstants.thingsOwnerID: owner,
      PreferenceConstants.thingsContentParent: content
    };

    return res;
  }

  static Things empty() {
    return Things("", Map.identity());
  }

  ///Checks if the current things have resources of a specific count or more.
  bool hasResources(String resourceName, int resourceCount) {
    if (!content.containsKey(resourceName)) return false;

    int ownedResourceCount = content[resourceName] ?? 0;

    if (ownedResourceCount >= resourceCount) return true;

    return false;
  }
}

class ResourceName {
  //static class --> no constructor

  ResourceName._();

  static const String gold = "GOLD";
  static const String wheat = "GETREIDE";
  static const String apple = "ÄPFEL";
  static const String shovel = "SCHAUFEL";
  static const String meat = "FLEISCH";

  static Icon getIconForResource(String resourceName) {
    switch (resourceName) {
      case ResourceName.gold:
        return const Icon(
          UniconsLine.dollar_alt,
          color: Colors.amber,
        );
      case ResourceName.apple:
        return const Icon(
          Icons.apple,
          color: Colors.red,
        );
      case ResourceName.shovel:
        return const Icon(
          UniconsLine.shovel,
          color: Colors.blueGrey,
        );
      case ResourceName.wheat:
        return const Icon(
          UniconsLine.trees,
          color: Colors.yellow,
        );
      case ResourceName.meat:
        return Icon(Ionicons.fast_food, color: Colors.amber[700]);

      default:
        return const Icon(UniconsLine.gold);
    }
  }
}
