import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pickme_mobile/components/button.dart';
import 'package:pickme_mobile/components/toggleBar.dart';
import 'package:pickme_mobile/config/globalFunction.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'package:pickme_mobile/spec/properties.dart';
import 'package:pickme_mobile/spec/styles.dart';

Widget workerHomeMap({
  required BuildContext context,
  required void Function() onPaySales,
  required void Function(int index) onOnOfflineToggle,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: button(
          onPressed: onPaySales,
          text: "Pay Sales",
          color: BColors.primaryColor1,
          context: context,
        ),
      ),
      const SizedBox(height: 10),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: BColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text("       Today's Earnings", style: Styles.h5Black),
          subtitle: Row(
            children: [
              SvgPicture.asset(Images.wallet),
              const SizedBox(width: 10),
              Text("${Properties.curreny} 450.00", style: Styles.h3BlackBold),
            ],
          ),
        ),
      ),
      const SizedBox(height: 10),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 10),
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: BColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width * .23,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 7),
                title: Text(
                  "Total\nTrips",
                  style: Styles.h6Black,
                  textAlign: TextAlign.end,
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(Images.bookingIcon2),
                    const SizedBox(width: 2),
                    Text(formatNumber("20"), style: Styles.h5BlackBold),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: BColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width * .3,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                title: Text(
                  "Time\nOnline",
                  style: Styles.h6Black,
                  textAlign: TextAlign.end,
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.watch_later_outlined,
                      color: BColors.black,
                      size: 25,
                    ),
                    const SizedBox(width: 2),
                    Text("12h 30m", style: Styles.h5BlackBold),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              decoration: BoxDecoration(
                color: BColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width * .26,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                title: Text(
                  "Total\nDistance",
                  style: Styles.h6Black,
                  textAlign: TextAlign.end,
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.route_outlined,
                      color: BColors.black,
                    ),
                    const SizedBox(width: 2),
                    Text("50km", style: Styles.h5BlackBold),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              decoration: BoxDecoration(
                color: BColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width * .24,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 7),
                title: Text(
                  "My\nRatings",
                  style: Styles.h6Black,
                  textAlign: TextAlign.end,
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.star_border_sharp,
                      color: BColors.black,
                    ),
                    const SizedBox(width: 2),
                    Text("4.9", style: Styles.h5BlackBold),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
      const SizedBox(height: 10),
      ToggleBar(
        labels: const ['Offline', 'Online'],
        selectedTabColor: BColors.white,
        selectedTextColor: BColors.green1,
        labelTextStyle: Styles.h5BlackBold,
        backgroundColor: BColors.green1,
        onSelectionUpdated: (index) => onOnOfflineToggle(index),
        selectedIndex: 1,
      ),
    ],
  );
}
