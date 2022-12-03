import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'layouts/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color greenPrimary = Colors.lightGreen.shade400;

    return MaterialApp(
      title: 'Island Project',
      theme: ThemeData.dark().copyWith(
          textButtonTheme: TextButtonThemeData(style:
              ButtonStyle(shape: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: Colors.grey.shade700));
            }

            return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: greenPrimary));
          }))),
          textTheme: Typography.whiteCupertino.apply(
            fontFamily: "Oswald",
            displayColor: Colors.red.shade700,
            bodyColor: greenPrimary,
          ),
          iconTheme: IconThemeData(color: greenPrimary),
          bottomAppBarTheme:
              const BottomAppBarTheme(color: Color.fromARGB(255, 20, 20, 20)),
          cardTheme: CardTheme(color: Color.fromARGB(255, 21, 26, 20)),
          cardColor: Colors.grey.shade900,
          scaffoldBackgroundColor: Colors.black,
          disabledColor: Colors.grey.shade700,
          primaryColor: greenPrimary,
          colorScheme: ColorScheme.dark(
              background: Colors.black,
              primary: greenPrimary,
              secondary: greenPrimary))
      // primarySwatch: Colors.green,
      // primaryColor: Colors.green[600],
      // colorScheme: _generateColorSceme(),
      // backgroundColor: Colors.black

      ,
      home: const MainDashboardPage(),
    );
  }

  // ColorScheme _generateColorSceme() {
  //   return const ColorScheme(
  //       brightness: ColorPalette.brightness,
  //       primary: ColorPalette.primary,
  //       onPrimary: ColorPalette.onPrimary,
  //       secondary: ColorPalette.secondary,
  //       onSecondary: ColorPalette.onSecondary,
  //       error: ColorPalette.error,
  //       onError: ColorPalette.onError,
  //       background: ColorPalette.background,
  //       onBackground: ColorPalette.onBackground,
  //       surface: ColorPalette.surface,
  //       onSurface: ColorPalette.onSurface);
  // }
}
