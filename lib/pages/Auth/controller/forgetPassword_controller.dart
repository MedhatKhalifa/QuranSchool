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
          'oldPassword': oldPassword.value,
          'newPassword': newPassword.value
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 700;
          },
          headers: {
            'Authorization':
                'Token ${currentUserController.currentUser.value.token}'
          },
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
        userCheckUrl + username.value + "&phoneNumber=" + phoneNumber.value,
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
        if (!response.data.isEmpty) {
          var resp = await phoneController.verifyPhone(phoneNumber.value);
          await SmsAutoFill().listenForCode;
          Get.to(OtpForgetPassPage());
        } else {
          mySnackbar("Failed".tr, "error_num".tr, false);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }
}
