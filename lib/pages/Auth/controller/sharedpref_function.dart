import 'dart:convert';

// import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:quranschool/pages/Auth/Model/showTutorial.dart';
import 'package:quranschool/pages/sessions/controller/session_control.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quranschool/pages/Auth/Model/users.dart';
import 'dart:async';

import 'package:flutter/material.dart';

// import 'package:quranschool/pages/My_favorite/controller/favorite_controller.dart';
// import 'package:quranschool/pages/home/controller/home_controller.dart';
// import 'package:quranschool/pages/unlock_profiles/controller/unlockcontroller.dart';
final MySesionController mySesionController = Get.put(MySesionController());
Future<void> storeUserData(User _regiuser, labelStored) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  Map<String, dynamic> _user = _regiuser.toJson();
  bool reult = await prefs.setString(labelStored, jsonEncode(_user));
  print(reult);
}

// final FavController favController = Get.put(FavController());
// final UnlockController unlockController = Get.put(UnlockController());

loadUserData(labelStored) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userPref = prefs.getString(labelStored);

  if (userPref == null) {
    return User();
  }
  var json = jsonDecode(userPref);
  var _user = User.fromJson(json);

  // favController.getdata();
  // unlockController.getlist();

  return (_user);
}

loadTutorialData(labelStored) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userPref = prefs.getString(labelStored);

  if (userPref == null) {
    return ShowTutorial();
  }
  var json = jsonDecode(userPref);
  ShowTutorial _showTutorial = ShowTutorial.fromJson(json);
  // favController.getdata();
  // unlockController.getlist();

  return (_showTutorial);
}

Future<void> storeTutorialData(ShowTutorial _tutorialShow, labelStored) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  Map<String, dynamic> _user = _tutorialShow.toJson();
  bool reult = await prefs.setString(labelStored, jsonEncode(_user));
  print(reult);
}

checklanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isArabic = prefs.getBool('isArabic');

  if (isArabic != null && isArabic) {
    var locale = Locale('ar', 'ar');
    Get.updateLocale(locale);
  }
}

removeUserData(labelStored) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(labelStored);
}
