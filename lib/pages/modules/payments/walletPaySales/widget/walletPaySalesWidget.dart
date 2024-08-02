import 'package:flutter/material.dart';
import 'package:pickme_mobile/components/button.dart';
import 'package:pickme_mobile/components/textField.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/strings.dart';
import 'package:pickme_mobile/spec/styles.dart';

import 'walletPaySalesWidgetAppBar.dart';

Widget walletPaySalesWidget({
  @required BuildContext? context,
  @required void Function()? onPayment,
  required TextEditingController codeController,
  required FocusNode codeFocusNode,
}) {
  return NestedScrollView(
    headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
      return <Widget>[const WalletPaySalesWidget()];
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
            const SizedBox(height: 30),
            Text("Payment Pincode", style: Styles.h6Black),
            const SizedBox(height: 10),
            textFormField(
              hintText: "Enter your code",
              controller: codeController,
              focusNode: codeFocusNode,
              validateMsg: Strings.requestField,
            ),
            const SizedBox(height: 40),
            button(
              onPressed: onPayment,
              text: "Pay",
              color: BColors.primaryColor,
              context: context,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}
