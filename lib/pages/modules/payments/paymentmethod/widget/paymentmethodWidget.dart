import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pickme_mobile/spec/arrays.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'package:pickme_mobile/spec/styles.dart';

import 'paymentmethodBottom.dart';

Widget paymentmethodWidget({
  required BuildContext context,
  required TextEditingController promoCodeController,
  required FocusNode promoCodeFocusNode,
  required void Function() onApply,
  required void Function() onDone,
  required ServicePurpose purpose,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text("Choose payment method", style: Styles.h3BlackBold),
              const SizedBox(height: 30),
              if (purpose != ServicePurpose.personalShopper) ...[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: BColors.assDeep),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: BColors.primaryColor1,
                      radius: 25,
                      child: Icon(Icons.money, color: BColors.white),
                    ),
                    title: Text("Cash", style: Styles.h4BlackBold),
                    subtitle:
                        Text("Default Payment Method", style: Styles.h6Black),
                    trailing: const Icon(
                      Icons.circle_outlined,
                      color: BColors.primaryColor1,
                      size: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: BColors.assDeep),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: BColors.primaryColor1,
                    radius: 25,
                    child: SvgPicture.asset(
                      Images.wallet,
                      color: BColors.white,
                    ),
                  ),
                  title: Text(
                    "Wallet (PickMe Cash)",
                    style: Styles.h4BlackBold,
                  ),
                  subtitle: Text(
                    "Recommended Payment Method",
                    style: Styles.h6Black,
                  ),
                  trailing: const Icon(
                    Icons.circle_outlined,
                    color: BColors.primaryColor1,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: paymentmethodBottom(
            context: context,
            promoCodeController: promoCodeController,
            promoCodeFocusNode: promoCodeFocusNode,
            onApply: onApply,
            onDone: onDone,
            purpose: purpose,
          ),
        ),
      ],
    ),
  );
}
