import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:island_project/data/laws/laws.dart';
import 'package:island_project/data/thing.dart';
import 'package:island_project/data/userdata.dart';

class FirebaseUtilities {
  static FirebaseUtilities instance = FirebaseUtilities();

  ///Signs the user in.
  ///
  ///email: The user's email adress.
  ///
  ///password: The user's password.
  ///
  Future<UserCredential> signIn(String email, String password) async {
    var request = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      print("Error: $e");
    });

    return request;
  }

  ///Fetches the current user's data from firebase and returns a userData object.
  ///
  ///The object is empty when we aren't authenticated or the user doesn't exist in the database yet.
  ///
  Future<UserData> getCurrentUserData() async {
    if (kDebugMode) {
      print("CurrentUser: ${FirebaseAuth.instance.currentUser}");
    }

    if (FirebaseAuth.instance.currentUser == null) return UserData.empty();

    var ref = FirebaseDatabase.instance
        .ref("users")
        .child(FirebaseAuth.instance.currentUser!.uid);

    return ref.once().then((event) {
      if (!event.snapshot.exists) {
        if (kDebugMode) {
          print("Snapshot does not exist");
        }
        return UserData.empty();
      }
      return UserData.fromSnapshot(event.snapshot);
    });
  }

  ///Shortcut for:
  ///
  ///FirebaseDatabase.instance.ref().child("users").child(username);
  ///
  // DatabaseReference referenceByUsername(String username) {
  //   var ref = FirebaseDatabase.instance.ref();

  //   return ref.child("users").child(username);
  // }

  ///Changes the 'lastActivation' property of a userData to the current datetime.
  ///
  ///Calls [updateUserData] internally.
  Future<void> setLastActivation() async {
    UserData userData = await getCurrentUserData();

    userData.lastActivation = DateTime.now().toIso8601String();

    updateUserData(userData);
  }

  ///Uploads the data of a user to firebase.
  ///
  void updateUserData(UserData userData) {
    if (userData.isEmpty) {
      if (kDebugMode) {
        print("Error: Userdata is empty!");
      }
      return;
    }

    var ref = FirebaseDatabase.instance.ref();

    ref
        .child("users")
        .child(userData.uid)
        .update(userData.serialize())
        .onError((error, stackTrace) => print(error));
  }

  void updateThings(Things things) {
    if (things.isEmpty) {
      if (kDebugMode) {
        print("Things are empty!");
      }
      return;
    }

    var ref = FirebaseDatabase.instance.ref();

    ref
        .child("things")
        .child(things.owner)
        .update(things.serialize())
        .onError((error, stackTrace) => print(error));
  }

  Future<List<Law>> getLaws() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    ref = ref.child("laws");

    var event = await ref.once();

    return List.generate(event.snapshot.children.length, (index) {
      var lawSnapshot = event.snapshot.children.elementAt(index);

      // for (var lawSnapshot in event.snapshot.children) {
      var lawName = lawSnapshot.child("lawName").value as String;

      Law lawInstance =
          Laws.laws.where((element) => element.lawName == lawName).first;

      var data = {
        for (var data in lawSnapshot.child("data").children)
          data.key as String: data.value as String
      };

      lawInstance.setData(data);
      //}

      return lawInstance;
    });
  }

  void updateLaws(List<Law> laws) {
    var ref = FirebaseDatabase.instance.ref("laws");

    Map m = {};

    for (var i = 0; i < laws.length; i++) {
      var lawName = laws[i].lawName;

      var data = {for (var data in laws[i].data!.entries) data.key: data.value};

      m[i] = {"data": data, "lawName": lawName};
    }

    ref.set(m);
  }
}
