import 'package:flutter/material.dart';
import 'package:island_project/data/laws/laws.dart';
import 'package:island_project/layouts/primitive_layouts.dart';

class LawView extends StatefulWidget {
  const LawView({super.key});

  @override
  State<LawView> createState() => _LawViewState();
}

class _LawViewState extends State<LawView> {
  @override
  Widget build(BuildContext context) {
    final Map<PoliticalSystem, Image> systemIcons = _getSystemIcons();

    return Scaffold(
        appBar: AppBar(
            title: const Text("Gesetz"), automaticallyImplyLeading: false),
        floatingActionButton: const ReturnFloatingActionButton(
          arrowDirection: AxisDirection.down,
        ),
        body: Theme(
          data: ThemeData(
              colorScheme: Theme.of(context)
                  .colorScheme
                  .copyWith(primary: Colors.white, secondary: Colors.white)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                  child:
                      systemIcons[PoliticalSystem.anarchy] ?? const SizedBox(),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Text(
                      "Anarchie",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Text(
                      "(Zurzeitige Staatsform)",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.apply(color: Colors.white),
                    ),
                  ],
                )
              ],
            )
          ]),
        ));
  }

  Map<PoliticalSystem, Image> _getSystemIcons() {
    return Map.fromIterable(PoliticalSystem.values,
        key: (element) => element,
        value: (element) {
          Color col = (element as PoliticalSystem).getColorForSystem();

          return Image.asset(
            "assets/images/${element.toString().split(".").last}_icon.png",
            color: col,
            colorBlendMode: BlendMode.modulate,
          );
        });
  }
}
