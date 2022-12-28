import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:island_project/data/laws/laws.dart';
import 'package:island_project/data/notification.dart' as notification;
import 'package:island_project/data/thing.dart';
import 'package:island_project/data/userdata.dart';
import 'package:island_project/layouts/primitive_layouts.dart';
import 'package:island_project/layouts/sign_in_page.dart';
import 'package:island_project/utilities/firebase_utilities.dart';
import 'package:island_project/data/jobs/jobs.dart';
import 'package:island_project/utilities/law_utility.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class ChooseJobMenu extends StatefulWidget {
  const ChooseJobMenu({super.key, required this.userData, this.onChooseJob});

  final UserData userData;
  final Function()? onChooseJob;

  @override
  State<ChooseJobMenu> createState() => _ChooseJobMenuState();
}

class _ChooseJobMenuState extends State<ChooseJobMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
        _buildJobDropdown(),
        JobDescription(job: Jobs.all[_dropdownValue ?? 0]),
        TextButton(
            style: Theme.of(context).textButtonTheme.style,
            onPressed: () {
              var userData = widget.userData;

              userData.job = Jobs.all[_dropdownValue ?? 0].jobName;

              FirebaseUtilities.instance.updateUserData(userData);

              widget.onChooseJob?.call();
            },
            child: Text(
              style: Theme.of(context).textTheme.button,
              "Job wählen",
            ))
      ],
    );
  }

  int? _dropdownValue = 0;

  Widget _buildJobDropdown() {
    //remove all jobs that are currently not allowed
    var jobs = Jobs.all
        .where((element) => !LawStack.instance.test(element.jobName))
        .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20,
        ),
        DropdownButton<int>(
          value: _dropdownValue,
          items: List.generate(jobs.length, (index) {
            return DropdownMenuItem(
                value: index,
                child: Row(
                  children: [
                    Icon(
                      jobs[index].iconData,
                    ),
                    Text(
                      "   ${jobs[index].displayName}",
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
}

class JobDescription extends StatelessWidget {
  const JobDescription({required this.job, super.key});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: NotificationCard(
          notification: notification.Notification("", job.description, 0),
          align: TextAlign.center),
    );
  }
}

class _HomeViewState extends State<HomeView> {
  bool _isSchedulingJob = false;

  @override
  Widget build(BuildContext context) {
    //only show something if the userdata is loaded AND the laws are synced
    var currentUserLoader =
        FirebaseUtilities.instance.getCurrentUserData().then((value) async {
      await LawStack.pull();
      return value;
    });

    return FutureBuilder(
      builder: (context, userSnapshot) {
        if (userSnapshot.hasData) {
          Widget body;

          if (userSnapshot.data!.job.isEmpty) {
            //if the user hasn't choosen his job yet, build the menu for doing so:

            body = ChooseJobMenu(
              userData: userSnapshot.data!,
              onChooseJob: () => setState(() {}),
            );
          } else {
            //if the user has already choosen his job, draw the actions he can execute, his current ressources, etc...

            var job = Jobs.getJobByName(userSnapshot.data!.job);
            UserData currentUser = userSnapshot.data!;

            if (job == null) return const ErrorPage();

            ///Change job if there's a trigger
            if (LawStack.instance.test(job.jobName)) {
              currentUser.job = "";

              FirebaseUtilities.instance.updateUserData(currentUser);

              return Scaffold(
                body: ChooseJobMenu(
                  userData: currentUser,
                  onChooseJob: () => setState(() {}),
                ),
                floatingActionButton: const ReturnFloatingActionButton(
                    arrowDirection: AxisDirection.right),
              );
            }

            var thingsLoader = FirebaseDatabase.instance
                .ref("things/${userSnapshot.data!.uid}")
                .once()
                .then((e) {
              if (!e.snapshot.exists) return null;

              return Things.fromSnapshot(e.snapshot);
            });

            body = FutureBuilder(
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
                    Text(job.displayName,
                        style: Theme.of(context).textTheme.displaySmall)
                  ]),
                  JobDescription(job: job),
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

                menu.addAll(_buildActionsMenu(
                    job, things.data ?? Things.empty(), currentUser));

                return ListView(children: menu);
              },
              future: thingsLoader,
            );
          }

          return Scaffold(
            body: body,
            floatingActionButton: const ReturnFloatingActionButton(
                arrowDirection: AxisDirection.right),
          );
        }

        return const LoadingPage();
      },
      future: currentUserLoader,
    );
  }

  List<Widget> _buildActionsMenu(Job job, Things things, UserData currentUser) {
    return job.getActions().actions.map((a) {
      DateTime lastActivation = currentUser.lastActivation == ""
          ? DateTime(0)
          : DateTime.parse(currentUser.lastActivation);
      DateTime now = DateTime.now();

      //cut hours and minutes from the last activation date and DateTiem.now to get the difference only for days:
      lastActivation = DateTime(
          lastActivation.year, lastActivation.month, lastActivation.day);

      now = DateTime(now.year, now.month, now.day);

      //difference comparison:

      int diff = lastActivation.difference(now).inDays.abs();

      bool isActivateable =
          a.isAllowed(currentUser, things) && !_isSchedulingJob && diff >= 1;

      debugPrint(
          "Last activation ${lastActivation.difference(DateTime.now()).inDays.abs()} ago.");

      return Card(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(a.displayName(),
                  style: Theme.of(context).textTheme.headline4),
              diff >= 1 && !_isSchedulingJob
                  ? TextButton(
                      onPressed: isActivateable
                          ? () {
                              a.activate(currentUser, things);
                              setState(() {
                                _isSchedulingJob = true;
                              });
                            }
                          : null,
                      style: Theme.of(context).textButtonTheme.style,
                      child: Text("Ausführen",
                          style: isActivateable
                              ? null
                              : Theme.of(context).textTheme.button?.apply(
                                  color: Theme.of(context).disabledColor)))
                  : CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    )
            ],
          ),
          a.requirements == null
              ? const SizedBox()
              : a.requirements!(currentUser, things),
        ]),
      ));
    }).toList();
  }
}
