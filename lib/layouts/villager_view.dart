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
    return buildScaffold("Dorfbewohner: ${widget.userData.name}",
        body: ListView(
            children: [buildResourceCard(ownedThings ?? Things.empty())]));
  }

  @override
  void dispose() {
    super.dispose();

    subscription?.cancel();
  }
}
