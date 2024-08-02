import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pickme_mobile/components/cachedImage.dart';
import 'package:pickme_mobile/components/circular.dart';
import 'package:pickme_mobile/config/globalFunction.dart';
import 'package:pickme_mobile/models/placemarkModel.dart';
import 'package:pickme_mobile/models/userModel.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'package:pickme_mobile/spec/properties.dart';
import 'package:pickme_mobile/spec/styles.dart';
import 'package:badges/badges.dart' as badges;

class HomeAppbar extends StatelessWidget {
  final void Function()? onSos;
  final void Function()? onNotification;
  final void Function()? onProfile;
  final Position? currentLocation;

  const HomeAppbar({
    super.key,
    @required this.onSos,
    @required this.onNotification,
    @required this.currentLocation,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: BColors.primaryColor,
      pinned: true,
      expandedHeight: 200,
      leading: IconButton(
        onPressed: onSos,
        icon: CircleAvatar(
          backgroundColor: BColors.red,
          radius: 30,
          child: Text("SOS", style: Styles.h6WhiteBold),
        ),
      ),
      title: Text(
        Properties.titleShort.toUpperCase(),
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: BColors.white,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: onProfile,
          child: Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 5),
            child: userModel?.data!.user!.picture != null
                ? circular(
                    child: cachedImage(
                      context: context,
                      image: "${userModel!.data!.user!.picture}",
                      height: 45,
                      width: 45,
                      placeholder: Images.defaultProfilePicOffline,
                    ),
                    size: 45,
                  )
                : CircleAvatar(
                    backgroundColor: BColors.white,
                    child: Text(
                      getDisplayName(),
                      style: Styles.h5BlackBold,
                    ),
                  ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Image.asset(
              Images.homeAppbar,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topRight,
              width: double.infinity,
            ),
            Container(
              margin: const EdgeInsets.only(top: 80, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.location_on,
                      color: BColors.white,
                    ),
                    horizontalTitleGap: 3,
                    title: currentLocation != null
                        ? FutureBuilder(
                            future: getLocationDetails(
                              lat: currentLocation!.latitude,
                              log: currentLocation!.longitude,
                            ),
                            builder: (BuildContext context,
                                AsyncSnapshot<PlacemarkModel?> snapshot) {
                              if (snapshot.hasData) {
                                PlacemarkModel? placemarkModel = snapshot.data;

                                return placemarkModel == null
                                    ? Text(
                                        "Unable to get current location",
                                        style: Styles.h6WhiteBold,
                                      )
                                    : Text(
                                        "${placemarkModel.thoroughfare != '' ? placemarkModel.thoroughfare : placemarkModel.subAdministrativeArea} ▼",
                                        style: Styles.h6WhiteBold,
                                      );
                              }
                              return Text(
                                "Loading...",
                                style: Styles.h6WhiteBold,
                              );
                            },
                          )
                        : Text("Loading...", style: Styles.h6WhiteBold),
                    trailing: IconButton(
                      onPressed: onNotification,
                      icon: badges.Badge(
                        badgeContent: Text('0', style: Styles.h5White),
                        child: const Icon(
                          FeatherIcons.bell,
                          color: BColors.white,
                        ),
                      ),
                      iconSize: 25,
                    ),
                  ),
                  Text(
                    "Welcome ${getDisplayName(initials: false)}",
                    style: Styles.h4WhiteBold,
                  ),
                  Text("We are ready to serve you!!", style: Styles.h5White),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(
          height: 15,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: BColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
