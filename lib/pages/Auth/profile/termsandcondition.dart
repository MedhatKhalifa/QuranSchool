import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/common_widget/error_snackbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/pages/common_widget/local_colors.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/pages/Auth/Model/users.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/Auth/controller/phone_controller.dart';
import 'package:quranschool/pages/Auth/controller/register_controller.dart';
import 'package:quranschool/pages/Auth/login/login_page.dart';
import 'package:quranschool/pages/Auth/register/otp_dialogue.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/translation/translate_ctrl.dart';
import 'package:sms_autofill/sms_autofill.dart';

class TermsCondition extends StatefulWidget {
  @override
  _TermsConditionState createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
        appBar: simplAppbar(
            true, isArabic ? 'البنود والشروط' : 'Terms and Conditions'),
        // backgroundColor: Colors.transparent,

        ///=======================================================================
        ///==================== Body ========================================
        ///=======================================================================
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Text(
              isArabic
                  ? 'مرحبًا بك في تطبيق مدرسة القرآن! قبل أن تبدأ في استخدام خدماتنا، يرجى قراءة البنود والشروط التالية بعناية. عن طريق الوصول إلى أو استخدام تطبيق مدرسة القرآن، فإنك توافق على الالتزام بهذه البنود والشروط. إذا كنت لا توافق على أي جزء من هذه البنود، فلا يحق لك استخدام خدماتنا.'
                  : 'Welcome to the Quran School app! Before you begin using our services, please take a moment to carefully read through the following terms and conditions. By accessing or using the Quran School app, you agree to be bound by these terms and conditions. If you do not agree with any part of these terms, you may not use our services.',
              style: TextStyle(fontSize: 16.0),
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
            ),
            SizedBox(height: 20.0),
            Text(
              isArabic
                  ? '1. قبول الشروط\n\nمن خلال استخدام تطبيق مدرسة القرآن، فإنك تقر بأنك قرأت وفهمت ووافقت على الالتزام بهذه البنود والشروط، فضلاً عن أي بنود وسياسات إضافية مشار إليها هنا. تنطبق هذه البنود على جميع مستخدمي التطبيق، بما في ذلك الطلاب والآباء والمعلمين والمسؤولين، أو أي أفراد آخرين يستخدمون خدماتنا.'
                  : '1. Acceptance of Terms\n\nBy using the Quran School app, you acknowledge that you have read, understood, and agree to be bound by these terms and conditions, as well as any additional terms and policies referenced herein. These terms apply to all users of the app, including students, parents, teachers, administrators, or any other individuals accessing our services.',
              style: TextStyle(fontSize: 16.0),
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
            ),
            SizedBox(height: 20.0),
            Text(
              isArabic
                  ? '2. استخدام الخدمات\n\nيوفر تطبيق مدرسة القرآن الوصول إلى موارد تعليمية، بما في ذلك دروس القرآن، والبرامج التعليمية، والاختبارات، والمواد ذات الصلة الأخرى. يتم منح المستخدمين ترخيصًا غير حصري وغير قابل للنقل ومحدود للوصول إلى هذه الخدمات واستخدامها لأغراض شخصية أو تعليمية فقط. يُحظر على المستخدمين استخدام التطبيق لأي أغراض غير قانونية أو غير مصرح بها.'
                  : '2. Use of Services\n\nThe Quran School app provides access to educational resources, including Quranic lessons, tutorials, quizzes, and other related materials. Users are granted a non-exclusive, non-transferable, limited license to access and use these services for personal or educational purposes only. Users are prohibited from using the app for any unlawful or unauthorized purposes.',
              style: TextStyle(fontSize: 16.0),
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
            ),
            // Add more Text widgets for additional sections of terms and conditions
            // Add SizedBox for spacing between sections
          ],
        ));
  }
}
