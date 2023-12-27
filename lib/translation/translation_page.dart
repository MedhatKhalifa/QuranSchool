import 'dart:async';

import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quranschool/pages/intro/introudtion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quranschool/pages/common_widget/local_colors.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/Auth/controller/sharedpref_function.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';

import '../pages/common_widget/mybottom_bar/bottom_bar_controller.dart';

class TrnaslationPage extends StatefulWidget {
  @override
  _TrnaslationPageState createState() => new _TrnaslationPageState();
}

final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());

class _TrnaslationPageState extends State {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        //appBar: simplAppbar(false),
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/translate/translate.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
          child: ListView(
        children: [
          SizedBox(
            height: h(20),
          ),
          Container(
              height: h(50),
              child: Image.asset("assets/images/logo/logo_trans.png")),
          // Container(
          //   width: w(40),
          //   height: h(20),
          //   child: Image.asset(
          //     "assets/images/hasr_logo.png",
          //     width: w(40),
          //     height: h(20),
          //     //color: Colors.red,
          //   ),
          // ),
          SizedBox(height: h(5)),
          Padding(
            padding: EdgeInsets.only(right: w(10), left: w(10)),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  side: BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ), // text color

                onPressed: () async {
                  var locale = Locale('en', 'en');
                  Get.updateLocale(locale);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('lang', 'en');
                  myBottomBarCtrl.selectedIndBottomBar.value = 0;
                  Get.to(HomePage());
                },
                child: Text(
                  'English',
                  style: TextStyle(fontSize: sp(20), color: Colors.black),
                )),
          ),
          SizedBox(
            height: h(2),
          ),
          Padding(
            padding: EdgeInsets.only(left: w(10), right: w(10)),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  side: BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ), // text color
                onPressed: () async {
                  var locale = Locale('ar', 'ar');
                  Get.updateLocale(locale);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  await prefs.setString('lang', 'ar');
                  myBottomBarCtrl.selectedIndBottomBar.value = 0;

                  Get.to(HomePage());
                },
                child: Text(
                  'عــربـى',
                  style: TextStyle(fontSize: sp(16), color: Colors.black),
                )),
          ),
          SizedBox(
            height: h(10),
          ),

          Center(
            child: Text(
              '@2023, MADRASET AL-QURAN, All Rights Reserved',
              style: TextStyle(fontSize: 7, color: Colors.white),
            ),
          ),
        ],
      )),
    ));
  }
}
