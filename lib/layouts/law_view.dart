import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:island_project/data/laws/laws.dart';
import 'package:island_project/layouts/primitive_layouts.dart';

class LawView extends StatefulWidget {
  const LawView({super.key});

  @override
  State<LawView> createState() => _LawViewState();
}

class _LawViewState extends State<LawView> {
  Future<bool>? _lawLoader;

  @override
  void initState() {
    super.initState();

    _lawLoader = LawStack.pull().then((value) {
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<PoliticalSystem, Image> systemIcons = _getSystemIcons();

    return Theme(
        data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Colors.white,
            primaryColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            colorScheme: Theme.of(context)
                .colorScheme
                .copyWith(primary: Colors.white, onPrimary: Colors.black),
            cardColor: Colors.white,
            cardTheme: CardTheme.of(context).copyWith(
              color: Colors.white,
              elevation: 10,
              // shape: const RoundedRectangleBorder(
              //     side: BorderSide(color: Colors.black),
              //     borderRadius: BorderRadius.all(Radius.circular(12)))
            ),
            textTheme: Theme.of(context)
                .textTheme
                .apply(bodyColor: Colors.black, decorationColor: Colors.black),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.grey)),
        child: FutureBuilder(
            future: _lawLoader,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                PoliticalSystem currentSystem =
                    LawStack.instance.getTypeOfSystem();
                return Scaffold(
                    floatingActionButton: SpeedDial(
                      animatedIcon: AnimatedIcons.menu_home,
                      overlayOpacity: 0,
                      children: [
                        SpeedDialChild(
                          child: Icon(Icons.arrow_drop_down),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        SpeedDialChild(
                          child: Icon(Icons.add),
                        ),
                        SpeedDialChild(
                          child: Icon(Icons.check),
                          onTap: () => setState(() {
                            LawStack.push();
                          }),
                        )
                      ],
                    ),
                    body: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          expandedHeight: 160,
                          pinned: true,
                          stretch: true,
                          backgroundColor: Colors.black,
                          shadowColor: Colors.black,
                          flexibleSpace: FlexibleSpaceBar(
                            title: FittedBox(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      currentSystem.getNameForSystem(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          ?.apply(
                                              color: currentSystem
                                                  .getColorForSystem()),
                                    ),
                                    Text(
                                      "(Zurzeitige Staatsform)",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.apply(color: Colors.white),
                                    ),
                                  ],
                                ),
                                SizedBox.square(
                                  dimension: 80,
                                  child: systemIcons[currentSystem] ??
                                      const SizedBox(),
                                ),
                              ],
                            )),
                            // background: FittedBox(
                            //   child: systemIcons[currentSystem] ??
                            //       const SizedBox(),
                            // ))),
                          ),
                        ),

                        SliverToBoxAdapter(
                            child: Stack(
                          children: [
                            ClipPath(
                                clipper: _MyCustomClipper(),
                                clipBehavior: Clip.antiAlias,
                                child: Container(
                                  height: 120,
                                  color: Colors.black,
                                )),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 50,
                                ),
                                Text("Aktive Gesetze:",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.apply(color: Colors.white)),
                              ],
                            )
                          ],
                        )),

                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                          childCount: LawStack.instance.laws.length,
                          (context, index) => LawStack.instance.laws[index]
                              .buildCard(context, index, () {
                            LawStack.instance.laws.removeAt(index);
                            setState(
                              () {},
                            );
                          }),
                        ))

                        // SliverAppBar(
                        //     expandedHeight: 500,
                        //     title: Column(children: [
                        //       Stack(
                        //         children: [
                        //           ClipPath(
                        //               clipper: _MyCustomClipper(),
                        //               clipBehavior: Clip.antiAlias,
                        //               child: Container(
                        //                 height: 200,
                        //                 color: Colors.black,
                        //                 child: Column(
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.center,
                        //                     children: [
                        //                       Row(
                        //                         mainAxisAlignment:
                        //                             MainAxisAlignment.center,
                        //                         children: [
                        //                           SizedBox(
                        //                             height: 80,
                        //                             child: systemIcons[
                        //                                     currentSystem] ??
                        //                                 const SizedBox(),
                        //                           ),
                        //                           const SizedBox(
                        //                             width: 20,
                        //                           ),
                        //                           Column(
                        //                             children: [
                        //                               Text(
                        //                                 currentSystem
                        //                                     .getNameForSystem(),
                        //                                 style: Theme.of(context)
                        //                                     .textTheme
                        //                                     .headline4
                        //                                     ?.apply(
                        //                                         color: currentSystem
                        //                                             .getColorForSystem()),
                        //                               ),
                        //                               Text(
                        //                                 "(Zurzeitige Staatsform)",
                        //                                 style: Theme.of(context)
                        //                                     .textTheme
                        //                                     .labelLarge
                        //                                     ?.apply(
                        //                                         color: Colors
                        //                                             .white),
                        //                               ),
                        //                             ],
                        //                           )
                        //                         ],
                        //                       )
                        //                     ]),
                        //               )),
                        //         ],
                        //       ),
                        //     ])),
                      ],
                    ));
              }

              return const LoadingPage();
            }));
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

class _MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    Path p = Path();

    p.lineTo(0, h);

    p.quadraticBezierTo(w * 0.25, h, w * 0.5, h - 50);
    p.quadraticBezierTo(w * 0.75, h - 100, w, h - 50);

    p.lineTo(w, 0);

    p.close();

    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
