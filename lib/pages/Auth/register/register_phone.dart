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

class RegisterPhonePage extends StatefulWidget {
  @override
  _RegisterPhonePageState createState() => _RegisterPhonePageState();
}

class _RegisterPhonePageState extends State<RegisterPhonePage> {
  final Translatectrl translatectrl = Get.put(Translatectrl());
  final PhoneController phoneController = Get.put(PhoneController());
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());
  final _formKey = GlobalKey<FormState>();
  final _formKeyotp = GlobalKey<FormState>();
  bool _isobscureText1 = true, _isobscureText2 = true;

  String _password = "";
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'SA';

  String? mytoken;

  getToken() async {
    mytoken = await FirebaseMessaging.instance.getToken();
    setState(() {
      currentUserController.currentUser.value.accountToken = mytoken!;
      mytoken = mytoken;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getToken();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        //decoration: ldecoration,
        child: Scaffold(

            ///=======================================================================
            ///==================== Body ========================================
            ///=======================================================================
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
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(top: h(35), right: sp(20), left: sp(20)),
              // form
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/sms.png",
                      width: sp(40),
                      height: sp(40),
                      //color: Colors.red,
                    ),
                    // SvgPicture.asset(
                    //   "assets/images/sportive1.svg",
                    //   width: sp(30),
                    //   height: sp(30),
                    // ),
                    // SizedBox(height: h(1)),

                    SizedBox(height: sp(10)),
                    Text(
                      'We have sent you an access code'.tr,
                      style: const TextStyle(color: Color(0xFF727272)),
                    ),
                    Text(
                      'via SMS for Mobile number verifications'.tr,
                      style: const TextStyle(color: Color(0xFF727272)),
                    ),
                    Text(
                      'Sent via SMS on this number'.tr,
                      style: const TextStyle(color: Color(0xFF727272)),
                    ),

                    ///=======================================================================
                    ///==================== First Name ========================================
                    ///=======================================================================
                    // Name
                    TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 1) {
                          return 'Please_Enter_First_Name'.tr;
                        }
                        return null;
                      },
                      onSaved: (val) =>
                          currentUserController.tempUser.value.fullName = val!,

                      //autofocus: false,
                      // Text Style
                      style: TextStyle(fontSize: sp(10), color: Colors.black),
                      // keyboardType: TextInputType.phone,
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.allow(RegExp('[0-9.,+]+'))
                      // ],

                      /// decoration
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(Icons.person
                              //color: Colors.white,
                              ),
                        ),
                        border: InputBorder.none,
                        hintText: 'Enter_your_First_Name'.tr,
                        filled: false,
                        fillColor: lblue,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, right: 14.0, bottom: 6.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          //  borderSide: BorderSide(color: lgreen),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          //  borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),

                      /// end of decoration
                    ),
                    SizedBox(height: sp(10)),

                    ///=======================================================================
                    ///==================== Last Name ========================================
                    ///=======================================================================
                    // Name
                    TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 1) {
                          return 'Please_Enter_Last_Name'.tr;
                        }
                        return null;
                      },
                      onSaved: (val) =>
                          currentUserController.tempUser.value.fullName = val!,

                      //autofocus: false,
                      // Text Style
                      style: TextStyle(fontSize: sp(10), color: Colors.black),
                      // keyboardType: TextInputType.phone,
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.allow(RegExp('[0-9.,+]+'))
                      // ],

                      /// decoration
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(Icons.person
                              //color: Colors.white,
                              ),
                        ),
                        border: InputBorder.none,
                        hintText: 'Enter_your_Last_Name'.tr,
                        filled: false,
                        fillColor: lblue,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, right: 14.0, bottom: 6.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          //  borderSide: BorderSide(color: lgreen),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          //  borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),

                      /// end of decoration
                    ),
                    SizedBox(height: sp(10)),

                    ///=======================================================================
                    ///==================== Telephone ========================================
                    ///=======================================================================

                    IntlPhoneField(
                      decoration: InputDecoration(
                        labelText: 'Phone_Number'.tr,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      initialCountryCode: 'EG',

                      // onChanged: (phone) {
                      //   currentUserController.tempUser.value.phoneNumber =
                      //       phone.completeNumber.toString();
                      // },
                      onChanged: (phone) {
                        String enteredNumber = phone.completeNumber;

                        // Check if initialCountryCode is EG and entered number starts with 0
                        if (phone.countryCode == 'EG' &&
                            enteredNumber.startsWith('0')) {
                          // Remove the leading zero if it's the first digit
                          enteredNumber = enteredNumber.substring(1);
                        }

                        currentUserController.tempUser.value.phoneNumber =
                            enteredNumber;
                      },
                    ),

                    SizedBox(height: sp(10)),

                    ///=======================================================================
                    ///==================== Password ========================================
                    ///=======================================================================

                    /// Password
                    TextFormField(
                      style: TextStyle(fontSize: sp(10), color: Colors.black),
                      onSaved: (val) => _password = val!,

                      validator: (val) {
                        val!.length < 2
                            ? 'Password_too_short'.tr
                            : setState(() {
                                _password = val;
                              });
                      },
                      obscureText:
                          _isobscureText1, // to show stars for password
                      autofocus: false,

                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'password'.tr,
                        filled: false,
                        // fillColor: lblue,
                        prefixIcon: const Icon(
                          Icons.security,
                          //color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isobscureText1 = !_isobscureText1;
                              });
                            },
                            icon: Icon(
                              _isobscureText1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              //   color: Colors.white60,
                            )),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, right: 14.0, bottom: 6.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          //borderSide: BorderSide(color: lgreen),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          //  borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),

                    ///=======================================================================
                    ///==================== Password Confirm ========================================
                    ///=======================================================================
                    SizedBox(height: sp(3)),

                    /// Password
                    TextFormField(
                      style: TextStyle(fontSize: sp(10), color: Colors.black),
                      onSaved: (val) =>
                          currentUserController.tempUser.value.password = val!,

                      validator: (val) => val!.length < 2 || val != _password
                          ? 'password_are_not_matching'.tr
                          : null,
                      obscureText:
                          _isobscureText2, // to show stars for password
                      autofocus: false,

                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'reenter_password'.tr,
                        filled: false,
                        fillColor: lblue,
                        prefixIcon: const Icon(
                          Icons.security,
                          //color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isobscureText2 = !_isobscureText2;
                              });
                            },
                            icon: Icon(
                              _isobscureText2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              // color: Colors.white60,
                            )),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, right: 14.0, bottom: 6.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          // borderSide: BorderSide(color: lgreen),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          //  borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),

                    ///=======================================================================
                    ///==================== Register button========================================
                    ///=======================================================================
                    SizedBox(height: sp(12)),
                    Obx(() => currentUserController.isLoading.isTrue
                        ? LoadingFlipping.circle(
                            borderColor: clickIconColor,
                            borderSize: 3.0,
                            size: sp(40),
                            //backgroundColor: const Color(0xff112A04),
                            duration: const Duration(milliseconds: 500),
                          )
                        : SizedBox(
                            width: w(60),
                            child:
                                // our local Elvated Button (text , color , onpress:(){})
                                ElevatedButton(
                                    child: Text('Sign_up'.tr,
                                        style: TextStyle(fontSize: sp(20))),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color(0xFFFD8C00))),
                                    onPressed: () async {
                                      ///=====================
                                      /// OTP Check ===================
                                      // =======================

                                      final form = _formKey.currentState;
                                      if (form!.validate()) {
                                        form.save();

                                        var resp = await phoneController
                                            .verifyPhone(currentUserController
                                                .tempUser.value.phoneNumber);
                                        await SmsAutoFill().listenForCode;
                                        Get.to(const OtpDialogue());

                                        //  active the below \\\\\\\ <------------------------------------
                                        // currentUserController.chdeck_number(
                                        //     currentUserController.tempUser
                                        //         .value.phoneNumber);

                                        // var resp = await phoneController.verifyPhone(
                                        //    currentUserController.tempUser.value.phoneNumber);
                                        // await SmsAutoFill().listenForCode;
                                        // Get.to(const OtpDialogue());
                                      } else {
                                        mySnackbar(
                                            'Failed'.tr, 'error_num'.tr, false);
                                      }
                                    }),
                          )),
                    SizedBox(height: sp(5)),

                    ///=======================================================================
                    ///==================== Go to Signup ========================================
                    ///=======================================================================
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      TextButton(
                          onPressed: () {
                            Get.to(() => LoginPage());
                          },
                          child: Text('Already_have_an_account_sign_in'.tr,
                              style: TextStyle(
                                  color: Color(0xFFFD8C00), fontSize: sp(10)))),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    )));
  }
}
