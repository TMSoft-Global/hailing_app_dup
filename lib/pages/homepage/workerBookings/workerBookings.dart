import 'package:flutter/material.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/styles.dart';

import 'widget/workerBookingsWidget.dart';

class WorkerBookings extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const WorkerBookings({
    super.key,
    required this.scaffoldKey,
  });

  @override
  State<WorkerBookings> createState() => _WorkerBookingsState();
}

class _WorkerBookingsState extends State<WorkerBookings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BColors.primaryColor,
        leading: IconButton(
          onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu),
          color: BColors.white,
        ),
        title: Text("My Requests", style: Styles.h4WhiteBold),
      ),
      body: workerBookingsWidget(
        context: context,
      ),
    );
  }
}
