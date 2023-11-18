import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/profile/country_city.dart';
import 'package:quranschool/pages/Auth/profile/termsandcondition.dart';
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
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/translation/translate_ctrl.dart';
import 'package:search_choices/search_choices.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class ProfileRegisterPage extends StatefulWidget {
  @override
  _ProfileRegisterPageState createState() => _ProfileRegisterPageState();
}

class _ProfileRegisterPageState extends State<ProfileRegisterPage> {
  final Translatectrl translatectrl = Get.put(Translatectrl());
  final RegisterController registerController = Get.put(RegisterController());
  final PhoneController phoneController = Get.put(PhoneController());
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());
  final _formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'SA';
  String gender = 'male';
  DateTime selecteddate = DateTime(DateTime.now().year);
  String? mytoken;
  String? countryValue;
  String? stateValue;
  String? cityValue;
  DateTime? _selected;
  var _listofcity = [];
  TextEditingController dateinput = TextEditingController();
  bool? acceptedTerms = false;

  bool termsWarningEnable = false;

// Get Token from Firebase
  getToken() async {
    mytoken = await FirebaseMessaging.instance.getToken();
    setState(() {
      currentUserController.currentUser.value.accountToken = mytoken!;
      registerController.registeruserdata.value.accountToken = mytoken!;
      mytoken = mytoken;
    });
  }

// press birthdate
  Future<void> _onPressedBirthDate({
    required BuildContext context,
    String? locale,
  }) async {
    final localeObj = locale != null ? Locale(locale) : null;
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: _selected ?? DateTime(DateTime.now().year - 3),
      firstDate: DateTime(DateTime.now().year - 80),
      lastDate: DateTime(DateTime.now().year - 3),
      locale: localeObj,
    );

    if (selected != null) {
      setState(() {
        _selected = selected;
        String formattedDate = DateFormat('yyyy').format(selected);
        dateinput.text = formattedDate;
        registerController.registeruserdata.value.birthYear =
            int.parse(formattedDate);
      });
    } else {
      print("Date is not selected");
    }
  }

// Toggle Check box of Terms and Condition
  void _toggleAcceptance(bool? newValue) {
    setState(() {
      acceptedTerms = newValue;
      if (acceptedTerms == false) {
        termsWarningEnable = acceptedTerms!;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateinput.text = "";
// get city list if use selected the country before
    if (currentUserController.currentUser.value.country != "") {
      try {
        var _checklist =
            listof_city(currentUserController.currentUser.value.country);
        if (_checklist != null) {
          _listofcity = _checklist;
        }
      } on Exception catch (_) {
        print('never reached');
      }
    }
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: simplAppbar(true, "Profile"),
      // backgroundColor: Colors.transparent,

      ///=======================================================================
      ///==================== Body ========================================
      ///=======================================================================
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: h(5), right: sp(8), left: sp(8)),
          // form
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image.asset(
                //   "assets/images/logo/logo.png",
                //   width: sp(60),
                //   height: sp(60),
                //   //color: Colors.red,
                // ),
                // SvgPicture.asset(
                //   "assets/images/sportive1.svg",
                //   width: sp(30),
                //   height: sp(30),
                // ),
                // SizedBox(height: h(1)),

                SizedBox(height: sp(10)),

                ///=======================================================================
                ///==================== full Name ========================================
                ///=======================================================================
                // Name
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 1) {
                      return 'Please_Enter_full_Name'.tr;
                    }
                    return null;
                  },
                  onSaved: (val) =>
                      registerController.registeruserdata.value.fullName = val!,

                  //autofocus: false,
                  // Text Style
                  style: TextStyle(fontSize: sp(10), color: Colors.black),
                  // keyboardType: TextInputType.phone,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp('[0-9.,+]+'))
                  // ],

                  /// decoration
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.person
                          //color: Colors.white,
                          ),
                    ),
                    border: InputBorder.none,
                    hintText: 'full_Name'.tr,
                    filled: false,
                    fillColor: lblue,
                    contentPadding: const EdgeInsets.only(
                        left: 4.0, right: 4.0, bottom: 6.0, top: 8.0),
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
                //=======================================================================
                //=============Gender Male Female ===========================================
                //=======================================================================
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text('Gender'.tr,
                            style: TextStyle(color: graytextColor))),
                    Expanded(
                      flex: 3,
                      child: ListTile(
                        title: Text('Male'.tr,
                            style: TextStyle(color: graytextColor)),
                        leading: Radio(
                          activeColor: textbuttonColor,
                          value: 'male',
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value.toString();
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: ListTile(
                        title: Text('Female'.tr,
                            style: TextStyle(color: graytextColor)),
                        leading: Radio(
                          value: 'female',
                          activeColor: textbuttonColor,
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value.toString();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: sp(10)),

                //=======================================================================
                //=============Birth Date ===========================================
                //=======================================================================
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 1) {
                      return 'Please_Select_birth Date'.tr;
                    }
                    return null;
                  },

                  controller: dateinput, //editing controller of this TextField
                  decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today,
                          color: mybrowonColor), //icon of text field
                      labelText: "Birth date" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    _onPressedBirthDate(context: context);
                  },
                ),
                SizedBox(height: sp(10)),

                //=======================================================================
                //=============Country ===========================================
                //=======================================================================
                Row(children: [
                  // Icon(Icons.location_history),
                  Icon(Icons.flag, color: mybrowonColor),
                  Expanded(
                    child: SearchChoices.single(
                      readOnly:
                          !currentUserController.currentUser.value.enabledit,

                      icon: currentUserController.currentUser.value.enabledit
                          ? Icon(Icons.arrow_drop_down)
                          : Text(''),
                      //label: Icon(Icons.location_history),

                      items: countrieslist
                          .map<DropdownMenuItem<dynamic>>((var value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            (value.toString()).tr,
                            style: TextStyle(color: graytextColor),
                          ),
                        );
                      }).toList(),
                      value: registerController
                                  .registeruserdata.value.country !=
                              ""
                          ? registerController.registeruserdata.value.country
                          : null,
                      hint: "country_hint".tr,
                      searchHint: "select_country".tr,
                      displayClearIcon: false,
                      onChanged: (value) {
                        setState(() {
                          registerController.registeruserdata.value.country =
                              value;
                          _listofcity = listof_city(value);
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                ]),

                SizedBox(height: sp(6)),
                //=======================================================================
                //=============City ===========================================
                //=======================================================================

                Row(children: [
                  Icon(Icons.location_city, color: mybrowonColor
                      //  color: Colors.white70,
                      ),
                  Expanded(
                    child: SearchChoices.single(
                      readOnly:
                          !registerController.registeruserdata.value.enabledit,

                      icon: registerController.registeruserdata.value.enabledit
                          ? Icon(Icons.arrow_drop_down)
                          : Text(''),
                      //label: Icon(Icons.location_history),

                      items: _listofcity
                          .map<DropdownMenuItem<dynamic>>((var value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            (value.toString()).tr,
                            style: TextStyle(color: graytextColor),
                          ),
                        );
                      }).toList(),
                      value:
                          registerController.registeruserdata.value.city != ""
                              ? registerController.registeruserdata.value.city
                              : null,
                      hint: "city_hint".tr,
                      searchHint: "select_city",
                      displayClearIcon: false,
                      onChanged: (value) {
                        setState(() {
                          registerController.registeruserdata.value.city =
                              value;
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                ]),

                //=======================================================================
                //=============Nationality  ===========================================
                //=======================================================================

                Row(children: [
                  Icon(Icons.people,
                      color:
                          mybrowonColor), //Icon(Icons.flag,color:Colors.white70),
                  Expanded(
                    child: SearchChoices.single(
                      readOnly:
                          !registerController.registeruserdata.value.enabledit,

                      icon: registerController.registeruserdata.value.enabledit
                          ? Icon(Icons.arrow_drop_down)
                          : Text(''),
                      //label: Icon(Icons.location_history),

                      items: nationalitylist
                          .map<DropdownMenuItem<dynamic>>((var value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            (value.toString()).tr,
                            style: TextStyle(color: graytextColor),
                          ),
                        );
                      }).toList(),
                      value: registerController
                                  .registeruserdata.value.nationality !=
                              ""
                          ? registerController
                              .registeruserdata.value.nationality
                          : null,
                      hint: "nationality_hint".tr,
                      searchHint: "select_nationality".tr,
                      displayClearIcon: false,
                      onChanged: (value) {
                        setState(() {
                          registerController
                              .registeruserdata.value.nationality = value;
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                ]),

                //=======================================================================
                //=============Terms And Condition ===========================================
                //=======================================================================

                Row(
                  children: [
                    Material(
                      child: Checkbox(
                        activeColor: mybrowonColor,
                        value: acceptedTerms,
                        onChanged: _toggleAcceptance,
                      ),
                    ),
                    TextButton(
                      child: Text('I have read and accept terms and conditions',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: termsWarningEnable
                                  ? Colors.red
                                  : mybrowonColor)),
                      onPressed: () {
                        Get.to(TermsCondition());
                      },
                    )
                  ],
                ),

                ///=======================================================================
                ///==================== Register button========================================
                ///=======================================================================
                SizedBox(height: sp(12)),
                Obx(() => registerController.isLoading.isTrue
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
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xFFFD8C00))),
                                onPressed: () async {
                                  ///=====================
                                  /// OTP Check ===================
                                  // =======================

                                  final form = _formKey.currentState;
                                  if (form!.validate()) {
                                    if (acceptedTerms == false) {
                                      setState(() {
                                        termsWarningEnable = true;
                                      });
                                      return;
                                    }
                                    form.save();
                                    await registerController.profileUpdate(
                                        registerController
                                            .registeruserdata.value);
                                    // Get.to(() => PhoneSMSHandler());

                                    // =======================
                                    /// check Phonenumber and send OTP===================
                                    // =======================

                                    // phoneController.usernum.value =
                                    //     registerController
                                    //         .registeruserdata.value.phoneNumber;

                                    // var resp = await phoneController
                                    //     .verifyPhone(registerController
                                    //         .registeruserdata
                                    //         .value
                                    //         .phoneNumber);
                                    // await SmsAutoFill().listenForCode;
                                    // Get.to(const OtpDialogue());

//  active the below \\\\\\\ <------------------------------------
                                    // registerController.chdeck_number(
                                    //     registerController.registeruserdata
                                    //         .value.phoneNumber);

                                    // var resp = await phoneController.verifyPhone(
                                    //     registerController
                                    //         .registeruserdata.value.phoneNumber);
                                    // await SmsAutoFill().listenForCode;
                                    // Get.to(const OtpDialogue());
                                  } else {
                                    mySnackbar(
                                        'Invalid'.tr,
                                        'invalid_num_or_already_exist'.tr,
                                        false);
                                  }
                                }),
                      )),
                SizedBox(height: sp(5)),

                ///=======================================================================
                ///==================== Go to Signup ========================================
                ///=======================================================================
                // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                //   TextButton(
                //       onPressed: () {
                //         Get.to(() => LoginPage());
                //       },
                //       child: Text('Already_have_an_account_sign_in'.tr,
                //           style: TextStyle(
                //               color: Color(0xFFFD8C00), fontSize: sp(10)))),
                // ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
