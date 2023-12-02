import 'package:quranschool/pages/Auth/controller/sharedpref_function.dart';
import 'package:quranschool/pages/common_widget/error_snackbar.dart';
import 'package:get/get.dart';

import 'package:quranschool/pages/Auth/Model/users.dart';
import 'package:dio/dio.dart';

import '../../../core/db_links/db_links.dart';

class CurrentUserController extends GetxController {
  // Just this currentuser fetch User Model
  var currentUser = User().obs;
  var isLoading = false.obs;
  var isEditable = true;
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
}
