import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:island_project/data/preference_constants.dart';
import 'package:island_project/data/notification.dart' as notifications;
import 'package:island_project/data/userdata.dart';
import 'package:island_project/firebase_options.dart';
import 'package:island_project/layouts/primitive_layouts.dart';
import 'package:island_project/layouts/sign_in_page.dart';
import 'package:island_project/utilities/firebase_utilities.dart';
import 'package:island_project/utilities/navigation_utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicons/unicons.dart';

class MainDashboardPage extends StatefulWidget {
  const MainDashboardPage({super.key});

  @override
  State<MainDashboardPage> createState() => _MainDashboardPageState();
}

class _MainDashboardPageState extends State<MainDashboardPage> {
  final Future<FirebaseApp> _app =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  bool isSignedIn = false;

  StreamSubscription<User?>? _authStateChangeSub;

  List<Widget> appBarIcons() {
    return [
      BottomAppBarButton(
          iconData: Icons.holiday_village,
          onPressed: () => NavigationUtility.changeView(View.village, context),
          text: "Dorf"),
      BottomAppBarButton(
          iconData: Icons.account_balance_sharp,
          onPressed: () => NavigationUtility.changeView(View.law, context),
          text: "Gesetz"),
      BottomAppBarButton(
          iconData: Icons.logout,
          onPressed: () => FirebaseAuth.instance.signOut(),
          text: "Logout"),
      BottomAppBarButton(
          iconData: Icons.account_circle,
          onPressed: () => NavigationUtility.changeView(View.home, context),
          text: "Nach Hause")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return handleFirebaseInitialisation();
  }

  Widget handleFirebaseInitialisation() {
    var fb = FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasError) return const ErrorPage();

        if (snapshot.hasData) {
          _authStateChangeSub ??=
              FirebaseAuth.instance.authStateChanges().listen((user) {
            setState(() {
              isSignedIn = user != null;
            });
          });

          return handlePageLoading();
        }

        return const LoadingPage();
      },
      future: _app,
    );

    return fb;
  }

  Widget handlePageLoading() {
    //if we're signed in, no authentification is needed:
    if (isSignedIn) {
      return buildMainDashboard();
    }

    //otherwise, promt to sign in
    return const SignInPage();
  }

  Widget buildMainDashboard() {
    return Scaffold(
        bottomNavigationBar: buildBottomAppBar(icons: appBarIcons()),
        body: buildNotificationBoard());
  }

  BottomAppBar buildBottomAppBar({List<Widget>? icons}) {
    icons ??= [
      const SizedBox(
        height: 35,
      ),
    ];

    return BottomAppBar(
      clipBehavior: Clip.antiAlias,
      shape: const CircularNotchedRectangle(),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: icons),
    );
  }

  Widget buildNotificationBoard() {
    if (FirebaseAuth.instance.currentUser == null) {
      return const Text("Not signed In!");
    }

    print(FirebaseAuth.instance.currentUser!.uid);

    var contentLoader =
        FirebaseDatabase.instance.ref("notes").once().then((value) {
      var notes =
          notifications.Notification.parseFromSnapshot(value.snapshot).reversed;

      return ListView(
        children: notes.map((e) => NotificationCard(notification: e)).toList(),
      );
    });

    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data as Widget;
        }

        if (snapshot.hasError) {
          return Center(child: Text("An error occured: ${snapshot.error}"));
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: contentLoader,
    );
  }

  @override
  void dispose() {
    super.dispose();

    _authStateChangeSub?.cancel();
  }
}
