import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:pickme_mobile/config/firebase/firebaseAuth.dart';
import 'package:pickme_mobile/config/firebase/firebaseProfile.dart';
import 'package:pickme_mobile/models/placemarkModel.dart';
import 'package:pickme_mobile/models/userModel.dart';
import 'package:pickme_mobile/spec/properties.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pickme_mobile/components/toast.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<void> shareFile(String imageUrl) async {
  try {
    final url = Uri.parse(imageUrl);
    final response = await http.get(url);
    final contentType = response.headers['content-type'];
    final image = XFile.fromData(
      response.bodyBytes,
      mimeType: contentType,
    );
    await Share.shareXFiles([image]);
  } catch (e) {
    toastContainer(
      text: "Unable to share file",
      backgroundColor: BColors.red,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}

void callLauncher(String link) async {
  Uri url = Uri.parse(link);
  if (!await launchUrl(url)) {
    throw 'Could not open, try different text';
  }
}

String getReaderDate(String date, {bool showTime = false}) {
  try {
    DateTime dateTime = DateTime.parse(date);
    String newDt = DateFormat.yMMMEd().format(dateTime);
    String newTime = DateFormat.Hm().format(dateTime);
    return showTime ? "$newDt  $newTime" : newDt;
  } catch (e) {
    return "";
  }
}

Future<String> getFilePath(String uniqueFileName) async {
  String path = '';

  Directory dir = await getApplicationDocumentsDirectory();

  if (uniqueFileName.contains("?")) {
    path = '${dir.path}/${uniqueFileName.split("?").first}';
  } else {
    path = '${dir.path}/$uniqueFileName';
  }

  return path;
}

bool checkIfDeviceIsTablet() {
  bool isTablet = false;

  // ignore: deprecated_member_use
  final data = MediaQueryData.fromView(WidgetsBinding.instance.window);

  if (data.size.shortestSide < 550) {
    isTablet = false;
  } else {
    isTablet = true;
  }
  return isTablet;
}

Future<String> saveJsonFile({
  @required String? filename,
  @required dynamic data,
}) async {
  final file = File(
    '${(await getApplicationDocumentsDirectory()).path}/$filename.json',
  );
  await file.writeAsString(json.encode(data));

  String encodedData = await file.readAsString();
  return encodedData;
}

Future<void> deleteFile(String path) async {
  final file = File(path);
  await file.delete();
}

String getTimeago(DateTime dateTime) {
  return timeago.format(dateTime, locale: 'en_short', allowFromNow: true);
}

String sentenceCase(String input) {
  return input.substring(0, 1).toUpperCase() + input.substring(1).toLowerCase();
}

Future<bool> handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return serviceEnabled;
}

Future<PlacemarkModel?> getLocationDetails({
  @required double? lat,
  @required double? log,
}) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat!, log!);
  if (placemarks.isNotEmpty) {
    // debugPrint("placemark ${placemarks[0].toJson()}");
    return PlacemarkModel.fromJson(placemarks[0].toJson());
  } else {
    return null;
  }
}

String formatNumber(String num) {
  var formattedNumber = NumberFormat.compactCurrency(
    decimalDigits: 0,
    symbol:
        '', // if you want to add currency symbol then pass that in this else leave it empty.
  ).format(double.parse(num));
  return formattedNumber;
}

Future<void> continueSignUpOnFirebase({
  @required String? firebaseUserId,
  @required UserModel? userModel,
}) async {
  FireAuth firebaseAuth = new FireAuth();
  FireProfile fireProfile = new FireProfile();
  if (firebaseUserId == null) {
    await firebaseAuth.signIn(
      email: userModel!.data!.user!.email ??
          "${userModel.data!.user!.userid!}@${removeWhiteSpace(Properties.titleShort).toLowerCase()}.com",
      password: Properties.defaultPassword,
      name: '${userModel.data!.user!.name}',
      userId: userModel.data!.user!.userid,
    );
  } else {
    await fireProfile.createAccount(
      email: userModel!.data!.user!.email ??
          "${userModel.data!.user!.userid!}@${removeWhiteSpace(Properties.titleShort).toLowerCase()}.com",
      name: '${userModel.data!.user!.name}',
      userId: userModel.data!.user!.userid,
      firebaseUserId: firebaseUserId,
    );
    firebaseAuth.saveToken();
  }
}

String removeWhiteSpace(String text) {
  String s = text.replaceAll(RegExp(r"\s+"), "");
  return s;
}


String getDisplayName({bool initials = true}) {
  if (userModel == null) return "";

  String name = userModel!.data!.user!.name!;
  String displayName = "";
  List<String> nameSplit = [];
  if (name.contains(" ")) {
    nameSplit = name.split(" ");
    if (initials) {
      displayName = "${nameSplit[0][0]}${nameSplit[1][0]}".toUpperCase();
    } else {
      displayName = nameSplit[0];
    }
  } else {
    if (initials) {
      displayName = name.substring(0, 2).toUpperCase();
    } else {
      displayName = name;
    }
  }
  return displayName;
}
