import 'package:argon_buttons_flutter_fix/argon_buttons_flutter.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/translation/translate_ctrl.dart';

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

class OtpDialogue extends StatefulWidget {
  const OtpDialogue({Key? key}) : super(key: key);

  @override
  _OtpDialogueState createState() => _OtpDialogueState();
}

class _OtpDialogueState extends State<OtpDialogue> {
  final _formKey = GlobalKey<FormState>();
  final PhoneController phoneController = Get.put(PhoneController());
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

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
      // appBar: simplAppbar(true),
      // backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        // alignment: Alignment.topCenter,
        children: [
          Positioned(
            // left: 0,
            top: 0,
            child: Image.asset(
              'assets/images/appbar.png', // Update with your first image path
              width: w(100),
              height: h(20),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: h(10),
            left: w(30),
            child: Image.asset(
              'assets/images/logo/logo.png', // Update with your second image path
              width: w(40),
              height: h(20),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: h(30), right: sp(20), left: sp(20)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() => Visibility(
                          visible:
                              phoneController.authStatus.value == 'OTP_Sent',
                          child: Image.asset(
                            "assets/icons/sms.png",
                            width: sp(40),
                            height: sp(40),
                            //color: Colors.red,
                          ),
                        )),
                    // SvgPicture.asset(
                    //   "assets/images/sportive1.svg",
                    //   width: sp(30),
                    //   height: sp(30),
                    // ),
                    // SizedBox(height: h(1)),

                    SizedBox(height: sp(10)),
                    Obx(() => Visibility(
                          visible:
                              phoneController.authStatus.value == 'OTP_Sent',
                          child: Text(
                            'sent_code'.tr,
                            style: const TextStyle(color: Color(0xFF727272)),
                          ),
                        )),
                    Obx(() => Visibility(
                          visible:
                              phoneController.authStatus.value == 'OTP_Sent',
                          child: Text(
                            'via_sms'.tr,
                            style: const TextStyle(color: Color(0xFF727272)),
                          ),
                        )),
                    Obx(() => Visibility(
                          visible:
                              phoneController.authStatus.value == 'OTP_Sent',
                          child: Text(
                            'sent_sms_to_num'.tr,
                            style: const TextStyle(color: Color(0xFF727272)),
                          ),
                        )),
                    SizedBox(height: sp(10)),
                    Obx(() => Visibility(
                          visible:
                              phoneController.authStatus.value == 'OTP_Sent',
                          child: Padding(
                            padding: EdgeInsets.only(left: w(10), right: w(10)),
                            child: IntlPhoneField(
                              readOnly: true,
                              enabled: false,
                              decoration: InputDecoration(
                                //labelText: 'Phone_Number'.tr,
                                border: OutlineInputBorder(
                                  // borderSide: BorderSide(),
                                  borderRadius: BorderRadius.circular(20),
                                  //borderSide: BorderSide(),
                                ),
                                fillColor: Colors.white,
                              ),
                              initialCountryCode: 'EG',
                              initialValue: currentUserController
                                  .tempUser.value.phoneNumber,
                              onChanged: (phone) {
                                currentUserController
                                        .tempUser.value.phoneNumber =
                                    phone.completeNumber.toString();
                              },
                            ),
                          ),
                        )),

                    ///=======================================================================
                    ///==================== OTP ========================================
                    ///=======================================================================
                    // Name
                    SizedBox(height: h(2)),
                    Obx(() => Visibility(
                        visible: phoneController.authStatus.value ==
                            'Please Wait. Sending SMS..',
                        child: Center(
                            child: LoadingBouncingGrid.circle(
                          backgroundColor: clickIconColor,
                        )))),
                    SizedBox(height: h(2)),

                    Obx(() => Visibility(
                        visible: phoneController.authStatus.value == 'OTP_Sent',
                        child: const Divider())),
                    Obx(() => Visibility(
                          visible:
                              phoneController.authStatus.value == 'OTP_Sent',
                          child:
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(9),
                              //       color: lgreen2,
                              //       boxShadow: [
                              //         BoxShadow(color: lgreen, spreadRadius: 1),
                              //       ],
                              //     ),
                              //     child: TextFormField(
                              //         validator: (value) {
                              //           if (value == null ||
                              //               value.isEmpty ||
                              //               value.length < 1) {
                              //             return 'Enter_OTP'.tr;
                              //           }
                              //           return null;
                              //         },
                              //         onChanged: (val) =>
                              //             phoneController.userotp.value = val,
                              //         onSaved: (val) =>
                              //             phoneController.userotp.value = val!,
                              //         decoration: InputDecoration(
                              //           prefixIcon: Icon(
                              //             Icons.sms,
                              //             //color: Colors.white,
                              //           ),
                              //           // border: InputBorder,
                              //           hintText: 'Enter_OTP'.tr,
                              //         )),
                              //   ),
                              // ),
                              Padding(
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
                              onCodeSubmitted: (value) async {
                                phoneController.userotp.value = value;
                                var otpcorrect = await phoneController
                                    .otpVerify(phoneController.userotp.value);

                                if (otpcorrect) {
                                  phoneController.otpcorrect(false);
                                } else {
                                  mySnackbar(
                                      'Failed'.tr, 'error_data'.tr, false);
                                }
                              },
                              onCodeChanged: (value) async {
                                if (value!.length == 6) {
                                  phoneController.userotp.value = value;
                                  var otpcorrect = await phoneController
                                      .otpVerify(phoneController.userotp.value);

                                  if (otpcorrect) {
                                    phoneController.otpcorrect(false);
                                    await currentUserController.registeruser();
                                  } else {
                                    mySnackbar(
                                        'Failed'.tr, 'error_data'.tr, false);
                                  }
                                }
                                //  print(value);
                              },
                            ),
                          ),
                        )),

                    ///=======================================================================
                    ///==================== Timer  ========================================
                    ///=======================================================================
                    Obx(() => Visibility(
                        visible:
                            phoneController.authStatus.value == 'OTP_Sent' &&
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
                            ringColor: const Color.fromARGB(255, 202, 219, 228),

                            // Ring Gradient for Countdown Widget.
                            ringGradient: null,

                            // Filling Color for Countdown Widget.
                            fillColor: clickIconColor,

                            // Filling Gradient for Countdown Widget.
                            fillGradient: null,

                            // Background Color for Countdown Widget.
                            backgroundColor: Colors.black54,

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
                              print('Countdown Started');
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

                    ///=======================================================================
                    ///==================== Resend button after timer ========================================
                    ///=======================================================================
                    Obx(() => Visibility(
                        visible: phoneController.authStatus.value == 'OTP_Sent',
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _showotpButton
                                    ? ArgonTimerButton(
                                        height: 50,

                                        width: w(30),
                                        minWidth: w(25),
                                        highlightColor:
                                            Color.fromARGB(0, 197, 23, 23),
                                        highlightElevation: 0,
                                        roundLoadingShape: false,
                                        onTap: (startTimer, btnState) async {
                                          if (btnState == ButtonState.Idle) {
                                            startTimer(120);
                                            await phoneController.verifyPhone(
                                                currentUserController.tempUser
                                                    .value.phoneNumber);
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
                                        color: Color.fromARGB(0, 192, 55, 55),
                                        elevation: 0,
                                        borderSide: BorderSide(
                                            color: const Color.fromARGB(
                                                255, 202, 117, 117),
                                            width: 1.5),
                                      )
                                    : Text(''),
                              ]),
                        ))),
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
          ),
        ],
      ),
    );
  }

  _listeOTP() async {
    await SmsAutoFill().listenForCode;
  }
}
