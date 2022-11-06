import 'package:firebase_database/firebase_database.dart';
import 'package:island_project/data/preference_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  UserData(this.name, this.uid, {this.job = "", this.lastActivation = ""});

  String name;
  String uid;
  String job;
  String lastActivation;

  bool get isEmpty => name == "" && uid == "";

  ///Returns a dictionary of the serialized variables of this object.
  Map<String, Object?> serialize() {
    var res = {
      PreferenceConstants.prefnameUserName: name,
      PreferenceConstants.prefnameUserJob: job,
      PreferenceConstants.prefnameUserID: uid,
      PreferenceConstants.prefnameUserLastActivation: lastActivation
      //, "things": things
    };

    return res;
  }

  void serializeToSharedPrefs() {
    SharedPreferences.getInstance().then((prefs) {
      var keyvalues = serialize();

      for (var entry in keyvalues.entries) {
        prefs.setString(entry.key, (entry.value ?? "") as String);
      }
    });
  }

  static UserData fromSnapshot(DataSnapshot snapshot) {
    if (!snapshot.exists) {
      print("Snapshot did not exist!");
      return UserData.empty();
    }

    UserData data = UserData.empty();

    for (var child in snapshot.children) {
      if (child.key == PreferenceConstants.prefnameUserName) {
        data.name = child.value as String;
      }
      if (child.key == PreferenceConstants.prefnameUserID) {
        data.uid = child.value as String;
      }
      if (child.key == PreferenceConstants.prefnameUserJob) {
        data.job = child.value as String;
      }
      if (child.key == PreferenceConstants.prefnameUserLastActivation) {
        data.lastActivation = child.value as String;
      }
      //if (child.key == "things") data.things = child.value as String;
    }

    return data;
  }

  static UserData empty() {
    return UserData("", "");
  }

  //   });
  // }
}
