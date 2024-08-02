import 'package:flutter/material.dart';
import 'package:pickme_mobile/config/navigation.dart';
import 'package:pickme_mobile/spec/arrays.dart';

import 'widget/rateCustomerWidget.dart';

class RateCustomer extends StatefulWidget {
  final ServicePurpose servicePurpose;

  const RateCustomer({
    super.key,
    this.servicePurpose = ServicePurpose.ride,
  });

  @override
  State<RateCustomer> createState() => _RateCustomerState();
}

class _RateCustomerState extends State<RateCustomer> {
  final _commentController = new TextEditingController();
  final _commentFocusNode = new FocusNode();

  double _rate = 5;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(),
        body: rateCustomerWidget(
          context: context,
          rate: _rate,
          onRate: (double rate) => _onRate(rate),
          commentController: _commentController,
          commentFocusNode: _commentFocusNode,
          onSubmit: () => _onSubmit(),
          servicePurpose: widget.servicePurpose,
        ),
      ),
    );
  }

  void _onSubmit() {
    navigation(context: context, pageName: "homepage");
  }

  void _onRate(double rate) {
    _rate = rate;
    setState(() {});
  }
}
