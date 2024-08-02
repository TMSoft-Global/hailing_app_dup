import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_picker/google_places_picker.dart';
import 'package:pickme_mobile/components/customMapInfoWindow.dart';
import 'package:pickme_mobile/components/toast.dart';
import 'package:pickme_mobile/config/dummyCordinateGenerator.dart';
import 'package:pickme_mobile/config/mapFunction.dart';
import 'package:pickme_mobile/config/navigation.dart';
import 'package:pickme_mobile/models/ridePickUpModel.dart';
import 'package:pickme_mobile/pages/modules/deliveries/deliveryRunner/deliveryRecipient/deliveryRecipientDetails/deliveryRecipientDetails.dart';
import 'package:pickme_mobile/pages/modules/deliveries/deliveryRunner/deliverySingleMultiOption/widget/delierySendReceiveItemMap.dart';
import 'package:pickme_mobile/pages/modules/deliveries/deliveryRunner/trackDeliveryOrder/trackDeliveryOrder.dart';
import 'package:pickme_mobile/pages/modules/deliveries/deliveryRunner/trackDeliveryOrder/widget/trackDeliveryDriverMap.dart';
import 'package:pickme_mobile/pages/modules/deliveries/personalShopper/trackShopperOrder/trackShopperOrder.dart';
import 'package:pickme_mobile/pages/modules/deliveries/personalShopper/trackShopperOrder/widget/trackDriverMap.dart';
import 'package:pickme_mobile/pages/modules/payments/paymentmethod/paymentmethod.dart';
import 'package:pickme_mobile/pages/modules/rides/rideConfirmAmount/rideConfirmAmount.dart';
import 'package:pickme_mobile/pages/modules/rides/rideMap/widget/confirmRideSuccessDialog.dart';
import 'package:pickme_mobile/pages/modules/rides/rideMap/widget/driverFoundBottomWidget.dart';
import 'package:pickme_mobile/pages/modules/rides/rideMap/widget/selectRideBottomWidget.dart';
import 'package:pickme_mobile/pages/modules/rides/ridePlaces/ridePlaces.dart';
import 'package:pickme_mobile/spec/arrays.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'package:pickme_mobile/spec/properties.dart';
import 'dart:ui' as ui;
import 'package:rxdart/rxdart.dart';

import 'widget/rideMapBottomWidget.dart';
import 'widget/rideMapWidget.dart';

class RideMap extends StatefulWidget {
  final Position? currentLocation;
  final RideMapNextAction mapNextAction;
  final ServicePurpose servicePurpose;
  final List<LatLng>? trackingPositions;
  final Map<dynamic, dynamic>? deliveryAddresses;

  const RideMap({
    super.key,
    required this.currentLocation,
    this.mapNextAction = RideMapNextAction.selectRide,
    this.servicePurpose = ServicePurpose.ride,
    this.trackingPositions,
    this.deliveryAddresses,
  });

  @override
  State<RideMap> createState() => _RideMapState();
}

class _RideMapState extends State<RideMap> with SingleTickerProviderStateMixin {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  Position? _currentLocationPosition;
  LatLng? _currentLocation;
  StreamSubscription<Position>? _positionStream;

  BitmapDescriptor? _currentLocationIcon,
      _carIcon,
      _shopperIcon,
      _pinIcon,
      _destinationIcon;

  final double _zoom = 14.4746;

  static const MarkerId _currentLocationMarkerId = MarkerId('currentLocation');
  bool _showCurrentLocationMaker = true, _showSearchPlaceWidget = true;

  final _fetcher = BehaviorSubject<RidePickUpModel>();
  Sink<RidePickUpModel> get ridePickUpfetcherSink => _fetcher.sink;
  Stream<RidePickUpModel> get ridePickUpStream => _fetcher.stream;
  StreamSubscription<RidePickUpModel>? _ridePickUpStreamSubscription;

  RideMapNextAction? _rideNextAction;

  List<LatLng> _locationUnableToZoom = [];

  // adding new Address
  final _newAddressHouseNoController = new TextEditingController();
  final _newAddressLandmarkController = new TextEditingController();
  final _newAddressPhoneController = new TextEditingController();

  Map<dynamic, dynamic> _deliveryAddresses = {};

  AnimationController? _animationController;
  late Animation<double> _animation;

  bool _initialMoveCameraPosition = true;
  OverlayEntry? _overlayEntry;
  LatLng? _overlayCordinate;
  String _overlayMsg = "";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!);

    PluginGooglePlacePicker.initialize(
      androidApiKey: Properties.googleApiKey,
      iosApiKey: Properties.googleApiKey,
    );
    _rideNextAction = widget.mapNextAction;

    if (widget.currentLocation != null) {
      _currentLocationPosition = widget.currentLocation;
      _currentLocation = LatLng(
        _currentLocationPosition!.latitude,
        _currentLocationPosition!.longitude,
      );

      _getCurrentLocation();
    } else if (widget.trackingPositions != null) {
      _currentLocation = LatLng(
        widget.trackingPositions!.first.latitude,
        widget.trackingPositions!.first.longitude,
      );
    } else {
      throw Exception(
        "Current location position or tracking position, can't be null",
      );
    }
    _loadCustomMarkerAssets();

    // search ride for personal shopper and delivery runner single
    if ((widget.servicePurpose == ServicePurpose.personalShopper &&
            widget.mapNextAction != RideMapNextAction.trackDriver) ||
        (widget.mapNextAction == RideMapNextAction.searchingDriver &&
            (widget.servicePurpose == ServicePurpose.deliveryRunnerSingle ||
                widget.servicePurpose ==
                    ServicePurpose.deliveryRunnerMultiple) &&
            widget.deliveryAddresses != null)) {
      _showSearchPlaceWidget = false;
      _selectRideRequest();
    }

    if (widget.mapNextAction == RideMapNextAction.trackDriver) {
      _showSearchPlaceWidget = false;
      _trackDriver();
    }

    if (widget.currentLocation != null) {
      _deliveryAddresses = {
        DeliveryAccessLocation.pickUpLocation: {
          "name": "",
          "long": widget.currentLocation!.longitude,
          "lat": widget.currentLocation!.latitude,
        }
      };
    }

    if (widget.mapNextAction == RideMapNextAction.deliverySendItem ||
        widget.mapNextAction == RideMapNextAction.deliveryReceiveItem) {
      _showSearchPlaceWidget = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _positionStream?.cancel();
    _ridePickUpStreamSubscription?.cancel();
    _animationController?.dispose();
    _overlayEntry?.remove();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool invoke) {
        if (invoke) return;
        _onBack();
      },
      child: Scaffold(
        body: rideMapWidget(
          context: context,
          currentLocation: _currentLocation!,
          markers: _markers,
          onMapCreated: (GoogleMapController controller) => _onMapCreated(
            controller,
          ),
          zoom: _zoom,
          onBack: () => _onBack(),
          onCurrentLocation: () => _onMoveCameraToCurrentLocation(),
          onQuickPlace: (QuickPlace place) => _onQuickPlace(place),
          showSearchPlace: _showSearchPlaceWidget,
          polylines: _polylines,
          rideNextAction: _rideNextAction!,
          newAddressSave: () => _onNewAddressSave(),
          onChangeDeliveryLocation: (DeliveryAccessLocation value) =>
              _onChangeDeliveryLocation(value),
          newAddressHouseNoController: _newAddressHouseNoController,
          newAddressLandmarkController: _newAddressLandmarkController,
          newAddressPhoneController: _newAddressPhoneController,
          deliveryAddresses: _deliveryAddresses,
          onCameraMove: (CameraPosition position) => _onCameraMove(position),
        ),
        bottomNavigationBar: !_showSearchPlaceWidget
            ? _rideNextAction == RideMapNextAction.deliverySendItem ||
                    _rideNextAction == RideMapNextAction.deliveryReceiveItem
                ? deliverySendReceiveItemMap(
                    context: context,
                    onChangeLocation: (DeliveryAccessLocation value) =>
                        _onChangeDeliveryLocation(
                      value,
                    ),
                    onDeliveryStartProceed: () => _onDeliveryStartProceed(),
                    deliveryAddresses: _deliveryAddresses,
                    rideNextAction: _rideNextAction!,
                  )
                : _rideNextAction == RideMapNextAction.selectRide
                    ? selectRideBottomWidget(
                        context: context,
                        onPaymentMethod: () => _onPaymentMethod(),
                        onRequest: () => _selectRideRequest(),
                      )
                    : _rideNextAction == RideMapNextAction.trackDriver
                        ? widget.servicePurpose ==
                                ServicePurpose.personalShopper
                            ? trackDriverMap(
                                context: context,
                                onCall: () {},
                                onChat: () {},
                              )
                            : trackDeliveryDriverMap(
                                context: context,
                                onCall: () {},
                                onChat: () {},
                              )
                        : driverFoundBottomWidget(
                            context: context,
                            onChat: () {},
                            onCall: () {},
                            onConfirm: () => _onConfirmDriverFound(),
                            rideNextAction: _rideNextAction!,
                            onCancelRequest: () => _onCancelRequest(),
                            onConfirmArrivedDestination: () =>
                                _onConfirmArrivedDestination(),
                            servicePurpose: widget.servicePurpose,
                            onTrackDeliveryOrder: () => _onTrackDeliveryOrder(),
                          )
            : null,
      ),
    );
  }

  void _onCameraMove(CameraPosition position) {
    if (_overlayCordinate == null &&
        _controller == null &&
        _overlayEntry == null) return;

    _showCustomInfoWindow();
  }

  void _onBack() {
    if (!_showSearchPlaceWidget &&
        widget.servicePurpose == ServicePurpose.ride) {
      _overlayEntry?.remove();
      _animationController?.stop();
      _onCancelRequest();
      _initialMoveCameraPosition = true;
      _getCurrentLocation();
      setState(() {});
      return;
    }
    navigation(context: context, pageName: "back");
  }

  void _onTrackDeliveryOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrackDeliveryOrder(
          servicePurpose: widget.servicePurpose,
          deliveryAddresses: widget.deliveryAddresses!,
        ),
      ),
    );
  }

  void _onDeliveryStartProceed() {
    if (_deliveryAddresses[DeliveryAccessLocation.pickUpLocation] != null &&
        _deliveryAddresses[DeliveryAccessLocation.whereToLocation] != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeliveryRecipientDetails(
            rideMapNextAction: widget.mapNextAction,
            servicePurpose: widget.servicePurpose,
            deliveryAddresses: _deliveryAddresses,
          ),
        ),
      );
    } else {
      toastContainer(
        text: "Enter location to continue",
        backgroundColor: BColors.red,
      );
    }
  }

  Future<void> _onChangeDeliveryLocation(DeliveryAccessLocation value) async {
    var place = await PluginGooglePlacePicker.showAutocomplete(
      mode: PlaceAutocompleteMode.MODE_OVERLAY,
      countryCode: "GH",
    );
    String placeName = place.name ?? "Null place name!";

    if (value == DeliveryAccessLocation.pickUpLocation) {
      _deliveryAddresses.addAll({
        DeliveryAccessLocation.pickUpLocation: {
          "name": placeName,
          "long": place.longitude,
          "lat": place.latitude,
        }
      });
    } else {
      _deliveryAddresses.addAll({
        DeliveryAccessLocation.whereToLocation: {
          "name": placeName,
          "long": place.longitude,
          "lat": place.latitude,
        }
      });
    }

    if (widget.mapNextAction == RideMapNextAction.deliverySendItem ||
        widget.mapNextAction == RideMapNextAction.deliveryReceiveItem) {
      LatLng pickUpLocation = LatLng(
        _deliveryAddresses[DeliveryAccessLocation.pickUpLocation]["lat"],
        _deliveryAddresses[DeliveryAccessLocation.pickUpLocation]["long"],
      );
      LatLng? whereToLocation =
          _deliveryAddresses[DeliveryAccessLocation.whereToLocation] != null
              ? LatLng(
                  _deliveryAddresses[DeliveryAccessLocation.whereToLocation]
                      ["lat"],
                  _deliveryAddresses[DeliveryAccessLocation.whereToLocation]
                      ["long"],
                )
              : null;

      Marker pickUpLocationMarker = Marker(
        markerId: const MarkerId("pickUpLocation"),
        position: pickUpLocation,
        infoWindow: InfoWindow(
          title: _deliveryAddresses[DeliveryAccessLocation.pickUpLocation]
                      ["name"] !=
                  null
              ? "My Current Location"
              : _deliveryAddresses[DeliveryAccessLocation.pickUpLocation]
                  ["name"],
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );

      Marker? whereToMarker = whereToLocation != null
          ? Marker(
              markerId: const MarkerId("whereToLocation"),
              position: whereToLocation,
              infoWindow: InfoWindow(
                title:
                    _deliveryAddresses[DeliveryAccessLocation.whereToLocation]
                        ["name"],
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet,
              ),
            )
          : null;

      await _setDeliveryMarkersPolylinesCarsToMap(
        pickUpLocationMarker: pickUpLocationMarker,
        whereToMarker: whereToMarker,
        pickUpLocation: pickUpLocation,
        whereToLocation: whereToLocation,
      );
    }
    setState(() {});
  }

  Future<void> _setDeliveryMarkersPolylinesCarsToMap({
    required Marker pickUpLocationMarker,
    required Marker? whereToMarker,
    required LatLng pickUpLocation,
    required LatLng? whereToLocation,
  }) async {
    _markers.clear();
    _showCurrentLocationMaker = false;
    _polylines.clear();

    _markers.addAll({
      pickUpLocationMarker,
      if (whereToMarker != null) whereToMarker,
    });

    if (whereToMarker != null) {
      Set<Polyline>? polySet = await fetchRouteAndSetPolyline(
        polylineKey: 'deliveryPolyline',
        color: BColors.primaryColor,
        locations: [pickUpLocation, whereToLocation!],
      );

      if (polySet != null) {
        _polylines = polySet;
      } else {
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('deliveryPolyline'),
            visible: true,
            points: [pickUpLocation, whereToLocation],
            color: BColors.primaryColor,
            width: 5,
          ),
        );
      }
      setState(() {});

      _zoomToFitMarkers(
        pickUpLocation,
        whereToLocation,
        padding: 100,
      );

      Future.delayed(const Duration(seconds: 1), () {
        _controller?.showMarkerInfoWindow(const MarkerId('whereToLocation'));
      });
    }
  }

  Future<void> _trackDriver() async {
    // location 1
    Marker deliveryMarker = Marker(
      markerId: const MarkerId("deliveryLocation"),
      position: widget.trackingPositions![0],
      infoWindow: const InfoWindow(title: "Delivery Location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    );

    // loading shopper asset image
    final Uint8List shopperIcon = await _getBytesFromAsset(
      widget.servicePurpose == ServicePurpose.personalShopper
          ? Images.mapShopper
          : Images.mapDeliveryRunner,
      150,
    );
    _shopperIcon = BitmapDescriptor.fromBytes(shopperIcon);
    // location 2
    Marker driverMarker = Marker(
      markerId: const MarkerId("driverLocation"),
      position: widget.trackingPositions![1],
      infoWindow: const InfoWindow(title: "Driver Location"),
      icon: _shopperIcon!,
    );

    _markers.addAll({deliveryMarker, driverMarker});

    Set<Polyline>? polySet = await fetchRouteAndSetPolyline(
      locations: widget.trackingPositions!,
      polylineKey: 'trackingPolyline',
      color: BColors.primaryColor,
    );

    if (polySet != null) {
      _polylines = polySet;
    } else {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('trackingPolyline'),
          visible: true,
          points: [widget.trackingPositions![0], widget.trackingPositions![1]],
          color: BColors.primaryColor,
          width: 5,
        ),
      );
    }
    setState(() {});

    await _zoomToFitMarkers(
      widget.trackingPositions![0],
      widget.trackingPositions![1],
    );
  }

  Future<void> _onCancelRequest() async {
    if (widget.servicePurpose == ServicePurpose.deliveryRunnerSingle ||
        widget.servicePurpose == ServicePurpose.deliveryRunnerMultiple) {
      // TODO: ask if this is fexible because booking have being done
      return;
    }

    _rideNextAction = RideMapNextAction.selectRide;
    _markers.clear();
    _polylines.clear();
    _showSearchPlaceWidget = true;
    _showCurrentLocationMaker = true;
    await _getCurrentLocation();
    setState(() {});

    if (widget.servicePurpose == ServicePurpose.personalShopper) {
      if (!mounted) return;
      navigation(context: context, pageName: "back");
    }
  }

  void _onNewAddressSave() {
    //TODO: fix controller values not
    Map<dynamic, dynamic> meta = {
      ..._deliveryAddresses,
      "houseNo": _newAddressHouseNoController.text,
      "landmark": _newAddressLandmarkController.text,
      "phone": _newAddressPhoneController.text,
    };

    Navigator.pop(context, meta);
  }

  void _onConfirmArrivedDestination() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const RideConfirmAmount(),
        ),
        (Route<dynamic> route) => false);
  }

  void _onConfirmDriverFound() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => confirmRideSuccessDialog(
        context: context,
        onDialogAction: (String action) {
          if (action == "done") {
            if (widget.servicePurpose == ServicePurpose.personalShopper) {
              navigation(context: context, pageName: "homepage");
              return;
            }
            Navigator.pop(context);
            _completeBookingRide();
          } else if (action == "trackDeliveryOrder") {
            _trackDeliveryOrder();
          } else {
            Navigator.pop(context);
          }
        },
        servicePurpose: widget.servicePurpose,
      ),
    );
  }

  void _trackDeliveryOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TrackShopperOrder(),
      ),
    );
  }

  Future<void> _completeBookingRide() async {
    // TODO: add submit function also make bookingSuccess, etc.
    _rideNextAction = RideMapNextAction.bookingSuccess;
    setState(() {});

    // TODO: sample code
    await Future.delayed(const Duration(seconds: 3), () {
      _rideNextAction = RideMapNextAction.arrivedDestination;
      setState(() {});
    });
  }

  Future<void> _selectRideRequest() async {
    _overlayEntry?.remove();
    _rideNextAction = RideMapNextAction.searchingDriver;
    setState(() {});

    // TODO: sample code
    await Future.delayed(const Duration(seconds: 3), () async {
      _rideNextAction = RideMapNextAction.driverFound;

      if (widget.servicePurpose == ServicePurpose.personalShopper) {
        // remove current location marker
        _markers.removeWhere(
          (marker) => marker.markerId == _currentLocationMarkerId,
        );
        _showSearchPlaceWidget = false;
        _showCurrentLocationMaker = false;

        Marker myLocationMarker = Marker(
          markerId: const MarkerId("myLocation"),
          position: _currentLocation!,
          infoWindow: const InfoWindow(title: "My Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );

        // shop location
        LatLng shopLatLng = const LatLng(5.6095743, -0.2230998);
        Marker shopMarker = Marker(
          markerId: const MarkerId("shopLocation"),
          position: shopLatLng,
          infoWindow: const InfoWindow(title: "Shop location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );

        _markers.addAll({
          myLocationMarker,
          shopMarker,
        });

        Set<Polyline>? polySet = await fetchRouteAndSetPolyline(
          polylineKey: 'pickPolyline',
          color: BColors.primaryColor,
          locations: [_currentLocation!, shopLatLng],
        );

        if (polySet != null) {
          _polylines = polySet;
        } else {
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('pickPolyline'),
              visible: true,
              points: [_currentLocation!, shopLatLng],
              color: BColors.primaryColor,
              width: 5,
            ),
          );
        }
        setState(() {});

        // display drivers around
        List<DummyCordinateGenerator> dummyCordinates =
            generateSurroundingCoordinates(
          _currentLocation!.latitude,
          _currentLocation!.longitude,
        );
        List<Marker> carsAroundList = [];
        for (int x = 0; x < dummyCordinates.length; ++x) {
          Marker busStopMarker = Marker(
            markerId: MarkerId("carsAround$x"),
            position: LatLng(
              dummyCordinates[x].latitude,
              dummyCordinates[x].longitude,
            ),
            icon: _carIcon!,
            anchor: const Offset(0.5, 0.5),
            rotation: dummyCordinates[x].bearing,
          );
          carsAroundList.add(busStopMarker);
        }
        _markers.addAll({for (Marker carMark in carsAroundList) carMark});

        if (mounted) setState(() {});

        _zoomToFitMarkers(_currentLocation!, shopLatLng);

        Future.delayed(const Duration(seconds: 1), () {
          _controller?.showMarkerInfoWindow(const MarkerId('shopLocation'));
        });
      } else if (widget.servicePurpose == ServicePurpose.deliveryRunnerSingle ||
          widget.servicePurpose == ServicePurpose.deliveryRunnerMultiple) {
        LatLng pickUpLocation = LatLng(
          widget.deliveryAddresses![DeliveryAccessLocation.pickUpLocation]
              ["lat"],
          widget.deliveryAddresses![DeliveryAccessLocation.pickUpLocation]
              ["long"],
        );
        LatLng whereToLocation = LatLng(
          widget.deliveryAddresses![DeliveryAccessLocation.whereToLocation]
              ["lat"],
          widget.deliveryAddresses![DeliveryAccessLocation.whereToLocation]
              ["long"],
        );

        Marker pickUpLocationMarker = Marker(
          markerId: const MarkerId("pickUpLocation"),
          position: pickUpLocation,
          infoWindow: InfoWindow(
            title:
                widget.deliveryAddresses![DeliveryAccessLocation.pickUpLocation]
                            ["name"] !=
                        null
                    ? "My Current Location"
                    : widget.deliveryAddresses![
                        DeliveryAccessLocation.pickUpLocation]["name"],
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );

        Marker whereToMarker = Marker(
          markerId: const MarkerId("whereToLocation"),
          position: whereToLocation,
          infoWindow: InfoWindow(
            title: widget
                    .deliveryAddresses![DeliveryAccessLocation.whereToLocation]
                ["name"],
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          ),
        );

        await _setDeliveryMarkersPolylinesCarsToMap(
          pickUpLocationMarker: pickUpLocationMarker,
          whereToMarker: whereToMarker,
          pickUpLocation: pickUpLocation,
          whereToLocation: whereToLocation,
        );
      }
      setState(() {});
    });
  }

  void _onPaymentMethod() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Paymentmethod()),
    );
  }

  Future<void> _onQuickPlace(QuickPlace place) async {
    // switch (place) {
    //   case QuickPlace.whereTo:
    //     break;
    //   case QuickPlace.home:
    //     break;
    //   case QuickPlace.office:
    //     break;
    //   case QuickPlace.recent:
    //     break;
    //   default:
    // }

    RidePickUpModel? model = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RidePlaces(
          currentLocation: _currentLocation,
        ),
      ),
    );

    if (model != null) {
      ridePickUpfetcherSink.add(model);
    } else {
      return;
    }

    await _ridePickUpStreamSubscription?.cancel();
    _ridePickUpStreamSubscription =
        ridePickUpStream.take(1).listen((RidePickUpModel pickUpModel) async {
      // remove current location marker
      await _positionStream?.cancel();
      _markers.removeWhere(
        (marker) => marker.markerId == _currentLocationMarkerId,
      );
      _showSearchPlaceWidget = false;
      _showCurrentLocationMaker = false;
      if (mounted) setState(() {});

      LatLng pickupLatLng = LatLng(
        pickUpModel.pickup!.lat!,
        pickUpModel.pickup!.long!,
      );
      LatLng whereToLatLng = LatLng(
        pickUpModel.whereTo!.lat!,
        pickUpModel.whereTo!.long!,
      );

      Marker pickUpMarker = Marker(
        markerId: const MarkerId("pickup"),
        position: pickupLatLng,
        infoWindow: InfoWindow(title: pickUpModel.pickup!.name),
        icon: _pinIcon!,
      );

      Marker whereToMarker = Marker(
        markerId: const MarkerId("whereTo"),
        position: whereToLatLng,
        infoWindow: InfoWindow(title: pickUpModel.whereTo!.name),
        icon: _destinationIcon!,
      );

      List<Marker> busStopList = [];
      List<LatLng> busStopLatLngList = [];
      for (int x = 0; x < pickUpModel.busStops!.length; ++x) {
        LatLng bLg = LatLng(
          pickUpModel.busStops![x].lat!,
          pickUpModel.busStops![x].long!,
        );
        busStopLatLngList.add(bLg);
        Marker busStopMarker = Marker(
          markerId: MarkerId("busStop$x"),
          position: bLg,
          infoWindow: InfoWindow(title: pickUpModel.busStops![x].name),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta,
          ),
        );
        busStopList.add(busStopMarker);
      }

      _markers.addAll({
        pickUpMarker,
        whereToMarker,
        ...{for (Marker marker in busStopList) marker}
      });

      Set<Polyline>? polySet = await fetchRouteAndSetPolyline(
        locations: [
          pickupLatLng,
          ...[for (LatLng lL in busStopLatLngList) lL],
          whereToLatLng,
        ],
        polylineKey: 'pickPolyline',
        color: BColors.primaryColor,
      );
      if (polySet != null) {
        _polylines = polySet;
      } else {
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('pickPolyline'),
            visible: true,
            points: [
              pickupLatLng,
              ...[for (LatLng lL in busStopLatLngList) lL],
              whereToLatLng,
            ],
            color: BColors.primaryColor,
            width: 5,
          ),
        );
      }
      setState(() {});
      _createAnimationPolyline();

      // display drivers around
      List<DummyCordinateGenerator> dummyCordinates =
          generateSurroundingCoordinates(
        pickupLatLng.latitude,
        pickupLatLng.longitude,
      );
      List<Marker> carsAroundList = [];
      for (int x = 0; x < dummyCordinates.length; ++x) {
        Marker busStopMarker = Marker(
          markerId: MarkerId("carsAround$x"),
          position: LatLng(
            dummyCordinates[x].latitude,
            dummyCordinates[x].longitude,
          ),
          icon: _carIcon!,
          anchor: const Offset(0.5, 0.5),
          rotation: dummyCordinates[x].bearing,
        );
        carsAroundList.add(busStopMarker);
      }
      _markers.addAll({for (Marker carMark in carsAroundList) carMark});

      if (mounted) setState(() {});

      _zoomToFitMarkers(pickupLatLng, whereToLatLng, padding: 90);

      Future.delayed(const Duration(seconds: 1), () {
        // _controller?.showMarkerInfoWindow(const MarkerId('whereTo'));
        _overlayCordinate = whereToLatLng;
        _overlayMsg = pickUpModel.whereTo!.name.toString();
        _showCustomInfoWindow();
      });

      await _ridePickUpStreamSubscription?.cancel();
    });
  }

  Future<void> _showCustomInfoWindow() async {
    final screenPoint =
        await _controller!.getScreenCoordinate(_overlayCordinate!);

    const overlayWidth = 150.0;
    const overlayHeight = 60.0;

    // Calculate position relative to screen coordinates
    double left = screenPoint.x.toDouble() - overlayWidth / 2;
    double top = (screenPoint.y.toDouble() - overlayHeight) - 300;

    // Ensure the custom info window is within the map bounds
    left = left.clamp(0, mapSize.width - overlayWidth);
    top = top.clamp(0, mapSize.height - overlayHeight);

    try {
      _overlayEntry!.remove();
    } catch (e) {
      debugPrint(e.toString());
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return CustomInfoWindow(
          title: _overlayMsg,
          left: left,
          top: top,
          overlayHeight: overlayHeight,
          overlayWidth: overlayWidth,
        );
      },
    );

    if (!mounted) return;
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _createAnimationPolyline() {
    if (_polylines.isEmpty) {
      return; // Ensure _polylines is populated before proceeding
    }

    _animationController?.reset(); // Ensure the animation starts fresh
    _animation.removeListener(_updatePolyline); // Remove any previous listener
    _animation.removeStatusListener(_animationStatusListener);
    _animation.addListener(_updatePolyline);
    _animation.addStatusListener(_animationStatusListener);

    _animationController?.forward();
  }

  void _updatePolyline() {
    setState(() {
      double fraction = _animation.value;
      List<LatLng> animatedCoordinates = [];

      // Calculate how many points to animate based on fraction
      int pointsToAnimate = (_polylines.first.points.length * fraction).toInt();

      // Ensure at least 2 points are animated (start and end)
      pointsToAnimate =
          pointsToAnimate.clamp(2, _polylines.first.points.length);

      // Interpolate points along the polyline
      for (int i = 0; i < pointsToAnimate - 1; i++) {
        LatLng start = _polylines.first.points[i];
        LatLng end = _polylines.first.points[i + 1];

        // Calculate intermediate point
        double lat =
            start.latitude + (end.latitude - start.latitude) * fraction;
        double lng =
            start.longitude + (end.longitude - start.longitude) * fraction;

        animatedCoordinates.add(LatLng(lat, lng));
      }
      _polylines.removeWhere(
        (polyline) => polyline.polylineId.value == 'animationPolyline',
      );
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('animationPolyline'),
          visible: true,
          points: animatedCoordinates,
          color: BColors.primaryColor2,
          width: 5,
        ),
      );
    });
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animationController?.forward(
        from: 0,
      ); // Restart animation from the beginning
    }
  }

  Future<void> _zoomToFitMarkers(
    LatLng point1,
    LatLng point2, {
    double padding = 75,
    bool moveCameraUp = false,
  }) async {
    // Ensure the GoogleMapController is available
    if (_controller == null) {
      debugPrint("zoomToFitMarkers controller null ");
      _locationUnableToZoom.clear();
      _locationUnableToZoom = [point1, point2];
      return;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        point1.latitude < point2.latitude ? point1.latitude : point2.latitude,
        point1.longitude < point2.longitude
            ? point1.longitude
            : point2.longitude,
      ),
      northeast: LatLng(
        point1.latitude > point2.latitude ? point1.latitude : point2.latitude,
        point1.longitude > point2.longitude
            ? point1.longitude
            : point2.longitude,
      ),
    );

    final CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(
      bounds,
      padding,
    );
    await _controller!.animateCamera(cameraUpdate).then((_) {
      if (moveCameraUp) {
        _controller!.moveCamera(
          CameraUpdate.scrollBy(0, -200), // Scroll up by -200 pixels
        );
      }
    });

    // double bearing = calculateBearing(point1, point2);
    // await _controller!.animateCamera(CameraUpdate.newCameraPosition(
    //   CameraPosition(
    //     target: LatLng(
    //       (point1.latitude + point2.latitude) / 2,
    //       (point1.longitude + point2.longitude) / 2,
    //     ),
    //     zoom: await _controller!.getZoomLevel(),
    //     bearing: bearing,
    //   ),
    // ));
  }

  Future<void> _onMoveCameraToCurrentLocation() async {
    _getCurrentLocation();
    if (_currentLocationPosition != null) {
      CameraPosition position = CameraPosition(
        bearing: _currentLocationPosition!.heading,
        target: LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
        zoom: _zoom,
      );
      await _controller?.animateCamera(
        CameraUpdate.newCameraPosition(position),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    setState(() {});
    if (_locationUnableToZoom.isNotEmpty) {
      _zoomToFitMarkers(_locationUnableToZoom[0], _locationUnableToZoom[1]);
    }
  }

  Future<void> _loadCustomMarkerAssets() async {
    // loading current location asset image
    final Uint8List cLocationIcon = await _getBytesFromAsset(
      Images.currentLocation,
      300,
    );
    _currentLocationIcon = BitmapDescriptor.fromBytes(cLocationIcon);

    // loading car asset image
    final Uint8List carIcon = await _getBytesFromAsset(
      Images.mapCar,
      30,
    );
    _carIcon = BitmapDescriptor.fromBytes(carIcon);

    // loading pin asset image
    final Uint8List pinIcon = await _getBytesFromAsset(
      Images.mapPin,
      50,
    );
    _pinIcon = BitmapDescriptor.fromBytes(pinIcon);

    // loading destination asset image
    final Uint8List destinationIcon = await _getBytesFromAsset(
      Images.mapDestination,
      50,
    );
    _destinationIcon = BitmapDescriptor.fromBytes(destinationIcon);

    setState(() {});
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await DefaultAssetBundle.of(context).load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> _getCurrentLocation() async {
    await _loadCustomMarkerAssets();
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) async {
      if (_showCurrentLocationMaker) {
        _currentLocationPosition = position;
        _currentLocation = LatLng(
          _currentLocationPosition!.latitude,
          _currentLocationPosition!.longitude,
        );
        final marker = Marker(
          markerId: _currentLocationMarkerId,
          position: _currentLocation!,
          icon: _currentLocationIcon!,
          anchor: const Offset(0.5, 0.5),
          rotation: position.heading,
        );
        _markers.add(marker);
        if (mounted) setState(() {});
        if (_initialMoveCameraPosition) {
          _initialMoveCameraPosition = false;
          await _controller?.animateCamera(CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude),
          ));
        }
      } else {
        debugPrint("current location marker removed");
      }
    });
  }
}
