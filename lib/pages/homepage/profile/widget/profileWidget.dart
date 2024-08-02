import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pickme_mobile/pages/homepage/profile/widget/profileAppBar.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'package:pickme_mobile/spec/properties.dart';
import 'package:pickme_mobile/spec/styles.dart';

Widget profileWidget({
  required BuildContext context,
  required void Function() onEditProfile,
  required void Function() onContactUs,
  required void Function() onWallet,
  required void Function() onEmergency,
  required void Function() onVendors,
  required void Function() onMyBookings,
  required void Function() onBusinessProfile,
  required void Function() onMyCart,
  required void Function() onNotifications,
  required void Function() onFavoriteSp,
  required void Function() onBecomeWorker,
  required void Function() onEnableFaceID,
  required void Function() onSettings,
  required bool isWorkerMode,
  required void Function(bool value) onWorkerMode,
}) {
  return NestedScrollView(
    headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
      return <Widget>[ProfileAppBar(onEdit: onEditProfile)];
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
                Text("Wallet Balance", style: Styles.h4BlackBold),
                Text("${Properties.curreny} 0.00", style: Styles.h4Primary),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _layout1(
                  context: context,
                  image: Images.contactUs,
                  name: 'Contact Us',
                  onTap: onContactUs,
                ),
                _layout1(
                  context: context,
                  image: Images.addMoney,
                  name: 'Wallet',
                  onTap: onWallet,
                ),
                _layout1(
                  context: context,
                  image: Images.emergency,
                  name: 'Emergency',
                  onTap: onEmergency,
                ),
                _layout1(
                  context: context,
                  image: Images.vendors2,
                  name: 'Vendors',
                  onTap: onVendors,
                ),
              ],
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: onBecomeWorker,
              child: Card(
                color: BColors.white,
                elevation: 5,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 120),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: BColors.primaryColor2.withOpacity(.2),
                    borderRadius: BorderRadius.circular(10),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: BColors.black.withOpacity(.3),
                    //     spreadRadius: .1,
                    //     blurRadius: 20,
                    //     offset: const Offset(0, 3),
                    //   ),
                    // ],
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Opacity(
                          opacity: .8,
                          child: Image.asset(Images.worker),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "BECOME A ${Properties.titleShort.toUpperCase()} WORKER",
                            style: Styles.h4BlackBold,
                          ),
                          const SizedBox(height: 7),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .6,
                            child: Text(
                              "Gain money as a PICKME Rider,\nDriver, Delivery guy or\nPersonal shopper.",
                              style: Styles.h6BlackBold,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: BColors.background,
              child: SwitchListTile(
                title: Text(
                  "${Properties.titleShort.toUpperCase()} Worker Mode",
                  style: Styles.h4BlackBold,
                ),
                subtitle: Text(
                  "Switch between the user and worker dashboards",
                  style: Styles.h7Black,
                ),
                value: isWorkerMode,
                onChanged: (bool value) => onWorkerMode(value),
                activeColor: BColors.primaryColor1,
              ),
            ),
            const SizedBox(height: 20),
            Text("General", style: Styles.h4BlackBold),
            ListTile(
              onTap: onMyBookings,
              // ignore: deprecated_member_use
              leading: SvgPicture.asset(Images.bookings, color: BColors.red),
              title: Text("My Bookings", style: Styles.h5BlackBold),
              // dense: true,
              // visualDensity: const VisualDensity(vertical: -3),
            ),
            ListTile(
              onTap: onEnableFaceID,
              leading: const Icon(
                FeatherIcons.smartphone,
                color: BColors.green,
              ),
              title: Text("Enable Face ID/Touch ID", style: Styles.h5BlackBold),
            ),
            ListTile(
              onTap: onBusinessProfile,
              leading: const Icon(
                Icons.account_circle_sharp,
                color: BColors.primaryColor,
              ),
              title: Text("Business Profile", style: Styles.h5BlackBold),
            ),
            ListTile(
              onTap: onMyCart,
              leading: const Icon(
                Icons.shopping_cart,
                color: BColors.primaryColor1,
              ),
              title: Text("My Cart", style: Styles.h5BlackBold),
            ),
            ListTile(
              onTap: onNotifications,
              leading: const Icon(Icons.notifications, color: BColors.red),
              title: Text("Notifications", style: Styles.h5BlackBold),
            ),
            ListTile(
              onTap: onFavoriteSp,
              leading: const Icon(Icons.favorite, color: BColors.green),
              title: Text(
                "Favorite Service Providers",
                style: Styles.h5BlackBold,
              ),
            ),
            ListTile(
              onTap: onSettings,
              leading: const Icon(FeatherIcons.settings),
              title: Text("Settings", style: Styles.h5BlackBold),
            ),
            const SizedBox(height: 30),
          ],
        ),
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
