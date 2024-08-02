import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pickme_mobile/pages/modules/worker/workerMap/workerMap.dart';

import 'widget/workerHomeAppBar.dart';

class WorkerHome extends StatefulWidget {
  final Position currentLocation;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const WorkerHome({
    super.key,
    required this.currentLocation,
    required this.scaffoldKey,
  });

  @override
  State<WorkerHome> createState() => _WorkerHomeState();
}

class _WorkerHomeState extends State<WorkerHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: workerHomeAppBar(
        onSos: () {},
        onDrawer: () => widget.scaffoldKey.currentState?.openDrawer(),
      ),
      body: WorkerMap(currentLocation: widget.currentLocation),
    );
  }
}
