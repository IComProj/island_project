import 'dart:math';

import 'package:flutter/material.dart';
import 'package:island_project/data/laws/laws.dart';
import 'package:island_project/data/thing.dart';
import 'package:island_project/data/notification.dart' as notifications;
import 'package:island_project/utilities/navigation_utilities.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var errorPage = Scaffold(
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
          style: Theme.of(context).textButtonTheme.style,
          child: Text(
            "Try again",
            style: Theme.of(context).textTheme.button,
          ))
    ])));
    return errorPage;
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  static const List<String> loadingSlogans = [
    "Festplatte wird zerlegt...",
    "Trojaner werden heruntergeladen...",
  ];

  @override
  Widget build(BuildContext context) {
    var r = Random();

    String randomSlogan = loadingSlogans[r.nextInt(loadingSlogans.length)];

    var loadingPage = Scaffold(
        body: Center(
            child: Column(
      children: [
        CircularProgressIndicator(
            // backgroundColor: Colors.transparent,
            // color: Colors.green,
            ),
        Text(randomSlogan)
      ],
    )));

    return loadingPage;
  }
}

class GridImageItem extends StatelessWidget {
  const GridImageItem(
      {super.key, this.onPressed, this.iconData, this.color, this.text});

  final Function()? onPressed;
  final IconData? iconData;
  final Color? color;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: color,
              size: 60,
            ),
            text != null
                ? Text(
                    text ?? "",
                    //style: StyleCollection.secondaryTextStyle,
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  )
          ],
        ));
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard(
      {Key? key, required this.notification, this.align = TextAlign.start})
      : super(key: key);

  final notifications.Notification notification;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> markedText = List.empty(growable: true);
    var splitted = notification.message.split("|");

    bool markText = false;

    for (var element in splitted) {
      markedText.add(TextSpan(
          text: element.replaceAll("[ENTER]", "\n"),
          style: markText
              ? Theme.of(context)
                  .textTheme
                  .headline6
                  ?.apply(color: Colors.amber)
              : null));

      markText = !markText;
    }

    return Card(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                notification.iconID == 0 || notification.message == ""
                    ? const SizedBox(
                        height: 0,
                        width: 0,
                      )
                    : Row(children: [
                        Icon(
                          IconData(notification.iconID,
                              fontFamily: "MaterialIcons"),
                          size: 30,
                        ),
                        const Spacer(),
                        Text(
                          notification.modificationDate,
                        )
                      ]),
                RichText(
                  textAlign: align,
                  text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: markedText),
                ),
              ],
            )));
  }
}

class ReturnFloatingActionButton extends StatelessWidget {
  const ReturnFloatingActionButton(
      {super.key, this.arrowDirection = AxisDirection.left});

  final AxisDirection arrowDirection;

  @override
  Widget build(BuildContext context) {
    IconData arrow;

    switch (arrowDirection) {
      case AxisDirection.down:
        arrow = Icons.arrow_drop_down;
        break;

      case AxisDirection.up:
        arrow = Icons.arrow_drop_up;
        break;

      case AxisDirection.right:
        arrow = Icons.arrow_right;
        break;

      case AxisDirection.left:
        arrow = Icons.arrow_left;
        break;
      default:
        arrow = Icons.arrow_left;
    }

    return FloatingActionButton(
      mini: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      onPressed: () => Navigator.of(context).pop(),
      child: Icon(
        arrow,
        size: 30,
      ),
    );
  }
}

class BottomAppBarButton extends StatelessWidget {
  const BottomAppBarButton(
      {super.key,
      required this.onPressed,
      required this.iconData,
      this.text = ""});

  final Function() onPressed;
  final IconData iconData;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
            customBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
            onTap: onPressed,
            child: SizedBox(
                height: 70,
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      iconData,
                      size: 35,
                    ),
                    Text(
                      text,
                    )
                  ],
                ))));
  }
}

class ResourceCard extends StatelessWidget {
  const ResourceCard({super.key, required this.things});

  final Things things;

  @override
  Widget build(BuildContext context) {
    Widget resourcesList = Column(
        children: things.content.entries.map((e) {
      return Row(children: [
        ResourceName.getIconForResource(e.key),
        Text("${e.key}:"),
        const Spacer(),
        Text("${e.value}")
      ]);
    }).toList());

    resourcesList = things.content.isEmpty
        ? const Text("Der Spieler hat noch keine Resourcen")
        : resourcesList;

    return Card(
        elevation: 10,
        margin: const EdgeInsets.all(8),
        //color: ColorPalette.background,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "Resourcen:", //style: StyleCollection.defaultTextStyle
                  ),
                  const SizedBox(height: 10),
                  resourcesList
                ],
              ),
            )));
  }
}

class Requirement {
  Requirement(this.name, this.count,
      {this.availiable = true, this.showIcon = true});

  bool availiable;
  bool showIcon;
  String name;
  int? count;
}

class RequirementLabel extends StatelessWidget {
  const RequirementLabel({this.requirements, super.key});

  final List<Requirement>? requirements;

  @override
  Widget build(BuildContext context) {
    TextStyle? resourceNotAvailiableTextStyle =
        Theme.of(context).textTheme.bodySmall;

    if (requirements == null) return const SizedBox();

    return Row(
        children: requirements!.map((r) {
      if (r.count == null) {
        return Text(r.name,
            style: r.availiable ? null : resourceNotAvailiableTextStyle);
      }

      return Row(children: [
        r.showIcon ? ResourceName.getIconForResource(r.name) : const SizedBox(),
        Text(
          "${r.name}:",
          style: r.availiable ? null : resourceNotAvailiableTextStyle,
        ),
        Text(
          "${r.count}  ",
          style: r.availiable ? null : resourceNotAvailiableTextStyle,
        ),
      ]);
    }).toList());
  }
}

class LawCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final PoliticalSystem system;
  final Function()? onDelete;

  const LawCard(
      {required this.title,
      required this.children,
      this.system = PoliticalSystem.none,
      this.onDelete,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        shadowColor: system.getColorForSystem(),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
            Row(
              children: [
                const Spacer(),
                Column(children: children),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      onPressed: () => onDelete?.call(),
                      icon: const Icon(Icons.delete_outline)),
                )
              ],
            )
          ],
        ));
  }
}
