import 'package:flutter/material.dart';
import 'package:island_project/data/userdata.dart';
import 'package:island_project/layouts/home_view.dart';
import 'package:island_project/layouts/sign_in_page.dart';
import 'package:island_project/layouts/village_view.dart';
import 'package:island_project/layouts/villager_view.dart';

enum View { village, law, login, home }

void changeView(View view, BuildContext currentContext) {
  if (view == View.village) {
    Navigator.push(currentContext,
        constructPageRouteBuilder(const VillageView(), const Offset(-1, 0)));
  } else if (view == View.law) {
  } else if (view == View.home) {
    Navigator.push(currentContext,
        constructPageRouteBuilder(const HomeView(), const Offset(1, 0)));
  } else if (view == View.login) {
    Navigator.pushReplacement(currentContext,
        constructPageRouteBuilder(const SignInPage(), const Offset(0, -1)));
  }
}

void changeToVillagerView(UserData userData, BuildContext context) {
  Navigator.push(context,
      constructPageRouteBuilder(VillagerView(userData), const Offset(-1, 0)));
}

PageRouteBuilder constructPageRouteBuilder(Widget target, Offset startOffset) {
  return PageRouteBuilder(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: startOffset, end: Offset.zero).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeIn,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return target;
      });
}
