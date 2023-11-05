import 'package:quranschool/core/theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/pages/common_widget/local_colors.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/pages/common_widget//simple_appbar.dart';
import 'package:quranschool/pages/Auth/Model/users.dart';
import 'package:quranschool/pages/Auth/controller/forgetPassword_controller.dart';

import 'package:quranschool/pages/home_page/view/home_page.dart';

import '../../home_page/view/home_page.dart';

//import 'package:awesome_dialog/awesome_dialog.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final ForgerPassController forgerPassController =
      Get.put(ForgerPassController());

  final _formKey = GlobalKey<FormState>();

  bool _isobscureText = true;
  User _user = User();
  String _password = "";
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: simplAppbar(true),

      ///=======================================================================
      ///==================== Body ========================================
      ///=======================================================================
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: h(10), right: sp(20), left: sp(20)),
          // form
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: h(5)),

                FittedBox(
                  child: Text('CHANGE_PASSWORD'.tr,
                      style: TextStyle(fontSize: sp(30))),
                ),
                SizedBox(height: sp(20)),

                ///=======================================================================
                ///==================== old password ========================================
                ///=======================================================================
                TextFormField(
                  style: TextStyle(fontSize: sp(10)),
                  onSaved: (val) =>
                      forgerPassController.oldPassword.value = val!,

                  validator: (val) {
                    val!.length < 2
                        ? 'Password_too_short'.tr
                        : setState(() {
                            _password = val;
                          });
                  },
                  obscureText: _isobscureText, // to show stars for password
                  autofocus: false,

                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'old_password'.tr,
                    filled: false,
                    // fillColor: lblue,
                    prefixIcon: Icon(
                      Icons.security,
                      //color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isobscureText = !_isobscureText;
                          });
                        },
                        icon: Icon(
                          _isobscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          //   color: Colors.white60,
                        )),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 6.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      //  borderSide: BorderSide(color: lgreen),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      //     borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),

                SizedBox(height: sp(20)),

                ///=======================================================================
                ///==================== Password ========================================
                ///=======================================================================

                /// Password
                TextFormField(
                  style: TextStyle(fontSize: sp(10)),
                  onSaved: (val) => _password = val!,

                  validator: (val) {
                    val!.length < 2
                        ? 'Password_too_short'.tr
                        : setState(() {
                            _password = val;
                          });
                  },
                  obscureText: _isobscureText, // to show stars for password
                  autofocus: false,

                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'new_password'.tr,
                    filled: false,
                    fillColor: lblue,
                    prefixIcon: Icon(
                      Icons.security,
                      //color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isobscureText = !_isobscureText;
                          });
                        },
                        icon: Icon(
                          _isobscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          //  color: Colors.white60,
                        )),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 6.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      //    borderSide: BorderSide(color: lgreen),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      //      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),

                ///=======================================================================
                ///==================== Password Confirm ========================================
                ///=======================================================================
                SizedBox(height: sp(10)),

                /// Password
                TextFormField(
                  style: TextStyle(fontSize: sp(10)),
                  onSaved: (val) =>
                      forgerPassController.newPassword.value = val!,

                  validator: (val) => val!.length < 2 || val != _password
                      ? 'password_are_not_matching'.tr
                      : null,
                  obscureText: _isobscureText, // to show stars for password
                  autofocus: false,

                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'reEnter_New_password'.tr,
                    filled: false,
                    fillColor: lblue,
                    prefixIcon: Icon(
                      Icons.security,
                      //color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isobscureText = !_isobscureText;
                          });
                        },
                        icon: Icon(
                          _isobscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          //       color: Colors.white60,
                        )),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 6.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      //      borderSide: BorderSide(color: lgreen),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      //        borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),

                ///=======================================================================
                ///====================  button========================================
                ///=======================================================================
                SizedBox(height: sp(12)),
                Obx(() => forgerPassController.isLoading.isTrue
                    ? LoadingFlipping.circle(
                        borderColor: clickIconColor,
                        borderSize: 3.0,
                        size: sp(40),
                        //  backgroundColor: Color(0xff112A04),
                        duration: Duration(milliseconds: 500),
                      )
                    : Container(
                        width: w(60),
                        child:
                            // our local Elvated Button (text , color , onpress:(){})
                            ElevatedButton(
                          child: Text('change_password'.tr,
                              style: TextStyle(fontSize: sp(12))),
                          onPressed: () async {
                            ///=====================
                            /// OTP Check ===================
                            // =======================

                            final form = _formKey.currentState;
                            if (form!.validate()) {
                              form.save();

                              forgerPassController.updatePassword();
                            }
                          },
                        ),
                      )),
                SizedBox(height: sp(5)),

                ///=======================================================================
                ///==================== Go to Signup ========================================
                ///=======================================================================
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TextButton(
                      onPressed: () {
                        Get.to(() => HomePage());
                      },
                      child: Text('Go_To_home_page'.tr,
                          style: TextStyle(fontSize: sp(10)))),
                ]),

                Image.asset(
                  "assets/images/hasr_logo.png",
                  width: w(50),
                  height: h(30),
                  fit: BoxFit.cover,
                ),

                SizedBox(height: h(1)),

                SizedBox(height: sp(10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
