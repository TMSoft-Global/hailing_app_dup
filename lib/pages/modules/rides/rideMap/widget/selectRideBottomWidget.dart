import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pickme_mobile/components/button.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'package:pickme_mobile/spec/properties.dart';
import 'package:pickme_mobile/spec/styles.dart';

Widget selectRideBottomWidget({
  required BuildContext context,
  required void Function() onPaymentMethod,
  required void Function() onRequest,
}) {
  return AnimatedContainer(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: BColors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      boxShadow: [
        BoxShadow(
          color: BColors.black.withOpacity(.1),
          spreadRadius: .1,
          blurRadius: 20,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    duration: const Duration(seconds: 3),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 5,
          width: 60,
          decoration: BoxDecoration(
            color: BColors.assDeep,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 20),
        for (int x = 0; x < 2; ++x) ...[
          ListTile(
            dense: true,
            visualDensity: const VisualDensity(vertical: -1),
            leading: SvgPicture.asset(
              Images.carSvg,
              height: 25,
              color: BColors.black,
            ),
            title: Text("Car 4 seat", style: Styles.h5BlackBold),
            subtitle: Text("0.5 km", style: Styles.h6Black),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${Properties.curreny} 30.00", style: Styles.h5BlackBold),
                const SizedBox(height: 1),
                Text("4 min", style: Styles.h6Black),
              ],
            ),
          ),
          const Divider(),
        ],
        const SizedBox(height: 30),
        ListTile(
          onTap: onPaymentMethod,
          dense: true,
          visualDensity: const VisualDensity(vertical: -3),
          leading: const Icon(Icons.money, color: BColors.black),
          title: Text("Cash Payment", style: Styles.h5BlackBold),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: BColors.black,
            size: 15,
          ),
        ),
        const SizedBox(height: 20),
        button(
          onPressed: onRequest,
          text: "Request",
          color: BColors.primaryColor,
          context: context,
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}
