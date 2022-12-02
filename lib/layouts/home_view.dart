import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:island_project/data/notification.dart' as notification;
import 'package:island_project/data/thing.dart';
import 'package:island_project/data/userdata.dart';
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
  bool isSchedulingJob = false;

  @override
  Widget build(BuildContext context) {
    var currentUserLoader = FirebaseUtilities.instance.getCurrentUserData();

    return FutureBuilder(
      builder: (context, userSnapshot) {
        if (userSnapshot.hasData) {
          if (userSnapshot.data!.job.isEmpty) {
            //if the user hasn't choosen his job yet, build the menu for doing so:
            return Scaffold(
                floatingActionButton: const ReturnFloatingActionButton(),
                body: Column(
                  children: [
                    NotificationCard(
                        notification: notification.Notification(
                            "",
                            "Das ist dein |Zuhause|. Hier arbeitest du (in diesem Spiel gibt's nur HomeOffice...).",
                            0)),
                    const SizedBox(
                      height: 20,
                    ),
                    NotificationCard(
                        notification: notification.Notification(
                            "",
                            "Als erstes musst du deinen |Beruf| wählen. Clicke dich dazu einfach durch den Dropdown (unten).[ENTER]Und keine Panik! Du kannst den Beruf später noch ändern.",
                            0),
                        align: TextAlign.center),
                    buildJobDropdown(),
                    buildJobDescription(jobs.all[_dropdownValue ?? 0]),
                    TextButton(
                        style: Theme.of(context).textButtonTheme.style,
                        onPressed: () {
                          var userData = userSnapshot.data!;

                          userData.job = jobs.all[_dropdownValue ?? 0].name;

                          FirebaseUtilities.instance.updateUserData(userData);

                          setState(() {});
                        },
                        child: Text(
                          style: Theme.of(context).textTheme.button,
                          "Job wählen",
                        ))
                  ],
                ));
          } else {
            //if the user has already choosen his job, draw the actions he can execute, his current ressources, etc...

            var job = jobs.getJobByName(userSnapshot.data!.job);
            UserData currentUser = userSnapshot.data!;

            if (job == null) return const ErrorPage();

            var thingsLoader = FirebaseDatabase.instance
                .ref("things/${userSnapshot.data!.uid}")
                .once()
                .then((e) {
              if (!e.snapshot.exists) return null;

              return Things.fromSnapshot(e.snapshot);
            });

            return FutureBuilder(
              builder: (context, things) {
                var menu = List.of([
                  NotificationCard(
                      notification: notification.Notification(
                          "",
                          "Das ist dein |Zuhause|. Hier arbeitest du (in diesem Spiel gibt's nur HomeOffice...).",
                          0)),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("Dein zurzeitiger Beruf:  ",
                        style: Theme.of(context).textTheme.headline5),
                    Text(job.name,
                        style: Theme.of(context).textTheme.displaySmall)
                  ]),
                  buildJobDescription(job),
                  Text(
                    "Aktionen",
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                  ),
                  NotificationCard(
                      notification: notification.Notification(
                          "",
                          "Du kannst jeden Tag nur |eine Aktion| ausführen. Die Resourcenangaben unter den jeweiligen Aktionen geben den Preis an - was die Aktion dann macht, nusst du |selbst herausfinden|!",
                          0))
                ]);

                menu.addAll(buildActionsMenu(
                    job, things.data ?? Things.empty(), currentUser));

                return Scaffold(
                  floatingActionButton: const ReturnFloatingActionButton(),
                  body: ListView(children: menu),
                );
              },
              future: thingsLoader,
            );
          }
        }

        return const LoadingPage();
      },
      future: currentUserLoader,
    );
  }

  int? _dropdownValue = 0;

  Widget buildJobDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
                      style: Theme.of(context).textTheme.headline5,
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
      child: NotificationCard(
          notification: notification.Notification("", job.description, 0),
          align: TextAlign.center),
    );
  }

  List<Widget> buildActionsMenu(
      jobs.Job job, Things things, UserData currentUser) {
    return job.getActions().map((a) {
      DateTime lastActivation = DateTime.parse(currentUser.lastActivation);
      bool isActivateable = a.isActivateable(things) &&
          !isSchedulingJob &&
          lastActivation.difference(DateTime.now()).inDays.abs() >= 1;

      print(
          "Last activation ${lastActivation.difference(DateTime.now()).inDays.abs()} ago.");

      TextStyle? resourceNotAvailiableTextStyle = Theme.of(context)
          .textTheme
          .bodySmall; //const TextStyle(color: Colors.red);

      List<Widget> requiredResourcesLabels =
          a.requirements?.entries.map((entry) {
                bool hasResource = things.hasResources(entry.key, entry.value);

                return Row(children: [
                  ResourceName.getIconForResource(entry.key),
                  Text(
                    "${entry.key}:",
                    style: hasResource ? null : resourceNotAvailiableTextStyle,
                  ),
                  Text(
                    "${entry.value}  ",
                    style: hasResource ? null : resourceNotAvailiableTextStyle,
                  ),
                ]);
              }).toList() ??
              List.empty();

      return Card(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(a.actionName,
                  style: Theme.of(context)
                      .textTheme
                      .headline4 //GoogleFonts.oswald(color: Colors.red[400], fontSize: 35),
                  ),
              lastActivation.difference(DateTime.now()).inDays.abs() >= 1
                  ? TextButton(
                      onPressed: isActivateable
                          ? () {
                              setState(() {
                                isSchedulingJob = true;
                              });
                              a.activate();
                            }
                          : null,
                      style: Theme.of(context).textButtonTheme.style,
                      child: Text("Ausführen",
                          style: isActivateable
                              ? null
                              : Theme.of(context).textTheme.button?.apply(
                                  color: Theme.of(context).disabledColor)))
                  : const CircularProgressIndicator(
                      color: Colors.grey,
                    )
            ],
          ),
          Row(
            children: requiredResourcesLabels,
          )
        ]),
      ));
    }).toList();
  }
}
