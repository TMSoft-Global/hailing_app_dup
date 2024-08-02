import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickme_mobile/components/button.dart';
import 'package:pickme_mobile/components/customBackButton.dart';
import 'package:pickme_mobile/components/customLoading.dart';
import 'package:pickme_mobile/components/toast.dart';
import 'package:pickme_mobile/config/mapFunction.dart';
import 'package:pickme_mobile/models/placeDetailsModel.dart';
import 'package:pickme_mobile/models/placePredictionModel.dart';
import 'package:pickme_mobile/models/ridePickUpModel.dart';
import 'package:pickme_mobile/spec/arrays.dart';
import 'package:pickme_mobile/spec/colors.dart';

import 'widget/rideMultiStopPlacesWidget.dart';

class RideMultiStopPlaces extends StatefulWidget {
  final PlaceDetailsModel? currentLocationPlaceDetails;
  final LatLng? currentLocation;

  const RideMultiStopPlaces({
    super.key,
    required this.currentLocationPlaceDetails,
    required this.currentLocation,
  });

  @override
  State<RideMultiStopPlaces> createState() => _RideMultiStopPlacesState();
}

class _RideMultiStopPlacesState extends State<RideMultiStopPlaces> {
  Size _topWidgetSize = const Size(0, 200);

  Map<String, dynamic> _pickUpMap = {};
  final List<Map<String, dynamic>> _multiPlaceList = [];

  final TextEditingController _pickupController = TextEditingController();

  FocusNode? _pickupFocusNode;

  bool _isLoading = false;

  List<PlacePredictionModel> _placePredictions = [];
  RidePlaceFields _ridePlaceFields = RidePlaceFields.whereTo;

  int _currentStopField = 0;

  @override
  void initState() {
    super.initState();
    _pickupFocusNode = FocusNode();

    Map<String, dynamic> picked = {
      "name": widget.currentLocationPlaceDetails!.formattedAddress,
      "long": widget.currentLocation!.longitude,
      "lat": widget.currentLocation!.latitude,
    };
    _pickUpMap = picked;
    _pickupController.text = _pickUpMap["name"] ?? "My current location";

    _onAddStopsTextBox(true);
    _onAddStopsTextBox(false);
  }

  @override
  void dispose() {
    super.dispose();
    _pickupFocusNode!.dispose();
  }

  void _unFocusAllNodes() {
    _pickupFocusNode!.unfocus();
    for (var data in _multiPlaceList) {
      (data["focus"] as FocusNode).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BColors.background,
      appBar: AppBar(
        backgroundColor: BColors.background,
        leading: customBackButton(() {
          Navigator.pop(context);
        }),
        leadingWidth: 150,
      ),
      body: Stack(
        children: [
          rideMultiStopPlacesWidget(
            context: context,
            onRemoveStopOver: (int index) => _onRemoveStopOver(index),
            onTopWidgetSize: (Size size) => _onTopWidgetSize(size),
            topWidgetSize: _topWidgetSize,
            pickupController: _pickupController,
            pickupFocusNode: _pickupFocusNode!,
            onPlaceTyping: (String text, RidePlaceFields type, int? index) =>
                _onPlaceTyping(text, type, index),
            placePredictions: _placePredictions,
            onPlaceSelected: (PlacePredictionModel prediction) =>
                _onPlaceSelected(prediction),
            onClearPickupText: () => _onClearpickupText(),
            multiPlaceList: _multiPlaceList,
            onClearStopText: (int index) => _onClearStopText(index),
            onMapPickerStop: (int index) {},
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
      bottomNavigationBar: Container(
        color: BColors.white,
        padding: const EdgeInsets.all(10),
        child: button(
          onPressed: () => _goBackToRideMap(),
          text: "Done",
          color: BColors.primaryColor,
          context: context,
        ),
      ),
    );
  }

  void _onClearStopText(int index) {
    (_multiPlaceList[index]["place"] as TextEditingController).clear();
    _multiPlaceList[index]["lat"] = 0;
    _multiPlaceList[index]["long"] = 0;
    setState(() {});
  }

  void _onClearpickupText() {
    _pickupController.clear();
    setState(() {});
    _pickupFocusNode!.requestFocus();
  }

  Future<void> _onPlaceTyping(
      String text, RidePlaceFields type, int? index) async {
    _ridePlaceFields = type;
    _placePredictions = await getPlacePredictions(
      text,
      widget.currentLocation!,
    );
    _currentStopField = index ?? _currentStopField;
    setState(() {});
  }

  void _onRemoveStopOver(int index) {
    _multiPlaceList.removeAt(index);
    setState(() {});
  }

  Future<void> _onPlaceSelected(PlacePredictionModel prediction) async {
    _unFocusAllNodes();
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      setState(() => _isLoading = true);
      PlaceDetailsModel placeDetailsModel =
          await getPlaceDetails(prediction.placeId);
      setState(() => _isLoading = false);
      Map<String, dynamic> picked = {
        "name": prediction.description,
        "long": placeDetailsModel.lng,
        "lat": placeDetailsModel.lat,
      };

      if (_ridePlaceFields == RidePlaceFields.pickUp) {
        _pickUpMap = picked;
        _pickupController.text = picked["name"];
        // _goBackToRideMap();
      } else if (_ridePlaceFields == RidePlaceFields.stopOvers) {
        (_multiPlaceList[_currentStopField]["place"] as TextEditingController)
            .text = picked["name"];
        _multiPlaceList[_currentStopField]["lat"] = placeDetailsModel.lat;
        _multiPlaceList[_currentStopField]["long"] = placeDetailsModel.lng;
        _multiPlaceList[_currentStopField]["showClose"] = true;

        if (_currentStopField == _multiPlaceList.length - 1) {
          _onAddStopsTextBox(false);
        }
        setState(() {});
        // _goBackToRideMap();
      }

      _placePredictions.clear();

      if (!mounted) return;
      setState(() {});
    } on Exception catch (_, e) {
      setState(() => _isLoading = false);
      log("Place picker => ${e.toString()}");
    }
  }

  void _goBackToRideMap() {
    if (_pickupController.text.isNotEmpty) {
      Map<String, dynamic> whereToMap = {};
      final List<Map<String, dynamic>> busStopsList = [];
      for (var data in _multiPlaceList) {
        if (data["lat"] != 0 && data["long"] != 0) {
          busStopsList.add({
            "name": (data["place"] as TextEditingController).text,
            "long": data["long"],
            "lat": data["lat"],
          });
        }
      }

      if (busStopsList.isNotEmpty) {
        whereToMap = busStopsList.last;
        busStopsList.removeAt(busStopsList.length - 1);
      } else {
        toastContainer(text: "Enter destination", backgroundColor: BColors.red);
        return;
      }

      Map<String, dynamic> meta = {
        "pickup": _pickUpMap,
        "whereTo": whereToMap,
        "busStops": busStopsList,
      };
      RidePickUpModel model = RidePickUpModel.fromJson(meta);

      if (!mounted) return;
      Navigator.pop(context, model);
    }
  }

  void _onTopWidgetSize(Size size) {
    _topWidgetSize = size;
    setState(() {});
  }

  void _onAddStopsTextBox(bool showClose) {
    Map<String, dynamic> meta = {
      "place": TextEditingController(),
      "focus": FocusNode(),
      "lat": 0,
      "long": 0,
      "showClose": showClose
    };

    _multiPlaceList.add(meta);

    for (var data in _multiPlaceList) {
      (data["focus"] as FocusNode).addListener(() {
        _pickupController.text = _pickUpMap["name"] ?? "My current location";
        if (mounted) setState(() {});
      });
    }
  }
}
