import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickme_mobile/components/customBackButton.dart';
import 'package:pickme_mobile/pages/homepage/workerHome/widget/workerHomeMap.dart';
import 'package:pickme_mobile/spec/arrays.dart';
import 'package:pickme_mobile/spec/colors.dart';

Widget workerMapWidget({
  required BuildContext context,
  required LatLng currentLocation,
  required Set<Marker> markers,
  required void Function(GoogleMapController controller) onMapCreated,
  required double zoom,
  required Set<Polyline> polylines,
  required void Function() onCurrentLocation,
  required void Function() onPaySales,
  required void Function() onBack,
  required void Function() onTTSVolume,
  required void Function() onGoogleMap,
  required bool isTTSVolumeMute,
  required void Function(int index) onOnOfflineToggle,
  required WorkerMapNextAction? mapNextAction,
}) {
  return Stack(
    children: [
      GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: zoom,
        ),
        zoomControlsEnabled: false,
        myLocationButtonEnabled: true,
        myLocationEnabled: false,
        markers: markers,
        polylines: polylines,
        onMapCreated: (controller) => onMapCreated(controller),
      ),
      Positioned(
        bottom: 60,
        right: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (mapNextAction == null) ...[
              _floatingLayout(
                onTap: () {},
                icon: const Icon(
                  Icons.radar,
                  color: BColors.black,
                ),
              ),
              const SizedBox(height: 10),
            ],
            _floatingLayout(
              onTap: onCurrentLocation,
              icon: const Icon(
                Icons.gps_fixed,
                color: BColors.black,
              ),
            ),
            if (mapNextAction == null) ...[
              const SizedBox(height: 10),
              _floatingLayout(
                onTap: () {},
                icon: const Icon(
                  FeatherIcons.hexagon,
                  color: BColors.black,
                ),
              ),
            ],
            if (mapNextAction == WorkerMapNextAction.accept ||
                mapNextAction == WorkerMapNextAction.onTrip) ...[
              const SizedBox(height: 10),
              _floatingLayout(
                onTap: onTTSVolume,
                icon: Icon(
                  isTTSVolumeMute ? FeatherIcons.volume2 : FeatherIcons.volumeX,
                  color: BColors.black,
                ),
              ),
              const SizedBox(height: 10),
              _floatingLayout(
                onTap: onGoogleMap,
                backgroundColor: BColors.primaryColor1,
                icon: const Icon(FeatherIcons.map, color: BColors.white),
              ),
            ],
          ],
        ),
      ),
      if (mapNextAction != null) SafeArea(child: customBackButton(onBack)),
      if (mapNextAction == null)
        workerHomeMap(
          context: context,
          onPaySales: onPaySales,
          onOnOfflineToggle: (int index) => onOnOfflineToggle(index),
        ),
    ],
  );
}

Widget _floatingLayout({
  required void Function() onTap,
  required Widget icon,
  Color? backgroundColor,
}) {
  return Container(
    margin: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: backgroundColor ?? BColors.white,
      boxShadow: [
        BoxShadow(
          color: BColors.black.withOpacity(.2),
          spreadRadius: .1,
          blurRadius: 20,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: IconButton(
      onPressed: onTap,
      icon: icon,
    ),
  );
}
