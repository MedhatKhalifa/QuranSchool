import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quranschool/core/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/pages/Auth/controller/register_controller.dart';
import 'package:quranschool/pages/Auth/controller/sharedpref_function.dart';
import 'package:quranschool/pages/Auth/profile/profile_register.dart';
import 'package:quranschool/pages/Auth/profile/termsandcondition.dart';

import 'package:quranschool/pages/common_widget/local_colors.dart';
import 'package:quranschool/pages/Auth/Model/users.dart' as myuser;

import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/Auth/controller/login_controller.dart';
import 'package:quranschool/pages/Auth/login/forget_password.dart';
import 'package:quranschool/pages/Auth/register/ploicy.dart';
import 'package:quranschool/pages/Auth/register/register_page.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController loginController = Get.put(LoginController());

  // Google Sign in
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        return await _auth.signInWithCredential(credential);
      }
    } catch (error) {
      Get.snackbar('1', "$error");
      print("Error signing in with Google: $error");
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool _isobscureText = true;
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'SA';

  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

  String? mytoken;

  getToken() async {
    mytoken = await FirebaseMessaging.instance.getToken();
    setState(() {
      currentUserController.currentUser.value.accountToken = mytoken!;
      mytoken = mytoken;
    });
    print('==================================');
    print(currentUserController.currentUser.value.accountToken);
  }

  late myuser.User userProfile;
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
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              "assets/images/login_background.png"), // Update with your image path
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        ///=======================================================================
        ///==================== Body ========================================
        ///=======================================================================
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: sp(20), right: sp(20), left: sp(20)),
            child: Form(
              key: _formKey,
              child: Column(
                ///=======================================================================
                ///==================== Logo  ========================================
                ///=======================================================================
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo/logo.png",
                    width: w(45),
                    height: h(25),
                    fit: BoxFit.fitHeight,
                    //color: Colors.red,
                  ),

                  SizedBox(height: sp(5)),

                  ///=======================================================================
                  ///==================== Phone Number ========================================
                  ///=======================================================================
                  ///
                  // IntlPhoneField(
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     // focusColor: Colors.red,
                  //     labelText: 'Phone_Number'.tr,
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(25.0),
                  //       //borderSide: BorderSide(),
                  //     ),
                  //     fillColor: Colors.white,
                  //   ),
                  //   initialCountryCode: 'EG',
                  //   onChanged: (phone) {
                  //     loginController.phone.value =
                  //         phone.completeNumber.toString();
                  //     // print(phone.completeNumber);
                  //   },
                  // ),

                  ///=======================================================================
                  ///==================== User Name ========================================
                  ///=======================================================================
                  // Name
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 1) {
                        return 'user_Name'.tr;
                      }
                      return null;
                    },
                    onSaved: (val) => loginController.username.value = val!,

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
                      hintText: 'user_Name'.tr,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.only(
                          left: 14.0, right: 14.0, bottom: sp(16), top: sp(16)),
                      focusedBorder: OutlineInputBorder(
                        //  borderSide: BorderSide(color: lgreen),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),

                    /// end of decoration
                  ),
                  SizedBox(height: sp(10)),

                  ///=======================================================================
                  ///==================== Password ========================================
                  ///=======================================================================

                  /// Password
                  TextFormField(
                    style: TextStyle(
                      fontSize: sp(12),
                    ),
                    onSaved: (val) => loginController.password.value = val!,

                    validator: (val) =>
                        val!.length < 2 ? 'Password_too_short'.tr : null,
                    obscureText: _isobscureText, // to show stars for password
                    autofocus: false,

                    decoration: InputDecoration(
                      //border: InputBorder.none,
                      hintText: 'Password'.tr,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.lock,
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
                          )),
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, right: 14.0, bottom: 20.0, top: 20.0),
                      focusedBorder: OutlineInputBorder(
                        //borderSide: BorderSide(color: lgreen),
                        // borderRadius: BorderRadius.circular(10.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  SizedBox(height: sp(15)),

                  ///=======================================================================
                  ///==================== Login button ========================================
                  ///=======================================================================
                  Obx(() => loginController.isLoading.isTrue
                      ? LoadingFlipping.circle(
                          borderColor: clickIconColor,
                          borderSize: 3.0,
                          size: sp(20),
                          // backgroundColor: Color(0xff112A04),
                          duration: Duration(milliseconds: 500),
                        )
                      : Container(
                          width: w(80),
                          child:
                              // our local Elvated Button (text , color , onpress:(){})
                              ElevatedButton(
                            child: Text('login'.tr,
                                style: TextStyle(fontSize: sp(17))),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFFD8C00))),
                            onPressed: () async {
                              //Get.to(()=>MainProfilePage());

                              final form = _formKey.currentState;
                              if (form!.validate()) {
                                form.save();
                                await loginController.checkuser();
                              }
                            },
                          ),
                        )),

                  ///=======================================================================
                  ///==================== Forget Password ========================================
                  ///=======================================================================

                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    TextButton(
                        onPressed: () {
                          Get.to(() => ForgetPassword());
                        },
                        child: Text('forget_password'.tr,
                            style: TextStyle(
                                fontSize: sp(10), color: Color(0xFFFD8C00)))),
                  ]),

                  ///=======================================================================
                  ///==================== login with social ========================================
                  ///=======================================================================
                  SizedBox(height: sp(8)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('or_login_with'.tr,
                          style:
                              TextStyle(fontSize: sp(10), color: Colors.white)),
                      IconButton(
                          icon: Image.asset('assets/icons/gmail.png'),
                          onPressed: () async {
                            UserCredential? userCredential =
                                await signInWithGoogle();
                            Get.snackbar('1', 'Gmail account retrive done');
                            if (userCredential != null &&
                                userCredential.user!.email != null) {
                              await loginController
                                  .chdeckGmailUsername(userCredential);
                            } else {
                              Get.snackbar('1', 'Gmail account retrive Error');
                            }
                          }),
                    ],
                  ),
                  SizedBox(height: sp(15)),

                  ///=======================================================================
                  ///==================== Go to Signup ========================================
                  ///=======================================================================
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    TextButton(
                        onPressed: () {
                          Get.to(() => RegisterPage());
                        },
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              text: "no_account".tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: sp(8),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'register_now'.tr,
                                  style: TextStyle(
                                    fontSize: sp(8),
                                    color: Color(0xFFFD8C00),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),

                    // Text('No_account_register'.tr,
                    //     style: TextStyle(fontSize: sp(10)))
                  ]),
                  SizedBox(height: sp(30)),

                  Text("sing_agree".tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: sp(7),
                      )),

                  TextButton(
                      onPressed: () {
                        Get.to(() => TermsCondition());
                      },
                      child: Text('terms'.tr,
                          style: TextStyle(
                              fontSize: sp(8), color: Color(0xFFFD8C00)))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
