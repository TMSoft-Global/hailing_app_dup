import 'package:flutter/material.dart';
import 'package:pickme_mobile/pages/modules/payments/walletPayRide/walletPayRide.dart';

import 'widget/rideConfirmAmountWidget.dart';

class RideConfirmAmount extends StatefulWidget {
  const RideConfirmAmount({super.key});

  @override
  State<RideConfirmAmount> createState() => _RideConfirmAmountState();
}

class _RideConfirmAmountState extends State<RideConfirmAmount> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(),
        body: rideConfirmAmountWidget(
          context: context,
          onOk: () => _onOk(),
        ),
      ),
    );
  }

  void _onOk() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const WalletPayRide(),
        ),
        (Route<dynamic> route) => false);
  }
}
