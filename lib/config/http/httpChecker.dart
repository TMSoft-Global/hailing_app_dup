import 'dart:async';
import 'dart:developer';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:pickme_mobile/components/toast.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/strings.dart';

Future<Map<String, dynamic>> httpChecker({
  @required Future<Map<String, dynamic>> Function()? httpRequesting,
  bool showToastMsg = false,
}) async {
  try {
    Map<String, dynamic> httpMap = await httpRequesting!();
    if (httpMap["statusCode"] == 0) {
      return {
        "ok": false,
        "statusCode": httpMap["statusCode"],
        "data": null,
        "statusMsg": Strings.noInternet,
        "error": Strings.noInternet,
      };
    } else if (httpMap["statusCode"] >= 100 && httpMap["statusCode"] <= 199) {
      if (showToastMsg) {
        toastContainer(
          text: "${httpMap["statusCode"]}-${httpMap["data"]["msg"]}",
          backgroundColor: BColors.red,
        );
      }
      return {
        "ok": false,
        "statusCode": httpMap["statusCode"],
        "data": null,
        "statusMsg": "Information responses",
      };
    } else if (httpMap["statusCode"] >= 200 && httpMap["statusCode"] <= 299) {
      // log("200 ok => ${httpMap["data"] is Map ? httpMap["data"]["ok"] ?? true : 'Not map'}");
      return {
        "ok": httpMap["data"] is Map ? httpMap["data"]["ok"] ?? true : true,
        "statusCode": httpMap["statusCode"],
        "data": httpMap["data"],
        "statusMsg": "Successful responses",
      };
    } else if (httpMap["statusCode"] >= 300 && httpMap["statusCode"] <= 399) {
      if (showToastMsg) {
        toastContainer(
          text: "${httpMap["statusCode"]}-${httpMap["data"]["msg"]}",
          backgroundColor: BColors.red,
        );
      }
      return {
        "ok": false,
        "statusCode": httpMap["statusCode"],
        "data": null,
        "statusMsg": "Redirects",
      };
    } else if (httpMap["statusCode"] >= 400 && httpMap["statusCode"] <= 499) {
      if (showToastMsg) {
        toastContainer(
          text: "${httpMap["statusCode"]}-${httpMap["data"]["msg"]}",
          backgroundColor: BColors.red,
        );
      }
      return {
        "ok": false,
        "statusCode": httpMap["statusCode"],
        "data": httpMap["data"],
        "statusMsg": "Client errors",
        "error": httpMap["data"]["msg"],
      };
    } else {
      if (showToastMsg) {
        toastContainer(
            text: Strings.requestError, backgroundColor: BColors.red);
      }
      return {
        "ok": false,
        "statusCode": httpMap["statusCode"],
        "data": null,
        "statusMsg": "Errors",
        "error": "Internal Error",
      };
    }
  } on TimeoutException catch (error) {
    if (kDebugMode) {
      print(error);
    }
    if (showToastMsg) {
      toastContainer(
          text: Strings.connectionTImeout, backgroundColor: BColors.red);
    }
    return {
      "ok": false,
      "statusCode": null,
      "data": null,
      "statusMsg": "Errors",
      "error": Strings.connectionTImeout,
    };
  } on SocketException catch (error) {
    if (kDebugMode) {
      print(error);
    }
    if (showToastMsg) {
      toastContainer(text: Strings.noInternet, backgroundColor: BColors.red);
    }
    return {
      "ok": false,
      "statusCode": null,
      "data": null,
      "statusMsg": "Errors",
      "error": Strings.noInternet,
    };
  } catch (e) {
    if (showToastMsg) {
      toastContainer(text: Strings.requestError, backgroundColor: BColors.red);
    }
    Map<String, dynamic> httpMap = await httpRequesting!();
    log("data causing error => $httpMap \n stack error => $e");
    return {
      "ok": false,
      "statusCode": null,
      "data": null,
      "statusMsg": "Errors",
      "error": "${Strings.requestError} ${httpMap["error"] ?? ""}",
    };
  }
}
