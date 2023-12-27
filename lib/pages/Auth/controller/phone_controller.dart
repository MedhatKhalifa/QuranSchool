import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:quranschool/pages/Auth/Model/users.dart' as myuser;

class PhoneController extends GetxController {
  var isLoading = false.obs;
  var verId = '';
  var authStatus = 'checking_number'.obs;
  var userotp = ''.obs;
  var usernum = ''.obs;
  var otpcorrect = false.obs;
  var tempuser = myuser.User().obs;

  var auth = FirebaseAuth.instance;

// verify phone and send an sms
  verifyPhone(String phone) async {
    String response = "response_not_Sent";
    isLoading.value = true;
    authStatus.value = "Please Wait. Sending SMS..";
    await auth.verifyPhoneNumber(
        timeout: Duration(seconds: 50),
        phoneNumber: phone,
        verificationCompleted: (AuthCredential authCredential) {
          if (auth.currentUser != null) {
            isLoading.value = false;
            // authStatus.value = "OTP_Sent";
          }
        },
        verificationFailed: (authException) {
          // authStatus.value = "OTP_Can't_Sent";
          authStatus.value = "verificationFailed";
          Get.snackbar("otp_sms".tr, "otp_sent".tr);
        },
        codeSent: (String id, [int? forceResent]) {
          isLoading.value = false;
          verId = id;
          // authStatus.value = "login successfully";
          authStatus.value = "OTP_Sent";
          response = "OTP_Sent";
        },
        codeAutoRetrievalTimeout: (String id) {
          verId = id;

          //authStatus.value = "Time_Out";
        });

    return response;
  }

  // to check user opt input // check phone OPT
  otpVerify(String otp) async {
    isLoading.value = true;
    otpcorrect(false);
    try {
      UserCredential userCredential = await auth.signInWithCredential(
          PhoneAuthProvider.credential(verificationId: verId, smsCode: otp));
      if (userCredential.user != null) {
        isLoading.value = false;
        otpcorrect(true);
        Get.snackbar(
          "Success".tr,
          "Correct_OTP".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
        //Get.to(()=>SearchPage());
      }
    } on Exception catch (e) {
      Get.snackbar(
        "Failed".tr,
        "Invalid_OTP".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return false;
  }
}
