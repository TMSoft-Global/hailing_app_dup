import 'package:flutter/material.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/styles.dart';

import 'widget/workerAppreciationWidget.dart';

class WorkerAppreciation extends StatefulWidget {
  const WorkerAppreciation({super.key});

  @override
  State<WorkerAppreciation> createState() => _WorkerAppreciationState();
}

class _WorkerAppreciationState extends State<WorkerAppreciation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        iconTheme: const IconThemeData(color: BColors.white),
        backgroundColor: BColors.primaryColor,
        title: Text("Promotions", style: Styles.h4WhiteBold),
      ),
      body: workerAppreciationWidget(context: context),
    );
  }
}