import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:island_project/data/notification.dart' as notification;
import 'package:island_project/data/thing.dart';
import 'package:island_project/layouts/primitive_layouts.dart';
import 'package:island_project/layouts/sign_in_page.dart';
import 'package:island_project/utilities/firebase_utilities.dart';
import 'package:island_project/utilities/layout_utilities.dart';
import 'package:island_project/data/jobs/jobs.dart' as jobs;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseUtilities.instance.getCurrentUserData();

    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.job.isEmpty) {
            return buildScaffold("Zuhause",
                body: Column(
                  children: [
                    buildNotificationCard(notification.Notification(
                        "",
                        "Das ist dein |Zuhause|. Hier arbeitest du (in diesem Spiel gibt's nur HomeOffice...).",
                        0)),
                    const SizedBox(
                      height: 20,
                    ),
                    buildNotificationCard(
                        notification.Notification(
                            "",
                            "Als erstes musst du deinen |Beruf| wählen. Clicke dich dazu einfach durch den Dropdown (unten).[ENTER]Und keine Panik! Du kannst den Beruf später noch ändern.",
                            0),
                        textAlign: TextAlign.center),
                    buildJobDropdown(),
                    buildJobDescription(jobs.all[_dropdownValue ?? 0]),
                    TextButton(
                        style: StyleCollection.defaultButtonStyle,
                        onPressed: () {
                          var userData = snapshot.data!;

                          userData.job = jobs.all[_dropdownValue ?? 0].name;

                          FirebaseUtilities.instance.updateUserData(userData);

                          setState(() {});
                        },
                        child: Text(
                          style: StyleCollection.defaultTextStyle,
                          "Job wählen",
                        ))
                  ],
                ));
          } else {
            var job = jobs.getJobByName(snapshot.data!.job);

            var thingsLoader = FirebaseDatabase.instance
                .ref("things/${snapshot.data!.uid}")
                .once()
                .then((e) {
              if (!e.snapshot.exists) return null;

              return Things.fromSnapshot(e.snapshot);
            });

            if (job == null) return const ErrorPage();

            return FutureBuilder(
              builder: (context, things) {
                var menu = List.of([
                  buildNotificationCard(notification.Notification(
                      "",
                      "Das ist dein |Zuhause|. Hier arbeitest du (in diesem Spiel gibt's nur HomeOffice...).",
                      0)),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("Dein zurzeitiger Beruf:  ",
                        style: StyleCollection.defaultTextStyle),
                    Text(job.name,
                        style: GoogleFonts.sedgwickAveDisplay(
                            color: Colors.red[400], fontSize: 38))
                  ]),
                  buildJobDescription(job),
                  Text("Aktionen:", style: StyleCollection.header02TextStyle),
                ]);

                menu.addAll(
                    buildActionsMenu(job, things.data ?? Things.empty()));

                return buildScaffold("Zuhause",
                    body: ListView(
                      children: menu,
                    ));
              },
              future: thingsLoader,
            );
          }
        }

        return const LoadingPage();
      },
      future: currentUser,
    );
  }

  int? _dropdownValue = 0;

  Widget buildJobDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text(
        //   "Dein Job: ",
        //   style: StyleCollection.defaultTextStyle,
        // ),
        const SizedBox(
          height: 20,
        ),
        DropdownButton<int>(
          value: _dropdownValue,
          items: List.generate(jobs.all.length, (index) {
            return DropdownMenuItem(
                value: index,
                child: Row(
                  children: [
                    Icon(
                      jobs.all[index].iconData,
                    ),
                    Text(
                      "   ${jobs.all[index].name}",
                      style: StyleCollection.defaultTextStyle,
                    )
                  ],
                ));
          }),
          onChanged: (value) {
            setState(() {
              _dropdownValue = value;
            });
          },
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget buildJobDescription(jobs.Job job) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: buildNotificationCard(
          notification.Notification("", job.description, 0),
          textAlign: TextAlign.center),
    );
  }

  List<Widget> buildActionsMenu(jobs.Job job, Things things) {
    return job.getActions().map((a) {
      bool isActivateable = a.isActivateable(things);

      //print(isActivateable);

      return Card(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            a.actionName,
            style: GoogleFonts.sedgwickAveDisplay(
                color: Colors.red[400], fontSize: 35),
          ),
          TextButton(
            onPressed: isActivateable
                ? () {
                    //TODO: Implement job action.

                    //print("Pressed!!!");

                    a.activate();
                  }
                : null,
            style: isActivateable
                ? StyleCollection.defaultButtonStyle
                : StyleCollection.disabledButtonStyle,
            child: const Text("Ausführen"),
          )
        ]),
      ));
    }).toList();
  }
}
