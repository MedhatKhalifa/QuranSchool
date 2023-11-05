import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';

import 'package:quranschool/pages/intro/introudtion.dart';
import 'package:quranschool/pages/search/search_page2.dart';
import 'package:quranschool/translation/translation_page.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/size_config.dart';
import '../Auth/controller/currentUser_controller.dart';
import '../Auth/controller/sharedpref_function.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

  String? mytoken;
  bool _isSkipped = false;

  @override
  void initState() {
    getToken();
    _checkSkipStatus();

    super.initState();
  }

  void _checkSkipStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSkipped = prefs.getBool('isSkipped') ?? false;
    if (!_isSkipped) {
      Timer(Duration(seconds: 1), () {
        setState(() {
          _isSkipped = true;
        });
      });
    }
  }

  getToken() async {
    mytoken = await FirebaseMessaging.instance.getToken();
    //mytoken = 'await FirebaseMessaging.instance.getToken();';
    setState(() {
      currentUserController.currentUser.value.accountToken = mytoken!;
      mytoken = mytoken;
    });
    print('==================================');
    print(currentUserController.currentUser.value.accountToken);
  }

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedSplashScreen.withScreenFunction(
        animationDuration: const Duration(milliseconds: 800),
        splashIconSize: sp(150),
        //duration: 2,

        splash: Container(
          width: w(45),
          height: h(70),
          child: Image.asset(
            "assets/images/logo/logo.png",

            fit: BoxFit.cover,
            // width: w(30),
            // height: h(70),
            //color: Colors.red,
          ),
        ),
        screenFunction: () async {
          // bool isOnline = await hasNetwork();
          // if (isOnline) {
          // unlockController.getlist();
          // categoryController.getdata();
          SharedPreferences prefs = await SharedPreferences.getInstance();

          var _lang = prefs.getString('lang');
          try {
            currentUserController.currentUser.value =
                await loadUserData('user');
            //cartController.getcartList();

            var locale = Locale(_lang!, _lang);
            Get.updateLocale(locale);
          } catch (e) {
            print(e);
            // removeUserData('user');
          }
          return _lang == "ar" || _lang == "en"
              ? !_isSkipped
                  ? HomePage()
                  : IntroPage()
              : TrnaslationPage();
          // } else {
          //   return NoConnectionPage();
          // }
        },
        splashTransition: SplashTransition.scaleTransition,
        //pageTransitionType: ,
        // backgroundColor: Colors.black,
      ),
    );
  }
}
