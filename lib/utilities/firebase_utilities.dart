import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:island_project/data/userdata.dart';

class FirebaseUtilities {
  static FirebaseUtilities instance = FirebaseUtilities();

  // UserData? _currentUser;

  // UserData? get currentUser => _currentUser;

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
    print("CurrentUser: ${FirebaseAuth.instance.currentUser}");

    if (FirebaseAuth.instance.currentUser == null) return UserData.empty();

    var ref = FirebaseDatabase.instance
        .ref("users")
        .child(FirebaseAuth.instance.currentUser!.uid);

    return ref.once().then((event) {
      if (!event.snapshot.exists) {
        print("Snapshot does not exist");
        return UserData.empty();
      }
      return UserData.fromSnapshot(event.snapshot);
    });
  }

  ///Shortcut for:
  ///
  ///FirebaseDatabase.instance.ref().child("users").child(username);
  ///
  DatabaseReference referenceByUsername(String username) {
    var ref = FirebaseDatabase.instance.ref();

    return ref.child("users").child(username);
  }

  ///Uploads the data of a user to firebase.
  ///
  void updateUserData(UserData userData) {
    if (userData.isEmpty) {
      print("Error: Userdata is empty!");
      return;
    }

    var ref = FirebaseDatabase.instance.ref();

    ref
        .child("users")
        .child(userData.uid)
        .update(userData.serialize())
        .onError((error, stackTrace) => print(error));
  }
}
