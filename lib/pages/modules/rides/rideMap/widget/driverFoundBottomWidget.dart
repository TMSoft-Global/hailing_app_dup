import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pickme_mobile/components/button.dart';
import 'package:pickme_mobile/components/cachedImage.dart';
import 'package:pickme_mobile/components/circular.dart';
import 'package:pickme_mobile/spec/arrays.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'package:pickme_mobile/spec/properties.dart';
import 'package:pickme_mobile/spec/styles.dart';

Widget driverFoundBottomWidget({
  required BuildContext context,
  required void Function() onChat,
  required void Function() onCall,
  required void Function() onConfirm,
  required void Function() onCancelRequest,
  required void Function() onConfirmArrivedDestination,
  required void Function() onTrackDeliveryOrder,
  required RideMapNextAction rideNextAction,
  required ServicePurpose servicePurpose,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              rideNextAction == RideMapNextAction.bookingSuccess
                  ? "Driver Found. He's driving to you"
                  : rideNextAction == RideMapNextAction.driverArrived
                      ? "Driver has arrived"
                      : rideNextAction == RideMapNextAction.drivingToDestination
                          ? "Driving to destination"
                          : rideNextAction ==
                                  RideMapNextAction.arrivedDestination
                              ? "You’ve arrived at your destination"
                              : rideNextAction ==
                                      RideMapNextAction.searchingDriver
                                  ? "Searching for a ${servicePurpose == ServicePurpose.personalShopper ? 'Shopper' : servicePurpose == ServicePurpose.ride ? 'driver' : 'Delivery Guy'}"
                                  : "${servicePurpose == ServicePurpose.personalShopper ? 'Shopper' : servicePurpose == ServicePurpose.ride ? 'driver' : 'Delivery Guy'} Found",
              style: rideNextAction == RideMapNextAction.arrivedDestination ||
                      rideNextAction ==
                          RideMapNextAction.drivingToDestination ||
                      rideNextAction == RideMapNextAction.driverArrived
                  ? Styles.h4BlackBold
                  : Styles.h6BlackBold,
            ),
            rideNextAction != RideMapNextAction.searchingDriver
                ? const SizedBox()
                : const SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(value: null),
                  ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: BColors.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: rideNextAction == RideMapNextAction.searchingDriver
                ? null
                : circular(
                    child: cachedImage(
                      context: context,
                      image: "",
                      height: 50,
                      width: 50,
                      placeholder: Images.defaultProfilePicOffline,
                    ),
                    size: 50,
                  ),
            title: rideNextAction == RideMapNextAction.searchingDriver
                ? const SizedBox()
                : Text("Gregory Smith", style: Styles.h4BlackBold),
            subtitle: rideNextAction == RideMapNextAction.searchingDriver
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: BColors.yellow1),
                      const SizedBox(width: 10),
                      Text("4.9", style: Styles.h6Black),
                    ],
                  ),
            trailing: rideNextAction == RideMapNextAction.searchingDriver ||
                    rideNextAction == RideMapNextAction.drivingToDestination ||
                    rideNextAction == RideMapNextAction.arrivedDestination
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: BColors.primaryColor,
                        radius: 25,
                        child: IconButton(
                          icon: SvgPicture.asset(Images.message),
                          color: BColors.white,
                          onPressed: onChat,
                        ),
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        backgroundColor: BColors.primaryColor1,
                        radius: 25,
                        child: IconButton(
                          icon: const Icon(Icons.call),
                          color: BColors.white,
                          onPressed: onCall,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 20),
        if (rideNextAction != RideMapNextAction.arrivedDestination)
          if (rideNextAction != RideMapNextAction.drivingToDestination) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int x = 0; x < 3; ++x) ...[
                    rideNextAction == RideMapNextAction.searchingDriver
                        ? Container(
                            height: 35,
                            width: 35,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: BColors.assDeep1,
                            ),
                          )
                        : circular(
                            child: cachedImage(
                              context: context,
                              image: "",
                              height: 35,
                              width: 35,
                              placeholder: Images.defaultProfilePicOffline,
                            ),
                            size: 35,
                          ),
                    const SizedBox(width: 5),
                  ],
                  const SizedBox(width: 10),
                  Text(
                    rideNextAction == RideMapNextAction.searchingDriver
                        ? "Looking for ${servicePurpose == ServicePurpose.personalShopper ? 'shopper' : servicePurpose == ServicePurpose.ride ? 'driver' : 'Delivery Guy'}"
                        : "25 Recommended",
                    style: Styles.h5BlackBold,
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
        if (rideNextAction != RideMapNextAction.arrivedDestination)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              servicePurpose == ServicePurpose.ride
                  ? SvgPicture.asset(
                      Images.carSvg,
                      height: 25,
                      // ignore: deprecated_member_use
                      color: BColors.black,
                    )
                  : const Icon(
                      FeatherIcons.box,
                      size: 30,
                      color: BColors.black,
                    ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("DISTANCE", style: Styles.h6Black),
                    const SizedBox(height: 5),
                    Text("0.2 Km", style: Styles.h5BlackBold),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("TIME", style: Styles.h6Black),
                    const SizedBox(height: 5),
                    Text("2 min", style: Styles.h5BlackBold),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("PRICE", style: Styles.h6Black),
                    const SizedBox(height: 5),
                    Text(
                      "${Properties.curreny} 45.00",
                      style: Styles.h5BlackBold,
                    ),
                  ],
                ),
              ),
            ],
          ),
        const SizedBox(height: 10),
        if (rideNextAction == RideMapNextAction.bookingSuccess ||
            rideNextAction == RideMapNextAction.driverFound ||
            rideNextAction == RideMapNextAction.arrivedDestination ||
            rideNextAction == RideMapNextAction.searchingDriver)
          button(
            onPressed: rideNextAction == RideMapNextAction.arrivedDestination
                ? onConfirmArrivedDestination
                : rideNextAction == RideMapNextAction.bookingSuccess ||
                        rideNextAction == RideMapNextAction.searchingDriver
                    ? onCancelRequest
                    : servicePurpose == ServicePurpose.deliveryRunnerSingle ||
                            servicePurpose ==
                                ServicePurpose.deliveryRunnerMultiple
                        ? onTrackDeliveryOrder
                        : onConfirm,
            text: rideNextAction == RideMapNextAction.bookingSuccess ||
                    rideNextAction == RideMapNextAction.searchingDriver
                ? "Cancel Request"
                : servicePurpose == ServicePurpose.deliveryRunnerSingle ||
                        servicePurpose == ServicePurpose.deliveryRunnerMultiple
                    ? "Track Order"
                    : "Confirm",
            color: BColors.primaryColor,
            context: context,
          ),
        const SizedBox(height: 10),
      ],
    ),
  );
}
