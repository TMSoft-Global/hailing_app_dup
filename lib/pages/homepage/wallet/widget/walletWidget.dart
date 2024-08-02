import 'package:flutter/material.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'package:pickme_mobile/spec/properties.dart';
import 'package:pickme_mobile/spec/styles.dart';

import 'walletAppBar.dart';

Widget walletWidget({
  @required BuildContext? context,
  @required void Function()? onAddMoney,
  @required void Function()? onTransfer,
  @required void Function()? onTransaction,
  @required void Function()? onContactUs,
  @required void Function(String filter)? onTransactionFilter,
  @required String? filterType,
}) {
  return NestedScrollView(
    headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
      return <Widget>[const WalletAppBar()];
    },
    body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _layout1(
                  context: context,
                  image: Images.addMoney,
                  name: 'Add Money',
                  onTap: onAddMoney,
                ),
                _layout1(
                  context: context,
                  image: Images.transfer,
                  name: 'Transfer',
                  onTap: onTransfer,
                ),
                _layout1(
                  context: context,
                  image: Images.transactions,
                  name: 'Transactions',
                  onTap: onTransaction,
                ),
                _layout1(
                  context: context,
                  image: Images.contactUs,
                  name: 'Contact Us',
                  onTap: onContactUs,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("Transactions", style: Styles.h4BlackBold),
            const SizedBox(height: 20),
            Row(
              children: [
                _trasactionFilterOption(
                  label: 'All',
                  isSelected: filterType == 'all',
                  onTap: () => onTransactionFilter?.call('all'),
                ),
                const SizedBox(width: 20),
                _trasactionFilterOption(
                  label: 'Credit',
                  isSelected: filterType == 'credit',
                  onTap: () => onTransactionFilter?.call('credit'),
                  icon: const CircleAvatar(
                    radius: 10,
                    backgroundColor: BColors.primaryColor,
                    child: Icon(
                      Icons.arrow_downward,
                      size: 13,
                      color: BColors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                _trasactionFilterOption(
                  label: 'Debit',
                  isSelected: filterType == 'debit',
                  onTap: () => onTransactionFilter?.call('debit'),
                  icon: const CircleAvatar(
                    radius: 10,
                    backgroundColor: BColors.primaryColor1,
                    child: Icon(
                      Icons.arrow_upward,
                      size: 13,
                      color: BColors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            for (int x = 0; x < 6; ++x) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                visualDensity: const VisualDensity(vertical: -3),
                leading: x % 2 != 0
                    ? const CircleAvatar(
                        radius: 10,
                        backgroundColor: BColors.primaryColor,
                        child: Icon(
                          Icons.arrow_downward,
                          size: 13,
                          color: BColors.white,
                        ),
                      )
                    : const CircleAvatar(
                        radius: 10,
                        backgroundColor: BColors.primaryColor1,
                        child: Icon(
                          Icons.arrow_upward,
                          size: 13,
                          color: BColors.white,
                        ),
                      ),
                title: Text(
                  "${Properties.curreny} 567 from Acc No...",
                  style: Styles.h4BlackBold,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  "Amount credited to your account",
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

Widget _trasactionFilterOption({
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
  Widget? icon,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      constraints: const BoxConstraints(minWidth: 30),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: isSelected
            ? const Border(
                bottom: BorderSide(
                  color: BColors.primaryColor,
                  width: 2,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: isSelected ? Styles.h5PrimaryBold : Styles.h5BlackBold,
          ),
          if (icon != null) ...[
            const SizedBox(width: 10),
            icon,
          ],
        ],
      ),
    ),
  );
}

Widget _layout1({
  @required BuildContext? context,
  @required String? image,
  @required String? name,
  @required void Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: MediaQuery.of(context!).size.width * .22,
      constraints: const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: BColors.assDeep1,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: BColors.black.withOpacity(.05),
            spreadRadius: .1,
            blurRadius: 20,
            // offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(image!),
            const SizedBox(height: 10),
            Text(name!, style: Styles.h7Black, textAlign: TextAlign.center)
          ],
        ),
      ),
    ),
  );
}
