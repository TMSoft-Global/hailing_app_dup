import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:pickme_mobile/components/cachedImage.dart';
import 'package:pickme_mobile/components/circular.dart';
import 'package:pickme_mobile/config/globalFunction.dart';
import 'package:pickme_mobile/models/userModel.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'package:pickme_mobile/spec/properties.dart';
import 'package:pickme_mobile/spec/styles.dart';

Drawer workerHomeDrawer({
  required BuildContext context,
  required bool isWorkerMode,
  required void Function(bool value) onWorkerMode,
  required void Function() onMyServices,
  required void Function() onNotifications,
  required void Function() onRewards,
  required void Function() onPromotions,
  required void Function() onSettings,
  required void Function() onSupport,
}) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(
          height: 270,
          child: Stack(
            children: [
              Container(
                height: 270,
                alignment: Alignment.bottomLeft,
                color: BColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: userModel?.data!.user!.picture != null
                          ? circular(
                              child: cachedImage(
                                context: context,
                                image: "${userModel!.data!.user!.picture}",
                                height: 50,
                                width: 50,
                                placeholder: Images.defaultProfilePicOffline,
                              ),
                              size: 50,
                            )
                          : CircleAvatar(
                              backgroundColor: BColors.white,
                              radius: 30,
                              child: Text(
                                getDisplayName(),
                                style: Styles.h3BlackBold,
                              ),
                            ),
                      title: Text(
                        "${userModel!.data!.user!.name}",
                        style: Styles.h4WhiteBold,
                      ),
                      subtitle: Text(
                        "${userModel!.data!.user!.phone}",
                        style: Styles.h6White,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 30),
                        const Icon(Icons.star, color: BColors.yellow1),
                        const SizedBox(width: 10),
                        Text("4.9", style: Styles.h5WhiteBold),
                      ],
                    ),
                  ],
                ),
              ),
              Image.asset(Images.drawer),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SwitchListTile(
          title: Text(
            "${Properties.titleShort.toUpperCase()} Worker Mode",
            style: Styles.h4BlackBold,
          ),
          subtitle: Text(
            "Switch between the user and worker dashboards",
            style: Styles.h6Black,
          ),
          value: isWorkerMode,
          onChanged: (bool value) => onWorkerMode(value),
          activeColor: BColors.primaryColor1,
        ),
        const SizedBox(height: 30),
        ListTile(
          onTap: onMyServices,
          leading: const Icon(FeatherIcons.fileText),
          title: Text("My Services", style: Styles.h5BlackBold),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: BColors.primaryColor2.withOpacity(.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text("2", style: Styles.h6BlackBold),
          ),
        ),
        ListTile(
          onTap: onNotifications,
          leading: const Icon(FeatherIcons.bell),
          title: Text("Notifications", style: Styles.h5BlackBold),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: BColors.primaryColor2.withOpacity(.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text("2", style: Styles.h6BlackBold),
          ),
        ),
        ListTile(
          onTap: onRewards,
          leading: const Icon(FeatherIcons.award),
          title: Text("Rewards", style: Styles.h5BlackBold),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: BColors.primaryColor1.withOpacity(.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text("2", style: Styles.h6BlackBold),
          ),
        ),
        ListTile(
          onTap: onPromotions,
          leading: const Icon(FeatherIcons.award),
          title: Text("Promotions", style: Styles.h5BlackBold),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: BColors.primaryColor1.withOpacity(.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text("2", style: Styles.h6BlackBold),
          ),
        ),
        ListTile(
          onTap: onSettings,
          leading: const Icon(FeatherIcons.settings),
          title: Text("Settings", style: Styles.h5BlackBold),
        ),
        ListTile(
          onTap: onSupport,
          leading: const Icon(FeatherIcons.phone),
          title: Text("Support", style: Styles.h5BlackBold),
        ),
      ],
    ),
  );
}
