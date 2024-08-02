import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickme_mobile/components/customBackButton.dart';
import 'package:pickme_mobile/components/customLoading.dart';
import 'package:pickme_mobile/config/mapFunction.dart';
import 'package:pickme_mobile/models/placeDetailsModel.dart';
import 'package:pickme_mobile/models/placePredictionModel.dart';
import 'package:pickme_mobile/models/ridePickUpModel.dart';
import 'package:pickme_mobile/pages/modules/rides/rideMap/widget/rideMapBottomWidget.dart';
import 'package:pickme_mobile/pages/modules/rides/rideMultiStopPlaces/rideMultiStopPlaces.dart';
import 'package:pickme_mobile/spec/arrays.dart';
import 'package:pickme_mobile/spec/colors.dart';

import 'widget/ridePlacesWidget.dart';

class RidePlaces extends StatefulWidget {
  final LatLng? currentLocation;

  const RidePlaces({
    super.key,
    required this.currentLocation,
  });

  @override
  State<RidePlaces> createState() => _RidePlacesState();
}

class _RidePlacesState extends State<RidePlaces> {
  Size _topWidgetSize = const Size(0, 200);

  Map<String, dynamic> _whereToMap = {};
  Map<String, dynamic> _pickUpMap = {};

  final TextEditingController _whereToController = TextEditingController();
  final TextEditingController _pickupController = TextEditingController();

  FocusNode? _whereToFocusNode, _pickupFocusNode;

  bool _isLoading = false;

  List<PlacePredictionModel> _placePredictions = [];
  RidePlaceFields _ridePlaceFields = RidePlaceFields.whereTo;
  PlaceDetailsModel? _currentLocationPlaceDetails;

  @override
  void initState() {
    super.initState();
    _whereToFocusNode = FocusNode();
    _pickupFocusNode = FocusNode();

    _getCurrentLocationDetails();

    _whereToFocusNode!.addListener(() {
      if (_whereToFocusNode!.hasFocus) {
        _pickupController.text = _pickUpMap["name"] ?? "My current location";
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _whereToFocusNode!.dispose();
    _pickupFocusNode!.dispose();
  }

  void _unFocusAllNodes() {
    _whereToFocusNode!.unfocus();
    _pickupFocusNode!.unfocus();
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
          ridePlacesWidget(
            context: context,
            onAddMultiStopsPlaces: () => _onAddMultiStopsPlaces(),
            onTopWidgetSize: (Size size) => _onTopWidgetSize(size),
            topWidgetSize: _topWidgetSize,
            onQuickPlace: (QuickPlace place) {},
            onRecentPlace: () {},
            whereToController: _whereToController,
            whereToFocusNode: _whereToFocusNode!,
            pickupController: _pickupController,
            pickupFocusNode: _pickupFocusNode!,
            onPlaceTyping: (String text, RidePlaceFields type) =>
                _onPlaceTyping(text, type),
            placePredictions: _placePredictions,
            onPlaceSelected: (PlacePredictionModel prediction) =>
                _onPlaceSelected(prediction),
            onClearPickupText: () => _onClearpickupText(),
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  Future<void> _onAddMultiStopsPlaces() async {
    if (_currentLocationPlaceDetails == null) {
      setState(() => _isLoading = true);
    }
    RidePickUpModel? model = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RideMultiStopPlaces(
          currentLocationPlaceDetails: _currentLocationPlaceDetails,
          currentLocation: widget.currentLocation,
        ),
      ),
    );
    if (model != null) {
      if (!mounted) return;
      Navigator.pop(context, model);
    }
  }

  void _onClearpickupText() {
    _pickupController.clear();
    setState(() {});
    _pickupFocusNode!.requestFocus();
  }

  Future<void> _onPlaceTyping(String text, RidePlaceFields type) async {
    _ridePlaceFields = type;
    _placePredictions = await getPlacePredictions(
      text,
      widget.currentLocation!,
    );
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
        _goBackToRideMap();
      } else if (_ridePlaceFields == RidePlaceFields.whereTo) {
        _whereToMap = picked;
        _whereToController.text = picked["name"];
        _goBackToRideMap();
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
    if (_whereToController.text.isNotEmpty &&
        _pickupController.text.isNotEmpty) {
      Map<String, dynamic> meta = {
        "pickup": _pickUpMap,
        "whereTo": _whereToMap,
        "busStops": [],
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

  Future<void> _getCurrentLocationDetails() async {
    setState(() => _isLoading = true);
    _pickupController.text = "My current location";
    _currentLocationPlaceDetails = await getPlaceDetailsFromCoordinates(
      widget.currentLocation!.latitude,
      widget.currentLocation!.longitude,
    );
    setState(() => _isLoading = false);

    if (_currentLocationPlaceDetails != null) {
      Map<String, dynamic> picked = {
        "name": _currentLocationPlaceDetails!.formattedAddress,
        "long": widget.currentLocation!.longitude,
        "lat": widget.currentLocation!.latitude,
      };
      _pickUpMap = picked;
    }
    _pickupController.text = _pickUpMap["name"] ?? "My current location";
    _whereToFocusNode!.requestFocus();
  }
}
