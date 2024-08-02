import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:pickme_mobile/components/textField.dart';
import 'package:pickme_mobile/pages/homepage/bookings/widget/bookingAppBar.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'package:pickme_mobile/spec/properties.dart';
import 'package:pickme_mobile/spec/styles.dart';

Widget bookingsWidget({
  @required BuildContext? context,
  @required FocusNode? searchFocusNode,
  @required void Function(String text)? onSearchChange,
  @required void Function()? onBookingFilter,
}) {
  return NestedScrollView(
    headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
      return <Widget>[const BookingAppBar()];
    },
    body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            textFormField(
              hintText: "Search bookings...",
              controller: null,
              focusNode: searchFocusNode,
              onTextChange: (String text) => onSearchChange!(text),
              backgroundColor: BColors.assDeep1,
              borderColor: BColors.assDeep1,
              icon: FeatherIcons.sliders,
              onIconTap: onBookingFilter,
            ),
            const SizedBox(height: 20),
            Text("In Route", style: Styles.h5BlackBold),
            _layout(
              icon: _LayoutIcon.bIcon1,
              title: "Sent Parcel",
              subtitle: "From Nii Haruna Quaye Street 33",
              amount: '45.00',
            ),
            const SizedBox(height: 30),
            for (int x = 0; x < 2; ++x) ...[
              Text("April 2024", style: Styles.h5BlackBold),
              for (int y = 0; y < 4; ++y)
                _layout(
                  icon: y % 2 != 0 ? _LayoutIcon.bIcon1 : _LayoutIcon.bIcon2,
                  title: "Sent Parcel",
                  subtitle: "From Nii Haruna Quaye Street 33",
                  amount: '45.00',
                ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    ),
  );
}

enum _LayoutIcon { bIcon1, bIcon2 }

Widget _layout({
  @required _LayoutIcon? icon,
  @required String? title,
  @required String? subtitle,
  @required String? amount,
}) {
  return Column(
    children: [
      ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: const VisualDensity(vertical: -3),
        leading: CircleAvatar(
          radius: 15,
          backgroundColor: BColors.assDeep1,
          child: Image.asset(
            icon == _LayoutIcon.bIcon1
                ? Images.bookingIcon1
                : Images.bookingIcon2,
          ),
        ),
        title: Text(title!, style: Styles.h4BlackBold),
        subtitle: Text(subtitle!, style: Styles.h6Black),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${Properties.curreny}$amount",
              style: Styles.h4BlackBold,
            ),
          ],
        ),
      ),
      const Divider(),
    ],
  );
}
