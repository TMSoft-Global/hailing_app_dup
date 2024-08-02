import 'package:flutter/material.dart';

import 'widget/walletPaySalesWidget.dart';

class WalletPaySales extends StatefulWidget {
  const WalletPaySales({super.key});

  @override
  State<WalletPaySales> createState() => _WalletPaySalesState();
}

class _WalletPaySalesState extends State<WalletPaySales> {
  final _codeController = new TextEditingController();
  final _codeFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: walletPaySalesWidget(
        context: context,
        onPayment: () {},
        codeController: _codeController,
        codeFocusNode: _codeFocusNode,
      ),
    );
  }
}
