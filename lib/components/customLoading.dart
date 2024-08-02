import 'package:flutter/material.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/styles.dart';

import 'loadingView.dart';

Widget customLoadingPage({
  String msg = "",
  bool showClose = false,
  void Function()? onClose,
}) {
  return Scaffold(
    backgroundColor: BColors.white.withOpacity(.9),
    body: Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              loadingDoubleBounce(BColors.primaryColor),
              if (msg != "") ...[
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    msg,
                    style: Styles.h4BlackXBold,
                    textAlign: TextAlign.center,
                  ),
                ),
              ]
            ],
          ),
        ),
        if (showClose)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: BColors.black,
                child: IconButton(
                  onPressed: onClose,
                  color: BColors.white,
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
