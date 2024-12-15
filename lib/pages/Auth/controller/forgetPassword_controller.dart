import 'package:quranschool/pages/Auth/controller/phone_controller.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/bottom_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:quranschool/core/db_links/db_links.dart';

import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/Auth/login/login_page.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/error_snackbar.dart';
import '../login/otp_forgetpassword.dart';

class ForgerPassController extends GetxController {
  var newPassword = "".obs;
  var oldPassword = "".obs;
  var resetPassword = "".obs;
  var phoneNumber = "".obs;
  var username = "".obs;
  var isLoading = false.obs;
  String _token = '';
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());
  final PhoneController phoneController = Get.put(PhoneController());

  final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());
  @override
  void onInit() {
    super.onInit();
  }

  Future updatePassword() async {
    try {
      isLoading(true);
      var dio = Dio();

      var response = await dio.post(
        changepassword_Url,
        data: {
          'user': currentUserController.currentUser.value.username,
          'oldPassword': oldPassword.value,
          'newPassword': newPassword.value
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 700;
          },
          // headers: {
          //   'Authorization':
          //       'Token ${currentUserController.currentUser.value.token}'
          // },
        ),
      );

      if (response.statusCode == 200) {
        mySnackbar('Thanks'.tr, 'pass_change_succ'.tr, true);
        // _redirectUser();
        myBottomBarCtrl.selectedIndBottomBar.value = 0;
        Get.to(() => HomePage());
      } else {
        mySnackbar('Failed'.tr, 'pass_change_fail'.tr, false);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future resetpassword() async {
    try {
      isLoading(true);
      var dio = Dio();

      var response = await dio.post(
        resetPassUrl,
        data: {'username': username.value, 'password': newPassword.value},
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
          // headers: {
          //   'Authorization':
          //       'Token ${currentUserController.currentUser.value.token}'
          // },
        ),
      );

      if (response.statusCode == 200) {
        mySnackbar('Thanks'.tr, 'pass_change_succ'.tr, true);
        // _redirectUser();

        Get.to(() => LoginPage());
      } else {
        mySnackbar('Failed'.tr, 'pass_change_fail'.tr, false);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future chdeck_number() async {
    // var f = _loadUserData('user');
    // print(f);

    // var resp = await phoneController.verifyPhone(phoneNumber.value);
    // await SmsAutoFill().listenForCode;
    // Get.to(OtpForgetPassPage());
    // return;
    var dio = Dio();
    try {
      var response = await dio.get(
        userCheckUrl + username.value,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 505;
          },
          //headers: {},
        ),
      );

      if (response.statusCode == 200) {
        //final responseData = json.decode(response.data);
        if (!response.data.isEmpty &&
            response.data[0]['phoneNumber'] == phoneNumber.value) {
          var resp = await phoneController.verifyPhone(phoneNumber.value);
          await SmsAutoFill().listenForCode;
          Get.to(OtpForgetPassPage());
        } else {
          mySnackbar("Failed".tr, "pass_change_fail".tr, false);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  _whatsapmessage() async {
    String _phone = '+201028084826';
    String _username = username.value;
    String _phonenm = phoneNumber.value;

    //   Assalamu Alaikum wa Rahmatullahi wa Barakatuh,
    // I pray this message finds you in good health and Iman. 😊
    // Could you kindly assist in resetting the password for the following user?
    // Username: $_username
    // Phone Number: $_phonenm

    String message = '''
    السلام عليكم ورحمة الله وبركاته،
  أسأل الله أن تكون بخير وفي صحة وعافية. 😊
  هل يمكنك مساعدتي في إعادة تعيين كلمة المرور للمستخدم التالي؟
  اسم المستخدم: $_username
  رقم الهاتف: $_phonenm
  جزاك الله خيرًا!
  ''';
    final url = Uri.parse(
        'https://wa.me/$_phone/?text=${Uri.encodeFull(message)}'); // Arguments are correctly included here

    if (!await launchUrl(
        Uri.parse('https://wa.me/$_phone/?text=${Uri.encodeFull(message)}'))) {
      Get.snackbar('error'.tr, 'Could not launch WhatsApp'.tr,
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
      throw 'Could not launch $url';
    }
    //   await launchUrl(url);
    // } else {
    //   Get.snackbar('error'.tr, 'Could not launch WhatsApp'.tr,
    //       snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
    // }
  }
}
