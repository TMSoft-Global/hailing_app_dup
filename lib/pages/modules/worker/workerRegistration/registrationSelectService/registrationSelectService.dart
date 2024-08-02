import 'package:flutter/material.dart';
import 'package:pickme_mobile/components/button.dart';
import 'package:pickme_mobile/pages/modules/worker/workerRegistration/registrationEntryCode/registrationEntryCode.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'package:pickme_mobile/spec/styles.dart';

import 'widget/registrationSelectServiceWidget.dart';

class RegistrationSelectService extends StatefulWidget {
  const RegistrationSelectService({super.key});

  @override
  State<RegistrationSelectService> createState() =>
      _RegistrationSelectServiceState();
}

class _RegistrationSelectServiceState extends State<RegistrationSelectService> {
  final List<Map<String, dynamic>> _serviceList = [
    {
      "title": "Rider",
      "image": Images.service1,
      "check": false,
    },
    {
      "title": "Driver",
      "image": Images.service2,
      "check": false,
    },
    {
      "title": "Shopper",
      "image": Images.service3,
      "check": false,
    },
    {
      "title": "Delivery Guy",
      "image": Images.service4,
      "check": false,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: RichText(
              text: TextSpan(text: "Welcome", style: Styles.h5Black, children: [
                TextSpan(
                  text: "   Qhobbie",
                  style: Styles.h5BlackBold,
                )
              ]),
            ),
          ),
        ],
      ),
      body: registrationSelectServiceWidget(
        context: context,
        serviceList: _serviceList,
        onInfo: (int index) {},
        onService: (int index) => _onService(index),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: button(
          onPressed: () => _onRequestCode(),
          text: "Request Entry Code",
          color: BColors.primaryColor,
          context: context,
        ),
      ),
    );
  }

  void _onRequestCode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationEntryCode()),
    );
  }

  void _onService(int index) {
    _serviceList[index]["check"] = !_serviceList[index]["check"];
    setState(() {});
  }
}
