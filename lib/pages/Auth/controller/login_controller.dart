import 'package:quranschool/pages/Auth/controller/register_controller.dart';
import 'package:quranschool/pages/Auth/profile/profile_register.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:quranschool/core/db_links/db_links.dart';
import 'package:quranschool/pages/Auth/Model/users.dart';

import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/common_widget/error_snackbar.dart';

import '../../common_widget/mybottom_bar/bottom_bar_controller.dart';
import 'sharedpref_function.dart';

class LoginController extends GetxController {
  var phone = "".obs;
  var password = "".obs;
  var username = "".obs;
  var isLoading = false.obs;
  final CurrentUserController userctrl = Get.put(CurrentUserController());
  final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());
  final RegisterController registerController = Get.put(RegisterController());

  @override
  void onInit() {
    super.onInit();
  }

  Future checkuser() async {
    try {
      isLoading(true);
      var dio = Dio();

      var response = await dio.post(
        login_url,
        data: {
          'username': username.value,
          'password': password.value,
          //'accountToken': userctrl.currentUser.value.accountToken,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 600;
          },
          //headers: {},
        ),
      );

      if (response.statusCode == 200) {
        //User _regiuser = User.fromJson(response.data);

        // getuserProfile(response.data['id']);
        var _token = userctrl.currentUser.value.accountToken;

        User _regiuser =
            User.fromJson(response.data['userProfile'][0]['fields']);
        // get user profile and store data
        _regiuser.token = response.data['userProfile'][0]['token'] ?? "";
        _regiuser.id = response.data['userProfile'][0]['pk'] ?? -1;
        userctrl.currentUser.value = _regiuser;
        userctrl.currentUser.value.accountToken = _token;

        storeUserData(userctrl.currentUser.value,
            'user'); // save UserID, User name , Phone Num

        // myBottomBarCtrl.selectedIndBottomBar.value = 0;
        // Get.offAll(HomePage());
        updateToken(_regiuser.id);
        // get user profile and store data
        // userctrl.currentUser.value = _regiuser;

        // storeUserData(userctrl.currentUser.value,
        //     'user'); // save UserID, User name , Phone Num

        // myBottomBarCtrl.selectedIndBottomBar.value = 0;
        // Get.offAll(CategoryPage());

        // // to read all cart data ( can be removed in other apps)
        // cartController.getcartList();
      } else {
        mySnackbar('Failed'.tr, 'phone_password_not'.tr, false);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future updateToken(userID) async {
    try {
      isLoading(true);
      var dio = Dio();

      var response = await dio.put(
        profileUrl + userID.toString() + "/",
        data: {
          'username': userctrl.currentUser.value.username,
          'accountToken': userctrl.currentUser.value.accountToken
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 600;
          },
          //headers: {},
        ),
      );

      if (response.statusCode == 200) {
        myBottomBarCtrl.selectedIndBottomBar.value = 0;
        Get.offAll(HomePage());
      } else {
        mySnackbar('Failed'.tr, 'phone_password_not'.tr, false);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future getuserProfile(userID) async {
    try {
      isLoading(true);
      var dio = Dio();

      var response = await dio.get(
        profileUrl + userID.toString() + "/",
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 600;
          },
          //headers: {},
        ),
      );

      if (response.statusCode == 200) {
        User _regiuser = User.fromJson(response.data);
        // get user profile and store data
        userctrl.currentUser.value = _regiuser;

        storeUserData(userctrl.currentUser.value,
            'user'); // save UserID, User name , Phone Num

        myBottomBarCtrl.selectedIndBottomBar.value = 0;
        Get.offAll(HomePage());
      } else {
        mySnackbar('Failed'.tr, 'phone_password_not'.tr, false);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future getStudentProfile(userID) async {
    try {
      isLoading(true);
      var dio = Dio();

      var response = await dio.get(
        profileUrl + userID.toString() + "/",
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 600;
          },
          //headers: {},
        ),
      );

      if (response.statusCode == 200) {
        User _regiuser = User.fromJson(response.data);
        // get user profile and store data
        userctrl.currentUser.value = _regiuser;

        registerController.registeruserdata.value = _regiuser;
        registerController.registeruserdata.value.updateOld = false;
        registerController.registeruserdata.value.enabledit = false;
        currentUserController.currentUser.value.updateOld = false;
        Get.to(ProfileRegisterPage());
      } else {
        mySnackbar('Failed'.tr, 'Error'.tr, false);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future chdeckGmailUsername(userCredential) async {
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
        userCheckUrl + userCredential.user!.email,
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
          //userExist.value = false;
          // New User Should go to UserProfile
          registerController.registeruserdata.value.fullName =
              userCredential.user!.displayName ?? "";
          registerController.registeruserdata.value.username =
              userCredential.user!.email ?? "-1";
          registerController.registeruserdata.value.email =
              userCredential.user!.email.toString() ?? "";
          registerController.registeruserdata.value.phoneNumber =
              userCredential.user!.phoneNumber ?? "";

          print("Signed in: ${userCredential.user?.displayName}");
          currentUserController.currentUser.value =
              registerController.registeruserdata.value;

          storeUserData(currentUserController.currentUser.value,
              'user'); // save UserID, User name , Phone Num
          myBottomBarCtrl.selectedIndBottomBar.value = 0;
          registerController.registeruserdata =
              currentUserController.currentUser;
          registerController.registeruserdata.value.enabledit = true;
          Get.offAll(ProfileRegisterPage());
          // Navigate to the next screen or perform necessary actions.
        } else {
          // old USer read data
          User _regiuser = User.fromJson(response.data[0]);
          // get user profile and store data
          var _token = userctrl.currentUser.value.accountToken;
          userctrl.currentUser.value = _regiuser;
          userctrl.currentUser.value.accountToken = _token;
          updateToken(_regiuser.id);

          storeUserData(userctrl.currentUser.value,
              'user'); // save UserID, User name , Phone Num

          myBottomBarCtrl.selectedIndBottomBar.value = 0;
          Get.offAll(HomePage());
        }
      } else {
        mySnackbar("Failed".tr, "invalid_num_or_already_exist".tr, "Error");
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Future getplayeridlist(_userid) async {
  //   var dio = Dio();
  //   var response = await dio.get(
  //     "$playerlist_Url${_userid.toString()}/",
  //     options: Options(
  //       followRedirects: false,
  //       validateStatus: (status) {
  //         return status! < 505;
  //       },
  //       //headers: {},
  //     ),
  //   );
  //   var playeridlist = [];
  //   if (response.statusCode == 200) {
  //     //playerId

  //     for (var item in response.data) {
  //       item.forEach((k, v) {
  //         if (k == "playerId") {
  //           playeridlist.add(v);
  //         }
  //       });
  //     }

  //     //_regiuser.playerId = response.data[0]['playerId'];
  //   } else {
  //     print('Erro login');
  //   }
  //   return playeridlist;
  // }
}
