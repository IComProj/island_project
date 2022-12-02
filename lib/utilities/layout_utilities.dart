import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:island_project/data/color_palette.dart';
import 'package:island_project/data/notification.dart' as notifications;
import 'package:island_project/data/thing.dart';
import 'package:unicons/unicons.dart';

// class StyleCollection {
//   // static ButtonStyle defaultButtonStyle = ButtonStyle(
//   //     backgroundColor: MaterialStateProperty.all<Color>(Colors.black26));

//   ///The defeult TextStyle. Main color: light green
//   static TextStyle defaultTextStyle =
//       GoogleFonts.oswald(color: ColorPalette.primary, fontSize: 20);

//   static TextStyle secondaryTextStyle =
//       GoogleFonts.oswald(color: ColorPalette.onPrimary, fontSize: 20);

//   ///A style for each button
//   static ButtonStyle defaultButtonStyle =
//       ButtonStyle(surfaceTintColor: MaterialStateProperty.resolveWith((states) {
//     if (states.contains(MaterialState.pressed)) {
//       return ColorPalette.onSecondary;
//     }
//     return ColorPalette.primary;
//   }), shape: MaterialStateProperty.resolveWith((states) {
//     if (states.contains(MaterialState.pressed)) {
//       return RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(18),
//           side: const BorderSide(color: ColorPalette.onPrimary));
//     }

//     return RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(18),
//         side: const BorderSide(color: ColorPalette.primary));
//   }));

//   static ButtonStyle disabledButtonStyle =
//       ButtonStyle(surfaceTintColor: MaterialStateProperty.resolveWith((states) {
//     if (states.contains(MaterialState.pressed)) {
//       return ColorPalette.onSecondary;
//     }
//     return const Color.fromARGB(255, 135, 135, 135);
//   }), shape: MaterialStateProperty.resolveWith((states) {
//     if (states.contains(MaterialState.pressed)) {
//       return RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(18),
//           side: const BorderSide(color: ColorPalette.onPrimary));
//     }

//     return RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(18),
//         side: const BorderSide(color: Color.fromARGB(255, 150, 150, 150)));
//   }));

//   static TextStyle disabledTextStyle =
//       const TextStyle(color: Color.fromARGB(255, 135, 135, 135));

//   ///A style for each header that's on non-black background
//   static TextStyle header01TextStyle = GoogleFonts.oswald(
//       color: Colors.black,
//       fontSize: 30,
//       textStyle: const TextStyle(decoration: TextDecoration.underline));

//   ///A style for each header that's on black-like background
//   static TextStyle header02TextStyle = GoogleFonts.oswald(
//       color: Colors.red[400],
//       fontSize: 30,
//       textStyle: const TextStyle(decoration: TextDecoration.underline));

//   ///A style for the text of the BottomAppBar
//   static TextStyle tabTextStyle = const TextStyle(color: ColorPalette.primary);
// }

// Scaffold buildScaffold(String title,
//     {BottomAppBar? bottomAppBar,
//     Widget? body,
//     Widget? floatingActionButton,
//     Color? backgroundColor}) {
//   return Scaffold(
//     backgroundColor: backgroundColor,
//     appBar: AppBar(
//       title: Center(
//           child: Text(
//         title,
//         style: StyleCollection.header01TextStyle,
//       )),
//     ),
//     bottomNavigationBar: bottomAppBar,
//     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     floatingActionButton: floatingActionButton,
//     body: body,
//   );
// }

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

Widget buildUserCard(String username, Function(String username) onClick) {
  return GestureDetector(
      //behavior: HitTestBehavior.deferToChild,
      onTap: () {
        onClick(username);
      },
      child: Card(
          elevation: 10,
          shadowColor: Colors.black,
          margin: const EdgeInsets.all(6),
          //color: ColorPalette.background,
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 45, //color: ColorPalette.primary
                    ),
                    Column(children: [
                      Text(
                        username,
                        //style: StyleCollection.defaultTextStyle,
                      )
                    ])
                  ]),
            ),
          )));
}

Widget buildGridItem(Function()? onClick, IconData? iconData,
    {Color? color, String? text}) {
  return InkWell(
      onTap: onClick,
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
                  text,
                  //style: StyleCollection.secondaryTextStyle,
                )
              : const SizedBox(
                  width: 0,
                  height: 0,
                )
        ],
      ));
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
  const ReturnFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      onPressed: () => Navigator.of(context).pop(),
      child: const Icon(
        Icons.arrow_left,
        size: 30,
      ),
    );
  }
}

Widget buildIconButton(IconData iconData, Function() onPressed,
    {String text = ""}) {
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

// Icon getIconForResource(String resourceName) {
//   switch (resourceName) {
//     case ResourceName.gold:
//       return const Icon(
//         UniconsLine.dollar_alt,
//         color: Colors.amber,
//       );
//     case ResourceName.apple:
//       return const Icon(
//         Icons.apple,
//         color: Colors.red,
//       );
//     case ResourceName.shovel:
//       return const Icon(
//         UniconsLine.shovel,
//         color: Colors.blueGrey,
//       );
//     case ResourceName.wheat:
//       return const Icon(
//         UniconsLine.trees,
//         color: Colors.yellow,
//       );
//     case ResourceName.meat:
//       return Icon(Ionicons.fast_food, color: Colors.amber[700]);

//     default:
//       return const Icon(UniconsLine.gold);
//   }
// }
