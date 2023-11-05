import 'package:quranschool/pages/Auth/controller/phone_controller.dart';
import 'package:quranschool/pages/Auth/profile/profile_register.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/bottom_bar_controller.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:quranschool/core/db_links/db_links.dart';
import 'package:quranschool/pages/Auth/Model/users.dart';

import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/common_widget/error_snackbar.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../register/otp_dialogue.dart';
import 'sharedpref_function.dart';

class RegisterController extends GetxController {
  // Loading flag for Registeration
  var isLoading = false.obs;
  var phoneExist = true.obs;
  var userExist = true.obs;
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());
  final PhoneController phoneController = Get.put(PhoneController());

  final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());
  var registeruserdata = User().obs;
  @override
  void onInit() {
    super.onInit();
  }

  Future registeruser() async {
    // var f = _loadUserData('user');
    // print(f);

    //return Get.offAll(ProfileRegisterPage());

    try {
      isLoading(true);
      var dio = Dio(); // DIO is library to deal with APIs

      //registeruserdata.value.accountType = registeruserdata.value.showType;

      var response = await dio.post(
        register_url,
        data: {
          'username': registeruserdata
              .value.username, //registeruserdata.value.username,
          'password': registeruserdata.value.password,
          // 'email': registeruserdata.value.email,
          // 'phoneNumber': registeruserdata.value.phoneNumber,
          // 'fullName': registeruserdata.value.fullName,
          // 'accountToken': currentUserController.currentUser.value.accountToken,
          // 'country': registeruserdata.value.country,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 505;
          },
          //headers: {},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //final responseData = json.decode(response.data);
        User _regiuser = User.fromJson(response.data);

        currentUserController.currentUser.value = _regiuser;

        storeUserData(currentUserController.currentUser.value,
            'user'); // save UserID, User name , Phone Num
        myBottomBarCtrl.selectedIndBottomBar.value = 0;
        Get.offAll(ProfileRegisterPage());
      } else {
        mySnackbar("Failed".tr,
            " Wrong data or the user name is already exist".tr, "Error");
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future chdeck_number(String _number) async {
    // var f = _loadUserData('user');
    // print(f);

    try {
      isLoading(true);
      var dio = Dio(); // DIO is library to deal with APIs

      // registeruserdata.value.accountType = registeruserdata.value.showType;

      var response = await dio.post(
        phoneCheckUrl,
        data: {
          'phoneNumber': _number,
        },
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
        print(response.data['Date']);
        if (response.data['Date'] == "phone number not exist") {
          phoneExist.value = false;
          var resp = await phoneController.verifyPhone(_number);
          await SmsAutoFill().listenForCode;
          Get.to(const OtpDialogue());
        } else {
          mySnackbar("Failed".tr, "invalid_num_or_already_exist".tr, "Error");
        }
      } else {
        mySnackbar("Failed".tr, "invalid_num_or_already_exist".tr, "Error");
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future chdeckUsername(String _number, String userName) async {
    // var f = _loadUserData('user');
    // print(f);
    // var resp = await phoneController.verifyPhone(_number);
    // await SmsAutoFill().listenForCode;
    // Get.to(const OtpDialogue());
    // return Get.to(const OtpDialogue());

    try {
      isLoading(true);
      var dio = Dio(); // DIO is library to deal with APIs

      // registeruserdata.value.accountType = registeruserdata.value.showType;

      var response = await dio.get(
        userCheckUrl + userName,
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
        // var _x = response.data[0];

        if (response.data.isEmpty) {
          userExist.value = false;
          var resp = await phoneController.verifyPhone(_number);
          await SmsAutoFill().listenForCode;
          Get.to(const OtpDialogue());
        } else {
          mySnackbar(
              "Failed".tr, "error or already_exist user name".tr, "Error");
        }
      } else {
        mySnackbar("Failed".tr, "invalid_num_or_already_exist".tr, "Error");
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future profileUpdate(User userProfile) async {
    // var f = _loadUserData('user');
    // print(f);

    //return Get.offAll(ProfileRegisterPage());

    try {
      isLoading(true);
      var dio = Dio(); // DIO is library to deal with APIs

      //registeruserdata.value.accountType = registeruserdata.value.showType;

      var response = await dio.post(
        profileUrl,
        data: {
          'username': currentUserController
              .currentUser.value.username, //registeruserdata.value.username,
          'email': userProfile.email,
          'phoneNumber': userProfile.phoneNumber,
          'fullName': userProfile.fullName,
          'accountToken': userProfile.accountToken,
          'country': userProfile.country,
          'birthYear': userProfile.birthYear,
          'gender': userProfile.gender,
          'city': userProfile.city,
          'userType': 'student',
          'token': currentUserController.currentUser.value.token,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 505;
          },
          //headers: {},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //final responseData = json.decode(response.data);
        User _regiuser = User.fromJson(response.data);

        currentUserController.currentUser.value = _regiuser;

        storeUserData(currentUserController.currentUser.value,
            'user'); // save UserID, User name , Phone Num
        myBottomBarCtrl.selectedIndBottomBar.value = 0;
        Get.offAll(HomePage());
      } else {
        mySnackbar("Failed".tr, "validate_data".tr, "Error");
      }
    } finally {
      isLoading.value = false;
    }
  }
}
