import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pickme_mobile/components/button.dart';
import 'package:pickme_mobile/components/cachedImage.dart';
import 'package:pickme_mobile/components/circular.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'package:pickme_mobile/spec/properties.dart';
import 'package:pickme_mobile/spec/styles.dart';

class WorkerRideRequestDialog extends StatefulWidget {
  final VoidCallback onReject;
  final VoidCallback onAccept;
  final int remainTime;

  const WorkerRideRequestDialog({
    required this.onReject,
    required this.onAccept,
    required this.remainTime,
    super.key,
  });

  @override
  State<WorkerRideRequestDialog> createState() =>
      _WorkerRideRequestDialogState();
}

class _WorkerRideRequestDialogState extends State<WorkerRideRequestDialog> {
  int remainTime = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    remainTime = widget.remainTime;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainTime == 0) {
          timer.cancel();
          widget.onReject();
        } else {
          remainTime--;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: double.maxFinite,
        decoration: const BoxDecoration(
          color: BColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 20),
            Text("Incoming Request", style: Styles.h6BlackBold),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: circular(
                child: cachedImage(
                  context: context,
                  image: "",
                  height: 50,
                  width: 50,
                  placeholder: Images.defaultProfilePicOffline,
                ),
                size: 50,
              ),
              title: Text("Gregory Smith", style: Styles.h4BlackBold),
              subtitle: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: BColors.yellow1),
                  const SizedBox(width: 10),
                  Text("4.9", style: Styles.h6Black),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text("${Properties.curreny} 45.00", style: Styles.h2Black),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: BColors.primaryColor),
                ),
                child: const Icon(
                  Icons.circle,
                  color: BColors.primaryColor,
                  size: 15,
                ),
              ),
              title: Text("4 min (1 mile) away", style: Styles.h5BlackBold),
              subtitle: Text(
                "Melcom chambers street",
                style: Styles.h4Black,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.location_on,
                color: BColors.primaryColor1,
              ),
              title: Text("30 min (8 miles) trip", style: Styles.h5BlackBold),
              subtitle: Text(
                "West Hills Mall, Kasoa, Eden Height ST",
                style: Styles.h4Black,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                button(
                  onPressed: widget.onReject,
                  text: "Reject $remainTime",
                  color: BColors.primaryColor1,
                  context: context,
                  divideWidth: .45,
                  colorFill: false,
                  backgroundcolor: BColors.white,
                  textColor: BColors.primaryColor1,
                  borderWidth: 2,
                ),
                button(
                  onPressed: widget.onAccept,
                  text: "Accept",
                  color: BColors.primaryColor,
                  context: context,
                  divideWidth: .45,
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
