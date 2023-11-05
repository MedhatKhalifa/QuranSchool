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
    return Scaffold(
      appBar: simplAppbar(true, "Terms and Condition"),
      // backgroundColor: Colors.transparent,

      ///=======================================================================
      ///==================== Body ========================================
      ///=======================================================================
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(top: h(40), right: sp(20), left: sp(20)),
            // form
            child: Center(child: Text('Terms and conditions '))),
      ),
    );
  }
}
