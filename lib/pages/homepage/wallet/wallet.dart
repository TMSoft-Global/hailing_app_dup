import 'package:flutter/material.dart';

import 'widget/walletWidget.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String _filterType = "all";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: walletWidget(
        context: context,
        onAddMoney: () {},
        onTransfer: () {},
        onTransaction: () {},
        onContactUs: () {},
        onTransactionFilter: (String filter) => _onTransactionFilter(filter),
        filterType: _filterType,
      ),
    );
  }

  void _onTransactionFilter(String filter) {
    _filterType = filter;
    setState(() {});
  }
}
