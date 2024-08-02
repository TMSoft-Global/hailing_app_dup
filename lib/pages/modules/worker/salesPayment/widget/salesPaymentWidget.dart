import 'package:flutter/material.dart';
import 'package:pickme_mobile/components/button.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/properties.dart';
import 'package:pickme_mobile/spec/styles.dart';

import 'salesPaymentAppBar.dart';

Widget salesPaymentWidget({
  @required BuildContext? context,
  @required void Function()? onPayment,
}) {
  return NestedScrollView(
    headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
      return <Widget>[const SalesPaymentAppBar()];
    },
    body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: BColors.assDeep1,
                border: Border.all(color: BColors.assDeep),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: BColors.primaryColor1,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.receipt_long_outlined,
                    color: BColors.white,
                  ),
                ),
                title: Text("Sales Amount", style: Styles.h6Black),
                subtitle: Text("120.00", style: Styles.h3BlackBold),
                trailing: Container(
                  color: BColors.primaryColor1,
                  padding: const EdgeInsets.all(5),
                  child: Text("Fixed Amount", style: Styles.h6WhiteBold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Driver is supposed to pay this amount to ${Properties.titleShort.toUpperCase()} Company before 5:00pm",
              style: Styles.h6Black,
            ),
            const SizedBox(height: 20),
            button(
              onPressed: onPayment,
              text: "Proceed to payment",
              color: BColors.primaryColor,
              context: context,
            ),
            const SizedBox(height: 30),
            for (int x = 0; x < 6; ++x) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                visualDensity: const VisualDensity(vertical: -3),
                leading: const CircleAvatar(
                  radius: 10,
                  backgroundColor: BColors.primaryColor,
                  child: Icon(
                    Icons.arrow_downward,
                    size: 13,
                    color: BColors.white,
                  ),
                ),
                title: Text(
                  "${Properties.curreny} 567 to ${Properties.titleShort.toUpperCase()}",
                  style: Styles.h4BlackBold,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  "Amount paid as sales to account ..",
                  style: Styles.h6Black,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text("Nov 12\n6:00am", style: Styles.h6Black),
              ),
              const Divider(),
            ],
          ],
        ),
      ),
    ),
  );
}
