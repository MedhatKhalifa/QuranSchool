import 'package:argon_buttons_flutter_fix/argon_buttons_flutter.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:quranschool/pages/Auth/login/set_password.dart';
import 'package:quranschool/pages/common_widget/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/pages/common_widget/local_colors.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/pages/common_widget//simple_appbar.dart';
import 'package:quranschool/pages/Auth/controller/phone_controller.dart';
import 'package:quranschool/pages/Auth/controller/register_controller.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../core/theme.dart';
import '../controller/forgetPassword_controller.dart';

class OtpForgetPassPage extends StatefulWidget {
  const OtpForgetPassPage({Key? key}) : super(key: key);

  @override
  _OtpForgetPassPageState createState() => _OtpForgetPassPageState();
}

class _OtpForgetPassPageState extends State<OtpForgetPassPage> {
  final _formKey = GlobalKey<FormState>();
  final PhoneController phoneController = Get.put(PhoneController());
  final ForgerPassController forgerPassController =
      Get.put(ForgerPassController());
  final _formKeyotp = GlobalKey<FormState>();
  CountDownController _controller = CountDownController();
  int _duration = 60;
  bool _showotpButton = false;
  @override
  void initState() {
    super.initState();
    _listeOTP();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: simplAppbar(true),
      // backgroundColor: Colors.transparent,
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.,
            children: [
              ///=======================================================================
              ///==================== OTP ========================================
              ///=======================================================================
              // Name
              SizedBox(height: h(20)),
              Obx(() => Visibility(
                  visible: phoneController.authStatus.value ==
                      'Please Wait. Sending SMS..',
                  child: Center(
                      child: LoadingBouncingGrid.circle(
                    backgroundColor: clickIconColor,
                  )))),
              SizedBox(height: h(8)),

              Obx(() => Visibility(
                  visible: phoneController.authStatus.value == 'OTP_Sent' &&
                      !_showotpButton,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularCountDownTimer(
                      // Countdown duration in Seconds.
                      duration: _duration,

                      // Countdown initial elapsed Duration in Seconds.
                      initialDuration: 0,

                      // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
                      controller: _controller,

                      // Width of the Countdown Widget.
                      width: w(10),

                      // Height of the Countdown Widget.
                      height: h(5),

                      // Ring Color for Countdown Widget.
                      ringColor: Colors.blueGrey,

                      // Ring Gradient for Countdown Widget.
                      ringGradient: null,

                      // Filling Color for Countdown Widget.
                      fillColor: textbuttonColor,

                      // Filling Gradient for Countdown Widget.
                      fillGradient: null,

                      // Background Color for Countdown Widget.
                      backgroundColor: clickIconColor,

                      // Background Gradient for Countdown Widget.
                      backgroundGradient: null,

                      // Border Thickness of the Countdown Ring.
                      strokeWidth: 20.0,

                      // Begin and end contours with a flat edge and no extension.
                      strokeCap: StrokeCap.round,

                      // Text Style for Countdown Text.
                      textStyle: TextStyle(
                          fontSize: sp(10),
                          color: Colors.white,
                          fontWeight: FontWeight.bold),

                      // Format for the Countdown Text.
                      textFormat: CountdownTextFormat.S,

                      // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                      isReverse: true,

                      // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                      isReverseAnimation: false,

                      // Handles visibility of the Countdown Text.
                      isTimerTextShown: true,

                      // Handles the timer start.
                      autoStart: true,

                      // This Callback will execute when the Countdown Starts.
                      onStart: () {
                        // Here, do whatever you want
                      },

                      // This Callback will execute when the Countdown Ends.
                      onComplete: () {
                        // Here, do whatever you want
                        setState(() {
                          _showotpButton = true;
                        });
                      },
                    ),
                  ))),

              Obx(() => Visibility(
                  visible: phoneController.authStatus.value == 'OTP_Sent',
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('enter_otp'.tr),
                          _showotpButton
                              ? ArgonTimerButton(
                                  height: 50,

                                  width: w(30),
                                  minWidth: w(25),
                                  highlightColor: Colors.transparent,
                                  highlightElevation: 0,
                                  roundLoadingShape: false,
                                  onTap: (startTimer, btnState) async {
                                    if (btnState == ButtonState.Idle) {
                                      startTimer(40);
                                      await phoneController.verifyPhone(
                                          phoneController.usernum.value);
                                    }
                                  },
                                  // initialTimer: 10,
                                  child: Text(
                                    "resend_otp".tr,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: sp(10),
                                        fontWeight: FontWeight.w700),
                                  ),
                                  loader: (timeLeft) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "$timeLeft",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: sp(10),
                                            fontWeight: FontWeight.w700),
                                      ),
                                    );
                                  },
                                  borderRadius: 5.0,
                                  color: Colors.transparent,
                                  elevation: 0,
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.5),
                                )
                              : Text(''),
                        ]),
                  ))),

              Obx(() => Visibility(
                  visible: phoneController.authStatus.value == 'OTP_Sent',
                  child: const Divider())),
              Obx(() => Visibility(
                    visible: phoneController.authStatus.value == 'OTP_Sent',
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: PinFieldAutoFill(
                        cursor: Cursor(
                          width: 2,
                          height: 40,
                          color: Colors.red,
                          radius: Radius.circular(1),
                          enabled: true,
                        ),
                        codeLength: 6,
                        onCodeSubmitted: (value) async {},
                        onCodeChanged: (value) async {
                          if (value!.length == 6) {
                            phoneController.userotp.value = value;
                            var otpcorrect = await phoneController
                                .otpVerify(phoneController.userotp.value);

                            if (otpcorrect) {
                              phoneController.otpcorrect(false);
                              Get.to(SetNewPassword());
                              // await forgerPassController.resetpassword(
                              //     forgerPassController.resetPassword.value,
                              //     forgerPassController.username.value);
                            } else {
                              Get.snackbar("Invalid".tr, 'user_error'.tr);
                            }
                          }
                          //  print(value);
                        },
                      ),
                    ),
                  )),

              Obx(() => (phoneController.authStatus.value) != 'OTP_Sent'
                  ? Center(
                      child: Text(phoneController.authStatus.value,
                          style: TextStyle(fontSize: sp(12))))
                  : Text('')),

              ///=======================================================================
              ///==================== Go to Signup ========================================
              ///=======================================================================
            ],
          ),
        ),
      ),
    );
  }

  _listeOTP() async {
    await SmsAutoFill().listenForCode;
  }
}
