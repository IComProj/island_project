import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:island_project/data/jobs/jobs.dart';
import 'package:island_project/data/laws/laws.dart';
import 'package:island_project/layouts/primitive_layouts.dart';

class DisallowJobCard extends StatefulWidget {
  final int lawstackIndex;
  final Function()? onDelete;

  const DisallowJobCard(
      {required this.onDelete, required this.lawstackIndex, super.key});

  @override
  State<DisallowJobCard> createState() => _DisallowJobCardState();
}

class _DisallowJobCardState extends State<DisallowJobCard> {
  int? _dropdownIndex;

  @override
  void initState() {
    super.initState();

    _dropdownIndex = Jobs.all.indexWhere((element) =>
        element.jobName ==
        LawStack.instance.laws[widget.lawstackIndex].data!["job"]);
  }

  @override
  Widget build(BuildContext context) {
    return LawCard(
        onDelete: widget.onDelete,
        title: "Verbot von Beruf",
        system: PoliticalSystem.none,
        children: [
          DropdownButton(
            iconEnabledColor: Colors.black,
            dropdownColor: Colors.grey,
            value: _dropdownIndex,
            items: List.generate(
                Jobs.all.length,
                (index) => DropdownMenuItem(
                    value: index, child: Text(Jobs.all[index].displayName))),
            onChanged: (value) {
              setState(() {
                _dropdownIndex = value;

                LawStack.instance.laws[widget.lawstackIndex].data?["job"] =
                    Jobs.all[_dropdownIndex!].jobName;
              });
            },
          )
        ]);
  }
}
