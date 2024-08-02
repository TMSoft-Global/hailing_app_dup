import 'package:flutter/material.dart';
import 'package:pickme_mobile/components/button.dart';
import 'package:pickme_mobile/components/measureSize.dart';
import 'package:pickme_mobile/components/textField.dart';
import 'package:pickme_mobile/models/placePredictionModel.dart';
import 'package:pickme_mobile/pages/modules/rides/rideMap/widget/rideMapBottomWidget.dart';
import 'package:pickme_mobile/spec/arrays.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/styles.dart';

Widget ridePlacesWidget({
  required BuildContext context,
  required void Function() onAddMultiStopsPlaces,
  required void Function() onRecentPlace,
  required void Function(Size size) onTopWidgetSize,
  required void Function(QuickPlace place) onQuickPlace,
  required void Function(String text, RidePlaceFields type) onPlaceTyping,
  required Size topWidgetSize,
  required TextEditingController whereToController,
  required FocusNode whereToFocusNode,
  required TextEditingController pickupController,
  required FocusNode pickupFocusNode,
  required List<PlacePredictionModel> placePredictions,
  required void Function(PlacePredictionModel prediction) onPlaceSelected,
  required Function() onClearPickupText,
}) {
  return Stack(
    children: [
      MeasureSize(
        onChange: (Size size) => onTopWidgetSize(size),
        child: Container(
          decoration: const BoxDecoration(
            color: BColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                dense: true,
                visualDensity: const VisualDensity(vertical: -3),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                leading: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: BColors.primaryColor),
                  ),
                  child: const Icon(
                    Icons.circle,
                    color: BColors.primaryColor,
                    size: 15,
                  ),
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("PICKUP", style: Styles.h7Black),
                    if (pickupFocusNode.hasFocus &&
                        pickupController.text.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                    ],
                  ],
                ),
                subtitle: textFormField(
                  controller: pickupController,
                  hintText: 'Enter pickup location',
                  focusNode: pickupFocusNode,
                  removeBorder: true,
                  onTextChange: (String text) => onPlaceTyping(
                    text,
                    RidePlaceFields.pickUp,
                  ),
                  icon: pickupFocusNode.hasFocus ? Icons.close : null,
                  onIconTap: onClearPickupText,
                  inputPadding: EdgeInsets.zero,
                ),
                trailing: !pickupFocusNode.hasFocus
                    ? button(
                        onPressed: onClearPickupText,
                        text: "Change",
                        color: BColors.primaryColor,
                        context: context,
                        useWidth: false,
                        textStyle: Styles.h6Black,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 32,
                        icon: const Icon(
                          Icons.watch_later_outlined,
                          color: BColors.white,
                        ),
                      )
                    : null,
              ),
              const Divider(thickness: .4, indent: 50),
              ListTile(
                dense: true,
                visualDensity: const VisualDensity(vertical: -3),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                leading: const Icon(
                  Icons.location_on,
                  color: BColors.primaryColor1,
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("WHERE TO", style: Styles.h7Black),
                    if (whereToFocusNode.hasFocus &&
                        whereToController.text.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                    ],
                  ],
                ),
                subtitle: textFormField(
                  controller: whereToController,
                  hintText: 'Enter destination',
                  focusNode: whereToFocusNode,
                  removeBorder: true,
                  onTextChange: (String text) => onPlaceTyping(
                    text,
                    RidePlaceFields.whereTo,
                  ),
                  inputPadding: EdgeInsets.zero,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.add_box),
                  color: BColors.primaryColor1,
                  onPressed: onAddMultiStopsPlaces,
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(top: topWidgetSize.height + 10),
        child: placePredictions.isNotEmpty
            ? ListView.builder(
                itemCount: placePredictions.length,
                itemBuilder: (context, index) {
                  List<String> splitText =
                      placePredictions[index].description.split(",");
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.place, color: BColors.black),
                    title: Text(splitText.first, style: Styles.h6BlackBold),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              for (int x = 1; x < splitText.length; ++x)
                                TextSpan(
                                  text:
                                      "${splitText[x]}${x < splitText.length - 1 ? ', ' : ''}",
                                  style: Styles.h6Black,
                                ),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                    onTap: () => onPlaceSelected(placePredictions[index]),
                  );
                },
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Favorite Locations", style: Styles.h5BlackBold),
                    const SizedBox(height: 10),
                    _layout(
                      text: "Set location on map",
                      color: BColors.primaryColor,
                      icon: Icons.location_on,
                      onTap: () => onQuickPlace(QuickPlace.setLocation),
                    ),
                    const SizedBox(height: 10),
                    _layout(
                      text: "Set home location",
                      color: BColors.primaryColor1,
                      icon: Icons.home_filled,
                      onTap: () => onQuickPlace(QuickPlace.home),
                    ),
                    const SizedBox(height: 10),
                    _layout(
                      text: "Set work location",
                      color: BColors.primaryColor,
                      icon: Icons.cases_rounded,
                      onTap: () => onQuickPlace(QuickPlace.office),
                    ),
                    const SizedBox(height: 20),
                    Text("Recent places", style: Styles.h5Black),
                    const SizedBox(height: 10),
                    _layout(
                      text: "JD Fast Food, Kasao Offtown",
                      color: BColors.transparent,
                      iconColor: BColors.black,
                      icon: Icons.restore,
                      iconSize: 25,
                      onTap: () => onRecentPlace(),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
      ),
    ],
  );
}

Widget _layout({
  required String text,
  required Color color,
  required IconData icon,
  Color? iconColor,
  double? iconSize,
  required void Function() onTap,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ListTile(
        onTap: onTap,
        dense: true,
        visualDensity: const VisualDensity(vertical: -3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: CircleAvatar(
          backgroundColor: color,
          radius: 15,
          child: Icon(
            icon,
            color: iconColor ?? BColors.white,
            size: iconSize ?? 15,
          ),
        ),
        title: Text(text, style: Styles.h6Black),
      ),
      const Divider(thickness: .2),
    ],
  );
}
