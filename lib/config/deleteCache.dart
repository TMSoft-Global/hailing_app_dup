import 'package:flutter/material.dart';
import 'package:pickme_mobile/config/sharePreference.dart';

Future<void> deleteCache() async {
  imageCache.clear();

  List<String> cacheList = [
    "userDetails",
  ];

  for (String key in cacheList) {
    await deleteShareUserData(key);
  }
}
