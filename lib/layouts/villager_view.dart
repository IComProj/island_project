import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:island_project/data/thing.dart';
import 'package:island_project/data/userdata.dart';
import 'package:island_project/utilities/layout_utilities.dart';

class VillagerView extends StatefulWidget {
  final UserData userData;

  const VillagerView(this.userData, {super.key});

  @override
  State<StatefulWidget> createState() => _VillagerViewState();
}

class _VillagerViewState extends State<VillagerView> {
  Things? ownedThings;

  StreamSubscription<DatabaseEvent>? subscription;

  @override
  void initState() {
    super.initState();

    //if (widget.userData.things == "") return;

    subscription = FirebaseDatabase.instance
        .ref("things/${widget.userData.uid}")
        .onValue
        .listen(_updateThings);
  }

  void _updateThings(DatabaseEvent event) {
    setState(() {
      ownedThings = Things.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime? lastActivation =
        DateTime.tryParse(widget.userData.lastActivation);

    lastActivation ?? DateTime(1313);

    return Scaffold(
        //"Dorfbewohner: ${widget.userData.name}",
        body: ListView(children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Card(
          elevation: 10,
          child: Column(
            children: [
              Text(
                "Infos:",
                //style: StyleCollection.defaultTextStyle,
              ),
              Text(
                  "Letzte Aktivität: ${lastActivation?.day}.${lastActivation?.month}.${lastActivation?.year}")
            ],
          ),
        ),
      ),
      buildResourceCard(ownedThings ?? Things.empty())
    ]));
  }

  @override
  void dispose() {
    super.dispose();

    subscription?.cancel();
  }
}
