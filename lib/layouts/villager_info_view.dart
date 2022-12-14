import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:island_project/data/thing.dart';
import 'package:island_project/data/userdata.dart';
import 'package:island_project/layouts/primitive_layouts.dart';

class VillagerInfoView extends StatefulWidget {
  final UserData userData;

  const VillagerInfoView(this.userData, {super.key});

  @override
  State<StatefulWidget> createState() => _VillagerInfoViewState();
}

class _VillagerInfoViewState extends State<VillagerInfoView> {
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
        appBar: AppBar(title: Text("Dorfbewohner: ${widget.userData.name}")),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              elevation: 10,
              child: Column(
                children: [
                  Text(
                    "Infos",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                      "Letzte Aktivität: ${lastActivation?.day ?? "00"}.${lastActivation?.month ?? "00"}.${lastActivation?.year ?? "0000"}"),
                  Text(
                      "Beruf: ${widget.userData.job == "" ? "Arbeitslos" : widget.userData.job}")
                ],
              ),
            ),
          ),
          ResourceCard(things: ownedThings ?? Things.empty())
        ]));
  }

  @override
  void dispose() {
    super.dispose();

    subscription?.cancel();
  }
}
