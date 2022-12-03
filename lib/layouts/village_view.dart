import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:island_project/data/userdata.dart';
import 'package:island_project/utilities/layout_utilities.dart';
import 'package:island_project/utilities/navigation_utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicons/unicons.dart';

class VillageView extends StatefulWidget {
  const VillageView({super.key});

  @override
  State<StatefulWidget> createState() => _VillageViewState();
}

class _VillageViewState extends State<VillageView> {
  List<UserData> _users = List.empty(growable: true);

  StreamSubscription<DatabaseEvent>? subscription;

  @override
  void initState() {
    super.initState();

    subscription?.cancel();

    subscription =
        FirebaseDatabase.instance.ref("users").onValue.listen((event) {
      var users = _updateUsers(event.snapshot);
      setState(() {
        _users = users;
      });
    });
  }

  List<UserData> _updateUsers(DataSnapshot snapshot) {
    print("Reload");

    List<UserData> users = List.empty(growable: true);

    for (var user in snapshot.children) {
      var usrData = UserData.fromSnapshot(user);

      if (usrData.isEmpty) continue;
      if (usrData.uid == FirebaseAuth.instance.currentUser?.uid) continue;

      users.add(usrData);
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> gridItems =
        List.generate(_users.length, growable: true, (index) {
      var icon = buildGridItem(() {
        NavigationUtility.changeToVillagerView(_users[index], context);
      }, Icons.accessibility_new,
          //color: ColorPalette.onSecondary,
          text: _users[index].name);
      return icon;
    });

    Random r = Random(42);

    List<Widget> obsticles = List.generate(gridItems.length * 2, (index) {
      switch (r.nextInt(2)) {
        case 0:
          return buildGridItem(null, UniconsLine.mountains,
              color: const Color.fromARGB(255, 78, 78, 78));

        default:
          return buildGridItem(null, null);
      }
    });

    gridItems.addAll(obsticles);

    r = Random(42);

    gridItems.shuffle(r);

    gridItems.insert(
        0,
        buildGridItem(() {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Info"),
                content: const Text(
                    "Das is euer Dorf. Hier kannst du handlen, usw... \nProbiere es einfach mal aus! Clicke auf verschiedene Icons, um zu sehen, was passiert."),
                actions: [
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              );
            },
          );
        }, UniconsLine.question_circle, color: Colors.red, text: "Info"));

    Widget gridView = Stack(
      children: [GridView.count(crossAxisCount: 4, children: gridItems)],
    );

    var scaffold = Scaffold(
        body: gridView,
        floatingActionButton: const ReturnFloatingActionButton());
    return scaffold;
  }

  @override
  void dispose() {
    super.dispose();

    subscription?.cancel();
  }
}
