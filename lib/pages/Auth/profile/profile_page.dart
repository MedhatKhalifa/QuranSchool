import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quranschool/core/db_links/db_links.dart';
import 'package:quranschool/pages/Auth/controller/register_controller.dart';
import 'package:quranschool/pages/Auth/login/change_password.dart';
import 'package:quranschool/pages/Auth/login/forget_password.dart';
import 'package:quranschool/pages/Auth/login/login_page.dart';
import 'package:quranschool/pages/Auth/profile/aboutUs.dart';
import 'package:quranschool/pages/Auth/profile/contactUs.dart';
import 'package:quranschool/pages/Auth/profile/profile_register.dart';
import 'package:quranschool/pages/Auth/profile/questions.dart';
import 'package:quranschool/pages/chat/controller/chat_controller.dart';
import 'package:quranschool/pages/chat/chat_details.dart';
import 'package:quranschool/pages/chat/people_list.dart';
import 'package:flutter/services.dart';

import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:quranschool/pages/notification/notificationShow.dart';
import 'package:quranschool/pages/notification/notification_controller.dart';
import 'package:quranschool/pages/search/price_list_show.dart';
import 'package:quranschool/pages/sessions/controller/session_control.dart';
import 'package:quranschool/pages/sessions/nextSession.dart';
import 'package:quranschool/pages/sessions/st.dart';
import 'package:quranschool/pages/sessions/videoConference.dart';
import 'package:quranschool/pages/student/subscription/control/subscription_controller.dart';
import 'package:quranschool/pages/sessions/sessionsShow.dart';
import 'package:quranschool/pages/subscribtionAll/showSubscriptionAll.dart';
import 'package:quranschool/pages/teacher/availability_input.dart';
import 'package:quranschool/pages/teacher/model/availability_model.dart';
import 'package:quranschool/pages/teacher/mystudent/showmyStudent.dart';

import 'package:quranschool/translation/translation_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

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
final NotificationController notificationController =
    Get.put(NotificationController());
String _size = "";
final _formKey = GlobalKey<FormState>();

void _showWarningDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 10),
            Text(
              'Warning',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to remove your account?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'This action cannot be undone. All your data will be permanently deleted.',
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // background (button) color
            ),
            child: Text('Remove Account'),
            onPressed: () {
              // Add your account removal logic here
              currentUserController.removeUserAccount();
            },
          ),
        ],
      );
    },
  );
}

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
                        'Hi'.tr +
                            ' ${currentUserController.currentUser.value.fullName}',
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
                    currentUserController.currentUser.value =
                        await loadUserData('user');
                    var _user = currentUserController.currentUser.value;
                    currentUserController.tempUser.value = _user;
                    currentUserController.tempUser.value.updateOld = true;
                    currentUserController.tempUser.value.enabledit = true;
                    //  currentUserController.currentUser.value.updateOld = true;
                    // currentUserController.tempUser.value = _user;
                    // currentUserController
                    //     .tempUser(currentUserController.currentUser.value);
                    //currentUserController.currentUser;
                    print(currentUserController.tempUser.value.fullName);
                    print(currentUserController.currentUser.value.fullName);
                    Get.to(ProfileRegisterPage());

                    // mySnackbar('Failed'.tr, 'please_Loging_First'.tr, 'Error');
                  })
              : ListTile(
                  leading: Icon(
                    Icons.login,
                    color: clickIconColor,
                  ),
                  title: Text('Login_Register'.tr),
                  onTap: () async {
                    Get.to(LoginPage());
                  })),

          Obx(() => Visibility(
                visible: currentUserController.currentUser.value.id != -1,
                child: ListTile(
                    leading: Icon(Icons.shopify),
                    title: Text('subscription_package'.tr),
                    onTap: () async {
                      chatController.isLoadingall.value = true;
                      chatController.getallSubList();
                      Get.to(ShowSubscriptionAll());
                    }),
              )),

          Obx(() => Visibility(
                visible: currentUserController.currentUser.value.id != -1,
                child: ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('notification'.tr),
                    onTap: () async {
                      notificationController.readNotifications();
                      Get.to(NotificationShow());
                    }),
              )),

          Divider(),

          ///
          ///
          // My Meetings
          ///
          ///
          ///
          Obx(() => Visibility(
                visible: currentUserController.currentUser.value.userType !=
                    "teacher",
                child: ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text('package_price'.tr),
                    onTap: () async {
                      subscribitionController.getSubscribitonList();
                      Get.to(() => PriceShow());
                    }),
              )),
          Obx(() => Visibility(
                visible: currentUserController.currentUser.value.id != -1,
                child: ListTile(
                    leading: Icon(Icons.calendar_month),
                    title: Text('my_session'.tr),
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
                visible: currentUserController.currentUser.value.id != -1 &&
                    currentUserController.currentUser.value.userType ==
                        "teacher",
                child: ListTile(
                    leading: Icon(Icons.edit_calendar),
                    title: Text('myAvailability'.tr),
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
          // Chat
          ///
          ///

          Obx(() => Visibility(
                visible: currentUserController.currentUser.value.id != -1,
                child: ListTile(
                    leading: Icon(Icons.people),
                    title: currentUserController.currentUser.value.userType ==
                            "teacher"
                        ? Text('MyStudents'.tr)
                        : Text('MyTeachers'.tr),
                    onTap: () async {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUserController.currentUser.value.id
                              .toString())
                          .delete();

                      currentUserController.currentUser.value.userType ==
                              "teacher"
                          ? myBottomBarCtrl.selectedIndBottomBar.value = 3
                          : myBottomBarCtrl.selectedIndBottomBar.value = 4;
                      chatController.isLoading.value = true;
                      chatController.getchatList();
                      Get.to(PeopleList());
                      // Get.to(
                      //     ChatDetail(friendName: 'Medhat', friendUid: 'user1'));
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
                    title: Text('my_next_session'.tr),
                    onTap: () async {
                      mySesionController.getFirstSessionAfterNow();
                      currentUserController.currentUser.value.userType ==
                              "teacher"
                          ? myBottomBarCtrl.selectedIndBottomBar.value = 2
                          : myBottomBarCtrl.selectedIndBottomBar.value = 3;
                      Get.to(NextSession());
                    }),
              )),

          ///
          ///
          // My students
          ///
          ///
          // Obx(() => Visibility(
          //       visible: currentUserController.currentUser.value.id != -1 &&
          //           currentUserController.currentUser.value.userType ==
          //               "teacher",
          //       child: ListTile(
          //           leading: Icon(Icons.people),
          //           title: Text('my_students'.tr),
          //           onTap: () async {
          //             chatController.getchatList();
          //             myBottomBarCtrl.selectedIndBottomBar.value = 1;
          //             Get.to(ShowMyStudent());
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
              leading: Icon(Icons.help_outline),
              title: Text('Popular_Questions'.tr),
              onTap: () async {
                currentUserController.readQuestions();
                Get.to(() => QuestionShow());
              }),

          ListTile(
              leading: FaIcon(FontAwesomeIcons.headset),
              title: Text('contactus'.tr),
              onTap: () async {
                Get.to(() => ContactUsPage());
              }),

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
                    title: Text('CHANGE_PASSWORD'.tr),
                    onTap: () async {
                      Get.to(ChangePassword());
                    }),
              )),

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
          ListTile(
              leading: Icon(Icons.share),
              title: Text('share_app'.tr),
              onTap: () async {
                // Get the app store link based on the platform
                //final packageInfo = await PackageInfo.fromPlatform();

                final String message = '! Madraset Alquran مدرسة القران!';

                String sharingLink = '';
                try {
                  if (Platform.isAndroid) {
                    sharingLink = playStoreLink;
                  } else if (Platform.isIOS) {
                    sharingLink = appStoreLink;
                  } else {
                    // Handle other platforms (optional)
                    sharingLink = 'App not available on your platform yet.';
                  }
                } on PlatformException catch (e) {
                  print('Error determining platform: $e');
                  // Handle platform check exception (optional)
                }

                Share.share(
                  '$message\n$sharingLink',
                  subject: 'Share the App!',
                );

                // if (result.status == ShareResultStatus.success) {
                //   print('Shared successfully');
                // } else if (result.status == ShareResultStatus.cancelled) {
                //   print('Share was cancelled by the user.');
                // } else {
                //   print('An error occurred: ${result.error}');
                // }
              }),
          ListTile(
              leading: Icon(
                Icons.info,
                color: clickIconColor,
              ),
              title: Text('aboutus'.tr),
              onTap: () {
                Get.to(AboutUsPage());
              }),

          ///
          ///
          ///Remove Avvount
          ///
          // Obx(() => Visibility(
          //       visible: currentUserController.currentUser.value.id != -1,
          //       child: ElevatedButton(
          //         onPressed: () => _showWarningDialog(context),
          //         style: ElevatedButton.styleFrom(
          //           foregroundColor: Colors.white,
          //           backgroundColor: Colors.red, // foreground (text) color
          //         ),
          //         child: Text('Remove Account'),
          //       ),
          //     )),

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
      bottomNavigationBar: widget.showbottombar ? MybottomBar() : Text(''),
    );
  }
}
