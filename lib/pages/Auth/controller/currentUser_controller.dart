import 'package:quranschool/pages/Auth/controller/phone_controller.dart';

import 'package:quranschool/pages/Auth/controller/sharedpref_function.dart';

import 'package:quranschool/pages/Auth/profile/profile_register.dart';

import 'package:quranschool/pages/Auth/register/otp_dialogue.dart';

import 'package:quranschool/pages/common_widget/error_snackbar.dart';

import 'package:get/get.dart';


import 'package:quranschool/pages/Auth/Model/users.dart';

import 'package:dio/dio.dart';

import 'package:quranschool/pages/common_widget/mybottom_bar/bottom_bar_controller.dart';

import 'package:quranschool/pages/home_page/view/home_page.dart';

import 'package:sms_autofill/sms_autofill.dart';


import '../../../core/db_links/db_links.dart';


class CurrentUserController extends GetxController {

  // Just this currentuser fetch User Model

  var currentUser = User().obs;

  var tempUser = User().obs;

  var isLoading = false.obs;

  var isEditable = true;

  var userExist = true.obs;

  var phoneExist = true.obs;


  final PhoneController phoneController = Get.put(PhoneController());


  final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());


  @override

  void onInit() async {

    super.onInit();

  }


  Future updateUserData(User _userdata) async {

    try {

      isLoading(true);

      var dio = Dio(); // DIO is library to deal with APIs

      storeUserData(currentUser.value, 'user');

      var response = await dio.post(

        editprofileUrl,

        data: {

          'userId': currentUser.value.id,

          //'villaArea': _userdata.villaArea,

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

        storeUserData(currentUser.value, 'user');

      } else {

        //mySnackbar("Failed".tr, "cannot_update_user_data".tr, false);

      }

    } finally {

      isLoading.value = false;

    }

  }


  Future registeruser() async {

    // var f = _loadUserData('user');

    // print(f);


    //return Get.offAll(ProfileRegisterPage());


    try {

      isLoading(true);

      var dio = Dio(); // DIO is library to deal with APIs


      //tempUser.value.accountType = tempUser.value.showType;


      var response = await dio.post(

        register_url,

        data: {

          'username': tempUser.value.username, //tempUser.value.username,

          'password': tempUser.value.password,

          // 'email': tempUser.value.email,

          // 'phoneNumber': tempUser.value.phoneNumber,

          // 'fullName': tempUser.value.fullName,

          // 'accountToken': currentUserController.currentUser.value.accountToken,

          // 'country': tempUser.value.country,

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


        currentUser.value = _regiuser;


        storeUserData(

            currentUser.value, 'user'); // save UserID, User name , Phone Num

        myBottomBarCtrl.selectedIndBottomBar.value = 0;


        tempUser = currentUser;

        currentUser.value.id = -1;

        tempUser.value.updateOld = false;

        tempUser.value.enabledit = true;

        Get.to(ProfileRegisterPage());

      } else {

        mySnackbar("Failed".tr, "error_user".tr, "Error");

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


      // tempUser.value.accountType = tempUser.value.showType;


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

          mySnackbar("Failed".tr, "error_user".tr, "Error");

        }

      } else {

        mySnackbar("Failed".tr, "error_user".tr, "Error");

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


      // tempUser.value.accountType = tempUser.value.showType;


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

          mySnackbar("Failed".tr, "error_user".tr, "Error");

        }

      } else {

        mySnackbar("Failed".tr, "error_data".tr, "Error");

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


      //tempUser.value.accountType = tempUser.value.showType;

      String _url = profileUrl;


      if (currentUser.value.id != -1 && currentUser.value.id != null) {

        _url = _url + "/" + currentUser.value.id.toString();

      }

      // var response = await (currentUserController.currentUser.value.id != null

      //     ? dio.put

      //     : dio.post)


      var response = await dio.post(

        profileUrl,

        data: {

          'username': currentUser.value.username, //tempUser.value.username,

          'email': userProfile.email,

          'phoneNumber': userProfile.phoneNumber,

          'fullName': userProfile.fullName,

          'accountToken': userProfile.accountToken,

          'country': userProfile.country,

          'birthYear': userProfile.birthYear,

          'gender': userProfile.gender,

          'city': userProfile.city,

          'userType': 'student',

          'token': currentUser.value.token,

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


        currentUser.value = _regiuser;


        storeUserData(

            currentUser.value, 'user'); // save UserID, User name , Phone Num

        myBottomBarCtrl.selectedIndBottomBar.value = 0;

        Get.to(HomePage());

      } else {

        mySnackbar("Failed".tr, "error_data".tr, "Error");

      }

    } finally {

      isLoading.value = false;

    }

  }


  Future UpdateoldProfile(User userProfile) async {

    // var f = _loadUserData('user');

    // print(f);


    //return Get.offAll(ProfileRegisterPage());


    try {

      isLoading(true);

      var dio = Dio(); // DIO is library to deal with APIs


      //tempUser.value.accountType = tempUser.value.showType;

      String _url = profileUrl;


      if (currentUser.value.id != -1 && currentUser.value.id != null) {

        _url = _url + "/" + currentUser.value.id.toString();

      }

      // var response = await (currentUserController.currentUser.value.id != null

      //     ? dio.put

      //     : dio.post)


      var response = await dio.put(

        profileUrl + "/" + currentUser.value.id.toString() + '/',

        data: {

          'username': currentUser.value.username, //tempUser.value.username,

          // 'email': userProfile.email,

          // 'phoneNumber': userProfile.phoneNumber,

          'fullName': userProfile.fullName,

          'accountToken': userProfile.accountToken,

          'country': userProfile.country,

          'birthYear': userProfile.birthYear,

          'gender': userProfile.gender,

          'city': userProfile.city,

          'nationality': userProfile.nationality,

          'image': userProfile.image,

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

        currentUser.value = _regiuser;


        storeUserData(

            currentUser.value, 'user'); // save UserID, User name , Phone Num

        myBottomBarCtrl.selectedIndBottomBar.value = 0;

        Get.to(HomePage());

      } else {

        mySnackbar("Failed".tr, "validate_data".tr, "Error");

      }

    } finally {

      isLoading.value = false;

    }

  }

}

