import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pickme_mobile/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pickme_mobile/config/sharePreference.dart';




Future<String> checkSession() async {
  String auth = "not auth";
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("auth")) {
    if (prefs.getBool("auth")!) {
      auth = "auth";
    } else {
      auth = "not auth";
    }
  } else {
    saveBoolShare(key: "auth", data: false);
    auth = "not auth";
  }

  // auth = "not auth";
  await Future.delayed(const Duration(seconds: 3), () async {
    //load all data here
    SharedPreferences? prefs = await SharedPreferences.getInstance();

    try {
      if (prefs.containsKey("userDetails")) {
        String encodedData = prefs.getString("userDetails")!;
        var decodedData = json.decode(encodedData);
        debugPrint(decodedData.toString());
        userModel = UserModel.fromJson(decodedData);

        // Repository repo = new Repository();
      } else {
        debugPrint("please log in");
        auth = "not auth";
      }
    } catch (e) {
      debugPrint("please log in");
      auth = "not auth";
    }
  });
  return auth;
}
