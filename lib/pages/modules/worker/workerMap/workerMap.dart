import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart' hide Step;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickme_mobile/components/customLoading.dart';
import 'package:pickme_mobile/components/toast.dart';
import 'package:pickme_mobile/config/globalFunction.dart';
import 'package:pickme_mobile/config/navigation.dart';
import 'package:pickme_mobile/pages/modules/worker/workerMap/widget/workerRideAcceptRequestMap.dart';
import 'package:pickme_mobile/pages/modules/worker/rateCustomer/rateCustomer.dart';
import 'package:pickme_mobile/pages/modules/worker/workerMap/widget/workerMapWidget.dart';
import 'package:pickme_mobile/spec/arrays.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'dart:ui' as ui;

import 'package:pickme_mobile/spec/properties.dart';

import 'widget/workerMultipleRunnerAcceptRequestMap.dart';
import 'widget/workerSingleRunnerAcceptRequestMap.dart';

class WorkerMap extends StatefulWidget {
  final Position? currentLocation;
  final WorkerMapNextAction? mapNextAction;
  final ServicePurpose? servicePurpose;

  const WorkerMap({
    super.key,
    required this.currentLocation,
    this.mapNextAction,
    this.servicePurpose,
  });

  @override
  State<WorkerMap> createState() => _WorkerMapState();
}

class _WorkerMapState extends State<WorkerMap> {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  Position? _currentPosition;

  Position? _currentLocationPosition;
  LatLng? _currentLocation, _destinationLocation;
  StreamSubscription<Position>? _positionStream;

  BitmapDescriptor? _currentLocationIcon;

  final double _zoom = 14.4746;

  static const MarkerId _currentLocationMarkerId = MarkerId('currentLocation');
  bool _showCurrentLocationMaker = true,
      _isTTSVolumeMute = true,
      _isLoading = false;

  WorkerMapNextAction? _mapNextAction;
  final FlutterTts _flutterTts = FlutterTts();
  double _cameraBearing = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.currentLocation != null) {
      _currentLocationPosition = widget.currentLocation;
      _currentLocation = LatLng(
        _currentLocationPosition!.latitude,
        _currentLocationPosition!.longitude,
      );

      if (_mapNextAction == null) _getCurrentLocation();
    } else {
      throw Exception(
        "Current location position can't be null",
      );
    }

    _loadCustomMarkerAssets();
    _initTts();

    _mapNextAction = widget.mapNextAction;

    if (_mapNextAction == WorkerMapNextAction.accept) {
      // madina coordinate
      _onStartRideTrip(
        destination: const LatLng(5.6730432, -0.1835081),
        action: WorkerMapNextAction.accept,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _positionStream?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          workerMapWidget(
            context: context,
            currentLocation: _currentLocation!,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) =>
                _onMapCreated(controller),
            zoom: _zoom,
            polylines: _polylines,
            onCurrentLocation: () => _onMoveCameraToCurrentLocation(),
            onPaySales: () => navigation(
              context: context,
              pageName: "salesPayment",
            ),
            onOnOfflineToggle: (int index) {},
            mapNextAction: _mapNextAction,
            onBack: () => _onBack(),
            onTTSVolume: () => _onTTSVolume(),
            isTTSVolumeMute: _isTTSVolumeMute,
            onGoogleMap: () => _onOpenGoogleMap(),
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
      bottomNavigationBar: _mapNextAction == WorkerMapNextAction.accept ||
              _mapNextAction == WorkerMapNextAction.arrived ||
              _mapNextAction == WorkerMapNextAction.onTrip
          ? widget.servicePurpose == ServicePurpose.ride
              ? workerRideAcceptRequestMap(
                  context: context,
                  onCall: () {},
                  onChat: () {},
                  onArrivedPickUpPoint: () => _onEndRideTrip(
                    WorkerMapNextAction.arrived,
                  ),
                  mapNextAction: _mapNextAction,
                  onStartTrip: () => _onStartRideTrip(
                    destination: const LatLng(5.6730432, -0.1835081),
                    action: WorkerMapNextAction.onTrip,
                  ),
                  onEndTrip: () => _onEndRideTrip(
                    WorkerMapNextAction.endTrip,
                  ),
                )
              : widget.servicePurpose == ServicePurpose.deliveryRunnerSingle
                  ? workerSingleRunnerAcceptRequestMap(
                      context: context,
                      onCall: () {},
                      onChat: () {},
                      onArrivedSenderLocation: () => _onEndRideTrip(
                        WorkerMapNextAction.arrived,
                      ),
                      mapNextAction: _mapNextAction,
                      onStartTrip: () => _onStartRideTrip(
                        destination: const LatLng(5.6730432, -0.1835081),
                        action: WorkerMapNextAction.onTrip,
                      ),
                      onEndTrip: () => _onEndRideTrip(
                        WorkerMapNextAction.endTrip,
                      ),
                    )
                  : workerMultipleRunnerAcceptRequestMap(
                      context: context,
                      onCall: () {},
                      onChat: () {},
                      onArrivedSenderLocation: () => _onEndRideTrip(
                        WorkerMapNextAction.arrived,
                      ),
                      mapNextAction: _mapNextAction,
                      onStartTrip: () => _onStartRideTrip(
                        destination: const LatLng(5.6730432, -0.1835081),
                        action: WorkerMapNextAction.onTrip,
                      ),
                      onEndTrip: () => _onEndRideTrip(
                        WorkerMapNextAction.endTrip,
                      ),
                    )
          : null,
    );
  }

  void _onOpenGoogleMap() {
    // Open Google Maps with directions
    String googleUrl =
        'https://www.google.com/maps/dir/?api=1&origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${_destinationLocation!.latitude},${_destinationLocation!.longitude}';
    callLauncher(googleUrl);
  }

  void _onEndRideTrip(WorkerMapNextAction action) {
    _positionStream?.cancel();
    _polylines.clear();
    _destinationLocation = null;
    _mapNextAction = action;
    setState(() {});

    if (action == WorkerMapNextAction.endTrip) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => RateCustomer(
              servicePurpose: widget.servicePurpose!,
            ),
          ),
          (Route<dynamic> route) => false);
    }
  }

  Future<void> _onStartRideTrip({
    required LatLng destination,
    required WorkerMapNextAction action,
  }) async {
    _markers.clear();
    _polylines.clear();
    _showCurrentLocationMaker = false;
    _mapNextAction = action;
    _isLoading = true;
    setState(() {});

    _destinationLocation = destination;

    _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      _currentPosition = position;
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
      _isLoading = false;

      if (mounted) setState(() {});
      _animateCameraToCurrentLocation();
      _getRideRoute(_destinationLocation!);
    });
  }

  Future<void> _animateCameraToCurrentLocation() async {
    if (_currentPosition != null && _controller != null) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
            zoom: 18,
            bearing: _cameraBearing,
          ),
        ),
      );
    }
  }

  Future<void> _getRideRoute(LatLng destination) async {
    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationLocation"),
      position: destination,
      infoWindow: const InfoWindow(title: "Destinaton Location Name"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    );

    _markers.addAll({destinationMarker});

    DirectionsService.init(Properties.googleApiKey);
    final directionsService = DirectionsService();
    final request = DirectionsRequest(
      origin: '${_currentPosition!.latitude},${_currentPosition!.longitude}',
      destination: '${destination.latitude},${destination.longitude}',
      travelMode: TravelMode.driving,
    );

    directionsService.route(request, (
      DirectionsResult response,
      DirectionsStatus? status,
    ) {
      if (status == DirectionsStatus.ok) {
        _polylines.clear();
        for (var route in response.routes!) {
          for (var leg in route.legs!) {
            List<LatLng> points = [];
            for (var step in leg.steps!) {
              points.add(
                LatLng(
                  step.startLocation!.latitude,
                  step.startLocation!.longitude,
                ),
              );
              points.add(
                LatLng(
                  step.endLocation!.latitude,
                  step.endLocation!.longitude,
                ),
              );
            }
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('rideRoute'),
                points: points,
                color: BColors.primaryColor,
                width: 5,
              ),
            );
            if (!_isTTSVolumeMute) _speakDirections(leg.steps!);
            if (response.routes!.isNotEmpty) {
              _updateCameraBearing(response.routes!.first);
            }
          }
        }
        if (mounted) setState(() {});
      } else {
        toastContainer(
          text: "Unable to get direction",
          backgroundColor: BColors.red,
        );
      }
    });
  }

  void _updateCameraBearing(DirectionsRoute route) {
    if (_currentPosition != null &&
        route.legs!.isNotEmpty &&
        route.legs!.first.steps!.isNotEmpty) {
      Step firstStep = route.legs!.first.steps!.first;
      double bearing = Geolocator.bearingBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        firstStep.endLocation!.latitude,
        firstStep.endLocation!.longitude,
      );
      if (mounted) {
        setState(() {
          _cameraBearing = bearing;
        });
      }
      _animateCameraToCurrentLocation();
    }
  }

  Future<void> _speakDirections(List<dynamic> steps) async {
    for (var step in steps) {
      await _flutterTts.speak(step.instructions);
      await Future.delayed(Duration(seconds: step.duration.inSeconds));
    }
  }

  void _onBack() {
    navigation(context: context, pageName: "back");
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
    if (_mapNextAction == null) {
      _controller!.moveCamera(CameraUpdate.scrollBy(0, -150));
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
    // final Uint8List carIcon = await _getBytesFromAsset(
    //   Images.mapCar,
    //   80,
    // );
    // _carIcon = BitmapDescriptor.fromBytes(carIcon);

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
    ).listen((Position position) {
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
      } else {
        debugPrint("current location marker removed");
      }
    });
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(0);
    _isTTSVolumeMute = true;
  }

  void _onTTSVolume() {
    _isTTSVolumeMute = !_isTTSVolumeMute;
    _flutterTts.setVolume(_isTTSVolumeMute ? 0 : 1);
    setState(() {});
  }
}
