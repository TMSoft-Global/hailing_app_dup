import 'package:flutter/material.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:pickme_mobile/pages/modules/worker/workerRegistration/registrationPersonalDetails/registrationPersonalDetails.dart';

import 'widget/registrationEntryCodeWidget.dart';

class RegistrationEntryCode extends StatefulWidget {
  const RegistrationEntryCode({super.key});

  @override
  State<RegistrationEntryCode> createState() => _RegistrationEntryCodeState();
}

class _RegistrationEntryCodeState extends State<RegistrationEntryCode> {
  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;

  final _otpController = OtpFieldController();

  @override
  void initState() {
    super.initState();
    _initInteractor();
    controller = OTPTextEditController(
      codeLength: 6,
      onCodeReceive: (code) =>
          debugPrint('Your Application receive code - $code'),
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          String ot = exp.stringMatch(code ?? '') ?? '';
          _otpController.set(ot.split(''));
          return ot;
        },
        strategies: [
          // SampleStrategy(),
        ],
      );
  }

  Future<void> _initInteractor() async {
    _otpInteractor = OTPInteractor();

    // You can receive your app signature by using this method.
    final appSignature = await _otpInteractor.getAppSignature();

    debugPrint('Your app signature: $appSignature');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: registrationEntryCodeWidget(
        context: context,
        otpController: _otpController,
        onSend: () => _onSend(),
      ),
    );
  }

  void _onSend() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const RegistrationPersonalDetails()),
    );
  }
}

// class SampleStrategy extends OTPStrategy {
//   @override
//   Future<String> listenForCode() {
//     return Future.delayed(
//       const Duration(seconds: 4),
//       () => 'Your code is 54321',
//     );
//   }
// }