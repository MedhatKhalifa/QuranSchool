import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quranschool/core/connectionCheck/dependency_injection.dart';
import 'package:quranschool/pages/Auth/login/change_password.dart';
import 'package:quranschool/pages/Auth/login/forget_password.dart';
import 'package:quranschool/pages/Auth/login/otp_forgetpassword.dart';
import 'package:quranschool/pages/Auth/login/set_password.dart';
import 'package:quranschool/pages/Auth/profile/profile_register.dart';
import 'package:quranschool/pages/Auth/register/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/register/register_phone.dart';
import 'package:quranschool/pages/intro/introudtion.dart';
import 'package:quranschool/pages/search/detail_search.dart';

import 'package:quranschool/pages/search/search_page.dart';
import 'package:quranschool/pages/search/price_list.dart';
import 'package:quranschool/pages/search/teacher_calendar.dart';
import 'package:quranschool/pages/sessions/videoScreen.dart';
import 'package:quranschool/test_page.dart';
import 'package:quranschool/translation/translate_ctrl.dart';
import 'package:quranschool/translation/translation.dart';
import 'package:quranschool/translation/translation_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';

import 'pages/home_page/view/home_page.dart';
import 'pages/splash/splash_screen.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

Future<void> main() async {
  // for firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // firebase chat message
  await FirebaseMessaging.instance.getInitialMessage();
  // online checking // located in core folder
  //DependencyInjection.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // textDirection: TextDirection.ltr,
      title: 'Madraset Al Quran',
      theme: LocalThemes.lightTheme, // located in core folder
      debugShowCheckedModeBanner: false,
      // our home page is the splash
      home: SplashScreen(),
      // this localization for calendar language
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ar'),
      ],
      //home: const SplashScreen(),
      // all the below for translating using getx
      translations: Translate(),
      // Main language ( ar & en are dictionary contains all arabic & text english )
      locale: Get.deviceLocale,
      // if there any erroe will go back to english
      fallbackLocale: const Locale('en'),
    );
  }
}
// import 'package:device_preview/device_preview.dart';
// import 'package:device_preview_screenshot/device_preview_screenshot.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:quranschool/core/connectionCheck/dependency_injection.dart';
// import 'package:quranschool/pages/Auth/login/change_password.dart';
// import 'package:quranschool/pages/Auth/login/forget_password.dart';
// import 'package:quranschool/pages/Auth/login/otp_forgetpassword.dart';
// import 'package:quranschool/pages/Auth/login/set_password.dart';
// import 'package:quranschool/pages/Auth/profile/profile_register.dart';
// import 'package:quranschool/pages/Auth/register/register_page.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:quranschool/core/theme.dart';
// import 'package:quranschool/pages/Auth/register/register_phone.dart';
// import 'package:quranschool/pages/intro/introudtion.dart';
// import 'package:quranschool/pages/search/detail_search.dart';

// import 'package:quranschool/pages/search/search_page.dart';
// import 'package:quranschool/pages/search/price_list.dart';
// import 'package:quranschool/pages/search/teacher_calendar.dart';
// import 'package:quranschool/test_page.dart';
// import 'package:quranschool/translation/translate_ctrl.dart';
// import 'package:quranschool/translation/translation.dart';
// import 'package:quranschool/translation/translation_page.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:month_year_picker/month_year_picker.dart';

// import 'pages/home_page/view/home_page.dart';
// import 'pages/splash/splash_screen.dart';
// import 'package:syncfusion_localizations/syncfusion_localizations.dart';

// Future<void> main() async {
//   //for firebase
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   // firebase chat message
//   await FirebaseMessaging.instance.getInitialMessage();
//   // online checking // located in core folder
//   DependencyInjection.init();
//   runApp(
//     DevicePreview(
//       enabled: true,
//       builder: (context) => MyApp(),
//       tools: [
//         ...DevicePreview.defaultTools,
//         const DevicePreviewScreenshot(),
//       ],
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       // textDirection: TextDirection.ltr,
//       useInheritedMediaQuery: true,
//       locale: DevicePreview.locale(context),
//       builder: DevicePreview.appBuilder,
//       title: 'Madraset Al Quran',
//       theme: LocalThemes.lightTheme, // located in core folder
//       debugShowCheckedModeBanner: false,
//       // our home page is the splash
//       home: HomePage(),
//       // this localization for calendar language
//       localizationsDelegates: [
//         GlobalWidgetsLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         MonthYearPickerLocalizations.delegate,
//         SfGlobalLocalizations.delegate,
//       ],
//       supportedLocales: [
//         const Locale('en'),
//         const Locale('ar'),
//       ],
//       //home: const SplashScreen(),
//       // all the below for translating using getx
//       translations: Translate(),
//       // Main language ( ar & en are dictionary contains all arabic & text english )
//       // locale: Get.deviceLocale,
//       // if there any erroe will go back to english
//       fallbackLocale: const Locale('en'),
//     );
//   }
// }
