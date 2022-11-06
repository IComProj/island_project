import 'package:flutter/material.dart';
import 'package:island_project/data/color_palette.dart';

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
    return MaterialApp(
      title: 'Island Project',
      theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: Colors.green[600],
          colorScheme: _generateColorSceme(),
          backgroundColor: Colors.black),
      home: const MainDashboardPage(),
    );
  }

  ColorScheme _generateColorSceme() {
    return const ColorScheme(
        brightness: ColorPalette.brightness,
        primary: ColorPalette.primary,
        onPrimary: ColorPalette.onPrimary,
        secondary: ColorPalette.secondary,
        onSecondary: ColorPalette.onSecondary,
        error: ColorPalette.error,
        onError: ColorPalette.onError,
        background: ColorPalette.background,
        onBackground: ColorPalette.onBackground,
        surface: ColorPalette.surface,
        onSurface: ColorPalette.onSurface);
  }
}
