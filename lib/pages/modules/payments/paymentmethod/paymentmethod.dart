import 'package:flutter/material.dart';
import 'package:pickme_mobile/pages/modules/payments/walletPayRide/walletPayRide.dart';
import 'package:pickme_mobile/spec/arrays.dart';

import 'widget/paymentmethodWidget.dart';

class Paymentmethod extends StatefulWidget {
  final ServicePurpose purpose;
  final Map<dynamic, dynamic>? deliveryAddresses;

  const Paymentmethod({
    super.key,
    this.purpose = ServicePurpose.ride,
    this.deliveryAddresses,
  });

  @override
  State<Paymentmethod> createState() => _PaymentmethodState();
}

class _PaymentmethodState extends State<Paymentmethod> {
  final _promoCodeController = new TextEditingController();
  final _promoCodeFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: paymentmethodWidget(
        context: context,
        promoCodeController: _promoCodeController,
        promoCodeFocusNode: _promoCodeFocusNode,
        onApply: () {},
        onDone: () => _onDone(),
        purpose: widget.purpose,
      ),
    );
  }

  void _onDone() {
    if (widget.purpose == ServicePurpose.ride) {
      Navigator.pop(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WalletPayRide(
            purpose: widget.purpose,
            deliveryAddresses: widget.deliveryAddresses,
          ),
        ),
      );
    }
  }
}
