import 'package:firebase_database/firebase_database.dart';

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
      if (child.key == "owner") thing.owner = child.value as String;

      if (child.key == "content") {
        var keys = child.children.map((e) => e.key ?? "");
        var counts = child.children.map((e) => e.value as int);

        thing.content = Map.fromIterables(keys, counts);
      }
    }

    return thing;
  }

  ///Returns a dictionary of the serialized variables of this object.
  Map<String, Object?> serialize() {
    var res = {"owner": owner, "content": content};

    return res;
  }

  static Things empty() {
    return Things("", Map.identity());
  }
}

class ResourceName {
  static const String gold = "GOLD";
  static const String wheat = "WHEAT";
  static const String apple = "APPLES";
  static const String shovel = "SHOVEL";
  static const String meat = "MEAT";
}
