import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:island_project/layouts/primitive_layouts.dart';

class LawView extends StatefulWidget {
  const LawView({super.key});

  @override
  State<LawView> createState() => _LawViewState();
}

class _LawViewState extends State<LawView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: const ReturnFloatingActionButton(
      arrowDirection: AxisDirection.down,
    ));
  }
}
