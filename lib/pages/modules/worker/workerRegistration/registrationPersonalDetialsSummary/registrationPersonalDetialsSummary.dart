import 'package:flutter/material.dart';
import 'package:pickme_mobile/components/congratPage.dart';
import 'package:pickme_mobile/pages/homepage/mainHomepage.dart';
import 'package:pickme_mobile/spec/styles.dart';

import 'widget/registrationPersonalDetialsSummaryWidget.dart';

class RegistrationPersonalDetialsSummary extends StatefulWidget {
  final Map<String, dynamic> meta;
  const RegistrationPersonalDetialsSummary(this.meta, {super.key});

  @override
  State<RegistrationPersonalDetialsSummary> createState() =>
      _RegistrationPersonalDetialsSummaryState();
}

class _RegistrationPersonalDetialsSummaryState
    extends State<RegistrationPersonalDetialsSummary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: registrationPersonalDetialsSummaryWidget(
        context: context,
        meta: widget.meta,
        onConfirm: () => _onConfirm(),
      ),
    );
  }

  void _onConfirm() {
    _onCongratPage();
  }

  void _onCongratPage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => CongratPage(
            homeButtonText: "Ok",
            fillBottomButton: true,
            onHome: (context) => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const MainHomepage(selectedPage: 4),
                ),
                (Route<dynamic> route) => false),
            widget: Column(
              children: [
                Text(
                  "We're reviewing your document",
                  style: Styles.h3BlackBold,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Text(
                  "This process usually takes less than a day for us to complete ",
                  style: Styles.h5Black,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
        (Route<dynamic> route) => false);
  }
}
