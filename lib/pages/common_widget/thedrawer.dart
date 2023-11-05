// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import 'package:get/get.dart';
// import 'package:quranschool/pages/common_widget/local_colors.dart';
// import 'package:quranschool/pages/Auth/Model/users.dart';
// import 'package:quranschool/pages/Auth/login/change_password.dart';
// import 'package:quranschool/pages/Auth/register/phone_handler.dart';
// import 'package:quranschool/pages/Auth/register/ploicy.dart';
// import 'package:quranschool/pages/MyAccount/controller/account_controller.dart';
// import 'package:quranschool/pages/MyAccount/myaccount_page.dart';
// import 'package:quranschool/pages/My_favorite/favorite_page.dart';

// import 'package:quranschool/pages/company/company_page.dart';
// import 'package:quranschool/pages/company_offers/offers_home.dart';
// import 'package:quranschool/pages/company_offers/show_ads_ite,.dart';
// import 'package:quranschool/pages/home_page/view/home_page.dart';
// import 'package:quranschool/pages/pay/pay_controller/payment_check.dart';
// import 'package:quranschool/pages/pay/pay_pal.dart';
// import 'package:quranschool/pages/pay/pay_selection.dart';
// import 'package:quranschool/pages/pay/paytest2.dart';
// import 'package:quranschool/pages/profile/Model/global_profile_Model.dart';

// import 'package:quranschool/pages/profile/controller/agent_club/playerlist_controller.dart';
// import 'package:quranschool/pages/Auth/controller/sharedpref_function.dart';
// import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
// import 'package:quranschool/pages/Auth/login/login_page.dart';
// import 'package:quranschool/pages/Auth/register/register_page.dart';
// import 'package:quranschool/pages/profile/controller/company/ads_controller.dart';

// import 'package:quranschool/pages/profile/controller/current_profile_Controller.dart';
// import 'package:quranschool/pages/common_widget/error_snackbar.dart';
// import 'package:quranschool/pages/profile/controller/selectedPlayer_controller.dart';
// import 'package:quranschool/pages/profile/form_mainPage.dart';
// import 'package:quranschool/pages/profile/general_profile_main.dart';
// import 'package:quranschool/pages/search/search_page.dart';
// import 'package:quranschool/pages/test2.dart';
// import 'package:quranschool/pages/test3.dart';
// import 'package:quranschool/pages/test_page.dart';
// import 'package:quranschool/pages/unlock_profiles/unlock_page.dart';
// import 'package:quranschool/test4.dart';
// import 'package:quranschool/translation/translation_page.dart';

// class Thedrawer extends StatefulWidget {
//   @override
//   _ThedrawerState createState() => _ThedrawerState();
// }

// class _ThedrawerState extends State<Thedrawer> {
//   //Product _filterProduct = Product();
//   final CurrentUserController userctrl = Get.put(CurrentUserController());
//   final PlayerListController playerlistctrl = Get.put(PlayerListController());
//   final PlayerController playerController = Get.put(PlayerController());
//   final AdsController adsController = Get.put(AdsController());
//   final PaymentCheckController paymentCheckController =
//       Get.put(PaymentCheckController());
//   final MyAccountController myAccountController =
//       Get.put(MyAccountController());
//   final CurrentProfileController currentProfileController =
//       Get.put(CurrentProfileController());
//   String usersss = 'A';
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         // Important: Remove any padding from the ListView.
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             child: Center(
//               child: Obx(() => userctrl.currentUser.value.id != -1
//                   ? Column(children: [
//                       IconButton(
//                           icon: FaIcon(
//                             FontAwesomeIcons.userCog,
//                             color: Colors.orange,
//                           ),
//                           onPressed: () async {
//                             if (userctrl.currentUser.value.id == -1) {
//                               mySnackbar(
//                                   'Fail', 'please_Loging_First', 'Error');
//                               Get.to(() => PloicyPage());
//                             } else {
//                               // myAccountController.accountdetails(false); uncomment for apple
//                               // Get.to(() => MyAccountPage()); uncomment for apple
//                             }
//                           }),
//                       GestureDetector(
//                         onTap: () => Navigator.pushNamed(context, '/profile'),
//                         child: Text(
//                             "hi".tr +
//                                 " ${userctrl.currentUser.value.fullName} ",
//                             style:
//                                 TextStyle(color: Colors.white, fontSize: 20)),
//                       ),
//                     ])
//                   : TextButton(
//                       onPressed: () {
//                         Get.to(() => LoginPage());
//                       },
//                       child: Text(
//                         "sign_in".tr,
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                     )),
//             ),
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//           ListTile(
//             leading: FaIcon(
//               FontAwesomeIcons.houseUser,
//               color: lgreen,
//             ),
//             title: Text('Home'.tr),
//             onTap: () {
//               // Update the state of the app
//               // ...
//               // Then close the drawer
//               Get.to(() => HomePage());
//             },
//           ),
//           ListTile(
//               leading: FaIcon(
//                 FontAwesomeIcons.searchengin,
//                 color: lgreen,
//               ),
//               title: Text('search'.tr),
//               onTap: () async {
//                 Get.to(() => SearchPage());
//               }),
//           Visibility(
//             visible: currentUserController.currentUser.value.id != -1,
//             child: ListTile(
//               leading: Icon(
//                 Icons.manage_accounts,
//                 color: lgreen,
//               ),
//               //===================================
//               // My profile
//               //===================================
//               title: Text('my_profile'.tr),
//               onTap: () async {
//                 paymentCheckController.validateandgetaccount();
//                 currentProfileController.profile.value = GlobalProfileModel();
//                 currentProfileController.profile.value.initalindex = 0;
//                 if (userctrl.currentUser.value.id == -1) {
//                   mySnackbar('Failed'.tr, 'login_first'.tr, 'Error');
//                   Get.to(() => PloicyPage());
//                 } else {
//                   if (userctrl.currentUser.value.accountType == "ads_company") {
//                     Get.to(() => () => CompanyPage());
//                   } else {
//                     currentProfileController.profile.value.accountType =
//                         userctrl.currentUser.value.accountType;

//                     if (currentProfileController.profile.value.accountType ==
//                         'Player') {
//                       currentProfileController.profile.value.playerId =
//                           userctrl.currentUser.value.accountId;
//                     } else if (currentProfileController
//                             .profile.value.accountType ==
//                         'Agent') {
//                       currentProfileController.profile.value.agentId =
//                           userctrl.currentUser.value.accountId;
//                     } else if (currentProfileController
//                             .profile.value.accountType ==
//                         'Club') {
//                       currentProfileController.profile.value.clubId =
//                           userctrl.currentUser.value.accountId;
//                     } else if (currentProfileController
//                             .profile.value.accountType ==
//                         'Company') {
//                       currentProfileController.enabledit.value = true;
//                       currentProfileController.profile.value.companyId =
//                           userctrl.currentUser.value.accountId;
//                       adsController.ads.value.companyId =
//                           userctrl.currentUser.value.accountId;
//                       adsController.enabledit.value = true;
//                     }

//                     currentProfileController.profile.value.accountId =
//                         userctrl.currentUser.value.accountId;
//                     currentProfileController.profile.value.userIdId =
//                         userctrl.currentUser.value.id;

//                     currentProfileController.enabledit.value = true;

//                     currentProfileController.getProfileByAccountid(
//                         currentProfileController.profile.value);

//                     currentProfileController.profile.value.imagechanged = false;

//                     Get.off(MainProfilePage());
//                     //Navigator.of(context).pop();
//                   }
//                 }
//               },
//             ),
//           ),
//           ListTile(
//               leading: FaIcon(
//                 FontAwesomeIcons.award,
//                 color: lgreen,
//               ),
//               title: Text('offers'.tr),
//               onTap: () async {
//                 Get.to(() => OffersPage());
//               }),
//           ListTile(
//               leading: FaIcon(
//                 FontAwesomeIcons.rProject,
//                 color: lgreen,
//               ),
//               title: Text('Test pay apple'),
//               onTap: () async {
//                 Get.to(() => PayMaterialApp());
//               }),
//           // ListTile(
//           //     leading: FaIcon(
//           //       FontAwesomeIcons.commentDollar,
//           //       color: lgreen,
//           //     ),
//           //     title: Text('test_pay'.tr),
//           //     onTap: () async {
//           //       Get.to(VimeoExample());
//           //     }),
//           // ListTile(
//           //     leading: FaIcon(
//           //       FontAwesomeIcons.commentDollar,
//           //       color: lgreen,
//           //     ),
//           //     title: Text('upgrade_account'.tr),
//           //     onTap: () async {
//           //       if (userctrl.currentUser.value.id == -1) {
//           //         mySnackbar('Failed'.tr, 'login_first'.tr, 'Error');
//           //         Get.to(() => PloicyPage());
//           //       } else {
//           //         Get.to(() => PaySelection());
//           //       }
//           //     }),
//           Obx(() => Visibility(
//                 visible: currentUserController.currentUser.value.id != -1,
//                 child: ListTile(
//                     leading: FaIcon(
//                       FontAwesomeIcons.heart,
//                       color: lgreen,
//                     ),
//                     title: Text('favorite'.tr),
//                     onTap: () async {
//                       if (userctrl.currentUser.value.id == -1) {
//                         mySnackbar(
//                             'Failed'.tr, 'please_Loging_First'.tr, 'Error');
//                         Get.to(() => PloicyPage());
//                       } else {
//                         Get.to(() => FavPage());
//                       }
//                     }),
//               )),

//           // Visibility(
//           //   visible: currentUserController.currentUser.value.id != -1,
//           //   child: ListTile(
//           //       leading: FaIcon(
//           //         FontAwesomeIcons.lockOpen,
//           //         color: lgreen,
//           //       ),
//           //       title: Text('unlock_profiles'.tr),
//           //       onTap: () async {
//           //         if (userctrl.currentUser.value.id == -1) {
//           //           mySnackbar('Failed'.tr, 'please_Loging_First'.tr, 'Error');
//           //           Get.to(() => PloicyPage());
//           //         } else {
//           //           Get.to(() => UnlockerPage());
//           //         }
//           //       }),
//           // ),
//           ListTile(
//               leading: Icon(
//                 Icons.language,
//                 color: lgreen,
//               ),
//               title: Text('language'.tr),
//               onTap: () async {
//                 Get.to(() => TrnaslationPage());
//               }),
//           Obx(
//             () => userctrl.currentUser.value.id != -1
//                 ? ListTile(
//                     title: Text('logout'.tr),
//                     leading: Icon(Icons.exit_to_app),
//                     onTap: () async {
//                       await removeUserData('user');
//                       userctrl.currentUser.value = User();
//                     })
//                 : Text(''),
//           ),
//         ],
//       ),
//     );
//   }
// }
