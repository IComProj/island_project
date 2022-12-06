import 'package:flutter/material.dart';

import 'layouts/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
          dialogTheme: DialogTheme(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  side: BorderSide(color: greenPrimary))),
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
          cardTheme: const CardTheme(color: Color.fromARGB(255, 21, 26, 20)),
          cardColor: Colors.grey.shade900,
          scaffoldBackgroundColor: Colors.black,
          disabledColor: Colors.grey.shade700,
          primaryColor: greenPrimary,
          colorScheme: ColorScheme.dark(
              background: Colors.black,
              primary: greenPrimary,
              secondary: greenPrimary)),
      home: const MainDashboardPage(),
    );
  }
}
