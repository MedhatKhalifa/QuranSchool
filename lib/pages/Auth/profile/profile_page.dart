import 'package:quranschool/pages/Auth/controller/register_controller.dart';
import 'package:quranschool/pages/Auth/login/change_password.dart';
import 'package:quranschool/pages/Auth/login/forget_password.dart';
import 'package:quranschool/pages/Auth/login/login_page.dart';
import 'package:quranschool/pages/Auth/profile/aboutUs.dart';
import 'package:quranschool/pages/Auth/profile/contactUs.dart';
import 'package:quranschool/pages/Auth/profile/profile_register.dart';
import 'package:quranschool/pages/chat/controller/chat_controller.dart';
import 'package:quranschool/pages/chat/chat_details.dart';
import 'package:quranschool/pages/chat/people_list.dart';

import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:quranschool/pages/sessions/controller/session_control.dart';
import 'package:quranschool/pages/sessions/nextSession.dart';
import 'package:quranschool/pages/sessions/st.dart';
import 'package:quranschool/pages/sessions/videoConference.dart';
import 'package:quranschool/pages/student/subscription/control/subscription_controller.dart';
import 'package:quranschool/pages/sessions/sessionsShow.dart';
import 'package:quranschool/pages/teacher/availability_input.dart';
import 'package:quranschool/pages/teacher/model/availability_model.dart';

import 'package:quranschool/translation/translation_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/size_config.dart';
import '../../../core/theme.dart';
import '../../common_widget/error_snackbar.dart';
import '../../common_widget/mybottom_bar/bottom_bar_controller.dart';

import '../Model/users.dart';
import '../controller/currentUser_controller.dart';
import '../controller/sharedpref_function.dart';

class UserProfilePage extends StatefulWidget {
  bool showbottombar;
  UserProfilePage({Key? key, required this.showbottombar}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

final CurrentUserController currentUserController =
    Get.put(CurrentUserController());
final SubscribitionController subscribitionController =
    Get.put(SubscribitionController());
final MySesionController mySesionController = Get.put(MySesionController());
final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());
final ChatController chatController = Get.put(ChatController());
final RegisterController registerController = Get.put(RegisterController());
String _size = "";
final _formKey = GlobalKey<FormState>();

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simplAppbar(false),
      body: ListView(
        children: [
          SizedBox(
            height: h(2),
          ),
          Obx(() => Visibility(
                visible: currentUserController.currentUser.value.id != -1,
                child: Center(
                    child: Text(
                        'Hi  ${currentUserController.currentUser.value.fullName}',
                        style: TextStyle(
                            color: Colors.black38, fontSize: sp(17)))),
              )),

          ///
          ///
          // UserName
          ///
          ///
          Obx(() => currentUserController.currentUser.value.id != -1
              ? ListTile(
                  leading: Icon(
                    Icons.person,
                    color: clickIconColor,
                  ),
                  title: Text(currentUserController.currentUser.value.username),
                  onTap: () async {
                    // Get.to(ProfileRegisterPage());

                    var _user = currentUserController.currentUser.value;
                    registerController.registeruserdata.value = _user;

                    //registerController.registeruserdata.value.enabledit = true;
                    print(registerController.registeruserdata);
                    // Get.to(ProfileRegisterPage());

                    // mySnackbar('Failed'.tr, 'please_Loging_First'.tr, 'Error');
                  })
              : ListTile(
                  leading: Icon(
                    Icons.login,
                    color: clickIconColor,
                  ),
                  title: Text('Login/Register'),
                  onTap: () async {
                    Get.to(LoginPage());
                  })),
          // ListTile(
          //     leading: Icon(
          //       Icons.video_call,
          //       color: clickIconColor,
          //     ),
          //     title: Text('test Video Call'),
          //     onTap: () async {
          //       mySesionController.getToken();

          //       Get.to(MyVideoCall());
          //     }),

          ///
          ///
          // Villa Size
          ///
          ///
          // Obx(() => Visibility(
          //       visible: currentUserController.currentUser.value.id != -1,
          //       child: ListTile(
          //           trailing: Text(
          //             'edit'.tr,
          //             style: TextStyle(color: textbuttonColor),
          //           ),
          //           leading: FaIcon(FontAwesomeIcons.houseUser),
          //           title: Text('myarea_size'.tr +
          //               ' ${currentUserController.currentUser.value.id.toString()} m2'),
          //           onTap: () async {
          //             Get.defaultDialog(
          //                 backgroundColor: Colors.white.withOpacity(0.9),
          //                 title: '',
          //                 content: Form(
          //                   key: _formKey,
          //                   child: Column(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //                       TextFormField(
          //                         validator: (value) {
          //                           if (value == null ||
          //                               value.isEmpty ||
          //                               int.parse(value) < 20) {
          //                             return 'less_size_100'.tr;
          //                           }
          //                           return null;
          //                         },
          //                         initialValue: currentUserController
          //                             .currentUser.value.id
          //                             .toString(),
          //                         onChanged: ((value) {
          //                           setState(() {
          //                             _size = value;
          //                           });
          //                         }),
          //                         keyboardType: TextInputType.number,
          //                         maxLines: 1,
          //                         decoration: InputDecoration(
          //                             labelText: 'enter_size'.tr + ' (m2)',
          //                             hintMaxLines: 1,
          //                             border: OutlineInputBorder(
          //                                 borderSide: BorderSide(
          //                                     color: Colors.green,
          //                                     width: 4.0))),
          //                       ),
          //                       SizedBox(
          //                         height: h(2),
          //                       ),
          //                       ElevatedButton(
          //                         onPressed: () {
          //                           final form = _formKey.currentState;
          //                           if (form!.validate()) {
          //                             form.save();

          //                             if (_size != "") {
          //                               currentUserController.currentUser.value
          //                                   .id = int.parse(_size);

          //                               currentUserController.updateUserData(
          //                                   currentUserController
          //                                       .currentUser.value);
          //                               Navigator.of(context).pop();
          //                               // Get.to(() => const UserProfilePage());

          //                               setState(() {
          //                                 currentUserController.currentUser
          //                                     .value.id = int.parse(_size);
          //                               });

          //                               //Get.back();
          //                             }
          //                           }
          //                         },
          //                         child: Text('update_size'.tr),
          //                       )
          //                     ],
          //                   ),
          //                 ),
          //                 radius: 10.0);
          //           }),
          //     )),
          Divider(),

          ///
          ///
          // Change Password
          ///
          ///
          Obx(() => Visibility(
                visible: currentUserController.currentUser.value.id != -1,
                child: ListTile(
                    leading: Icon(
                      Icons.lock_open,
                      color: clickIconColor,
                    ),
                    title: Text('change_password'.tr),
                    onTap: () async {
                      Get.to(ChangePassword());
                    }),
              )),

          ///
          ///
          // My Meetings
          ///
          ///
          Obx(() => Visibility(
                visible: currentUserController.currentUser.value.id != -1,
                child: ListTile(
                    leading: Icon(Icons.calendar_month),
                    title: Text('My Appointments'.tr),
                    onTap: () async {
                      subscribitionController.getSessionsbyteaherID(
                          currentUserController.currentUser.value.id,
                          currentUserController.currentUser.value.userType);
                      Get.to(SessionsShow());
                    }),
              )),

          ///
          ///
          // My Avaiability
          ///
          ///
          Obx(() => Visibility(
                visible: currentUserController.currentUser.value.id != -1,
                child: ListTile(
                    leading: Icon(Icons.add_box_rounded),
                    title: Text('My Avaialiability'.tr),
                    onTap: () async {
                      // subscribitionController.getSessionsbyteaherID(
                      //     currentUserController.currentUser.value.id,
                      //     currentUserController.currentUser.value.userType);

                      subscribitionController.getAvaiTimeOnly(
                          currentUserController.currentUser.value.id);
                       Get.to(AvailabilityInputPage());
                    }),
              )),

          ///
          ///
          // My Meetings
          ///
          ///
          Obx(() => Visibility(
                visible: currentUserController.currentUser.value.id != -1,
                child: ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text('My Next Session'.tr),
                    onTap: () async {
                      mySesionController.getFirstSessionAfterNow();

                      Get.to(NextSession());
                    }),
              )),
          // Obx(() => Visibility(
          //       visible: currentUserController.currentUser.value.id != -1,
          //       child: ListTile(
          //           leading: Icon(Icons.message),
          //           title: Text('Chat'.tr),
          //           onTap: () async {
          //             chatController.getchatList();
          //             Get.to(PeopleList());
          //             // Get.to(
          //             //     ChatDetail(friendName: 'Medhat', friendUid: 'user1'));
          //           }),
          //     )),

          ///
          ///
          // Forget Password
          ///
          ///
          // Obx(() => Visibility(
          //       visible: currentUserController.currentUser.value.id != -1,
          //       child: ListTile(
          //           leading: Icon(
          //             Icons.history,
          //             color: clickIconColor,
          //           ),
          //           title: Text('order_histroy'.tr),
          //           onTap: () async {
          //             Get.to(() => OrderHistroyPage());
          //           }),
          //     )),

          ListTile(
              leading: FaIcon(FontAwesomeIcons.quran),
              title: Text('aboutus'.tr),
              onTap: () async {
                Get.to(() => AboutUsPage());
              }),

          ListTile(
              leading: FaIcon(FontAwesomeIcons.headset),
              title: Text('contactus'.tr),
              onTap: () async {
                Get.to(() => ContactUsPage());
              }),

          ///
          ///
          // Language
          ///
          ///
          ListTile(
              leading: Icon(
                Icons.language,
                color: clickIconColor,
              ),
              title: Text('change_language'.tr),
              onTap: () async {
                Get.to(TrnaslationPage());
              }),

          ///
          ///
          // Logout
          ///
          ///
          Obx(() => currentUserController.currentUser.value.id != -1
              ? ListTile(
                  title: Text('logout'.tr),
                  leading: Icon(Icons.exit_to_app),
                  onTap: () async {
                    await removeUserData('user');
                    currentUserController.currentUser.value = User();

                    myBottomBarCtrl.selectedIndBottomBar.value = 0;

                    Get.to(HomePage());
                  })
              : Text('')),
        ],
      ),
      bottomNavigationBar:
          widget.showbottombar ? mybottomBarWidget() : Text(''),
    );
  }
}
