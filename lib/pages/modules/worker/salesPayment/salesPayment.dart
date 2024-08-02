import 'package:flutter/material.dart';
import 'package:pickme_mobile/pages/modules/payments/walletPaySales/walletPaySales.dart';

import 'widget/salesPaymentWidget.dart';

class SalesPayment extends StatefulWidget {
  const SalesPayment({super.key});

  @override
  State<SalesPayment> createState() => _SalesPaymentState();
}

class _SalesPaymentState extends State<SalesPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: salesPaymentWidget(
        context: context,
        onPayment: () => _onPayment(),
      ),
    );
  }

  void _onPayment() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WalletPaySales(),
      ),
    );
  }
}
