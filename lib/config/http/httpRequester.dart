import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pickme_mobile/models/userModel.dart';

import 'httpServices.dart';

enum HttpMethod { post, get }

Future<Map<String, dynamic>> httpRequesting({
  @required String? endPoint,
  @required HttpMethod? method,
  Map<String, dynamic>? httpPostBody,
  Map<String, dynamic>? queryParameters,
  bool showLog = false,
}) async {
  if (kDebugMode) {
    print("${HttpServices.base}${HttpServices.subbase}$endPoint");
    log("$httpPostBody");
  }
  try {
    Uri uri = Uri.https(
      HttpServices.base,
      "${HttpServices.subbase}$endPoint",
      queryParameters,
    );
    final response = method == HttpMethod.get
        ? await http
            .get(
              uri,
              headers: userModel != null &&
                      userModel!.data != null &&
                      userModel!.data!.authToken != null
                  ? {"Authorization": "Bearer ${userModel!.data!.authToken}"}
                  : null,
            )
            .timeout(const Duration(minutes: 1))
        : await http
            .post(
              uri,
              headers: userModel != null &&
                      userModel!.data != null &&
                      userModel!.data!.authToken != null
                  ? {"Authorization": "Bearer ${userModel!.data!.authToken}"}
                  : null,
              body: httpPostBody,
            )
            .timeout(const Duration(minutes: 1));

    if (showLog) log("body => ${response.body}");

    try {
      final responseData = json.decode(response.body);
      return {
        "statusCode": response.statusCode,
        "data": responseData,
        "url": "${HttpServices.base}${HttpServices.subbase}$endPoint",
      };
    } catch (e) {
      return {
        "statusCode": response.statusCode,
        "data": null,
        "url": "${HttpServices.base}${HttpServices.subbase}$endPoint",
        "error": e.toString(),
      };
    }
  } catch (e) {
    return {
      "statusCode": null,
      "data": null,
      "url": "${HttpServices.base}${HttpServices.subbase}$endPoint",
      "error": e.toString(),
    };
  }
}
