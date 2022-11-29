import 'package:flutter/material.dart';
import 'package:island_project/utilities/layout_utilities.dart';
import 'package:island_project/utilities/navigation_utilities.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var errorPage = buildScaffold("Error",
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            "An error occured!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextButton(
              onPressed: () {
                NavigationUtility.changeView(View.login, context);
              },
              style: StyleCollection.defaultButtonStyle,
              child: const Text("Try again"))
        ])));
    return errorPage;
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    var loadingPage = buildScaffold("Loading...",
        body: const Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          color: Colors.green,
        )));

    return loadingPage;
  }
}
