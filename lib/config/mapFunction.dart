import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pickme_mobile/config/checkConnection.dart';
import 'package:pickme_mobile/models/placeDetailsModel.dart';
import 'package:pickme_mobile/models/placePredictionModel.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/properties.dart';

double calculateBearing(LatLng start, LatLng end) {
  double startLat = start.latitude * pi / 180;
  double startLng = start.longitude * pi / 180;
  double endLat = end.latitude * pi / 180;
  double endLng = end.longitude * pi / 180;

  double dLng = endLng - startLng;
  double y = sin(dLng) * cos(endLat);
  double x =
      cos(startLat) * sin(endLat) - sin(startLat) * cos(endLat) * cos(dLng);

  double bearing = atan2(y, x);
  bearing = bearing * 180 / pi;
  bearing = (bearing + 360) % 360;
  return bearing;
}

Future<Set<Polyline>?> fetchRouteAndSetPolyline({
  required List<LatLng> locations,
  required String polylineKey,
  required Color color,
}) async {
  String apiKey = Properties.googleApiKey;

  String waypoints = locations
      .skip(1)
      .take(locations.length - 2)
      .map((LatLng point) => '${point.latitude},${point.longitude}')
      .join('|');

  bool internet = await checkConnection();
  if (!internet) {
    return null;
  }

  String url =
      'https://maps.googleapis.com/maps/api/directions/json?origin=${locations.first.latitude},${locations.first.longitude}&destination=${locations.last.latitude},${locations.last.longitude}&waypoints=$waypoints&key=$apiKey';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<LatLng> polylinePoints = [];

    if (data['routes'] != null && data['routes'].isNotEmpty) {
      data['routes'][0]['legs'].forEach((leg) {
        leg['steps'].forEach((step) {
          polylinePoints.add(LatLng(
              step['start_location']['lat'], step['start_location']['lng']));
          polylinePoints.add(
              LatLng(step['end_location']['lat'], step['end_location']['lng']));
        });
      });

      Set<Polyline> polylines = {};

      polylines.add(
        Polyline(
          polylineId: PolylineId(polylineKey),
          visible: true,
          points: polylinePoints,
          color: BColors.primaryColor,
          width: 5,
        ),
      );
      return polylines;
    } else {
      return null;
    }
  } else {
    throw Exception('Failed to load directions');
  }
}

Future<List<PlacePredictionModel>> getPlacePredictions(
  String input,
  LatLng currentLocation,
) async {
  String apiKey = Properties.googleApiKey;
  String country = 'GH';

  List<PlacePredictionModel> placePredictions = [];

  final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&components=country:$country&origin=${currentLocation.latitude},${currentLocation.longitude}'));
  if (response.statusCode == 200) {
    final predictions =
        _PlacePredictionCompleteResponse.fromJson(response.body).predictions;

    placePredictions = predictions;
  }

  placePredictions.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
  return placePredictions;
}

class _PlacePredictionCompleteResponse {
  final List<PlacePredictionModel> predictions;

  _PlacePredictionCompleteResponse({required this.predictions});

  factory _PlacePredictionCompleteResponse.fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);
    final List<dynamic> predictionsJson = data['predictions'];
    final predictions = predictionsJson
        .map((json) => PlacePredictionModel.fromJson(json))
        .toList();
    return _PlacePredictionCompleteResponse(predictions: predictions);
  }
}

Future<PlaceDetailsModel> getPlaceDetails(String placeId) async {
  String apiKey = Properties.googleApiKey;

  final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey'));

  if (response.statusCode == 200) {
    final placeDetails = PlaceDetailsModel.fromJson(jsonDecode(response.body));
    return placeDetails;
  } else {
    throw Exception('Failed to load place details');
  }
}

Future<String> _getPlaceIdFromCoordinates(double latitude, double longitude) async {
  String apiKey = Properties.googleApiKey;

  final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey'));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    if (jsonResponse['results'] != null && jsonResponse['results'].isNotEmpty) {
      return jsonResponse['results'][0]['place_id'];
    } else {
      throw Exception('No results found for the given coordinates.');
    }
  } else {
    throw Exception('Failed to load place ID from coordinates');
  }
}

Future<PlaceDetailsModel> getPlaceDetailsFromCoordinates(double latitude, double longitude) async {
  String placeId = await _getPlaceIdFromCoordinates(latitude, longitude);
  return await getPlaceDetails(placeId);
}
