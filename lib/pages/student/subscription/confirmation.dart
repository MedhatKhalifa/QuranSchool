import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/bottom_bar_controller.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:quranschool/pages/student/subscription/control/subscription_controller.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({super.key});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  final SubscribitionController subscribitionController =
      Get.put(SubscribitionController());
  final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        myBottomBarCtrl.selectedIndBottomBar.value = 0;

        Get.to(HomePage());
        // Show a confirmation dialog before going back in the page.
        // bool shouldGoBack = await showDialog(
        //   context: context,
        //   builder: (context) {
        //     return AlertDialog(
        //       title: Text('Do you want to go back?'),
        //       content: Text('All unsaved changes will be lost.'),
        //       actions: [
        //         TextButton(
        //           onPressed: () => Navigator.pop(context, false),
        //           child: Text('No'),
        //         ),
        //         TextButton(
        //           onPressed: () => Navigator.pop(context, true),
        //           child: Text('Yes'),
        //         ),
        //       ],
        //     );
        //   },
        // );

        // Return the result of the confirmation dialog.
        // return shouldGoBack;
        return false;
      },
      child: Scaffold(
          appBar: simplAppbar(false, "Confirmation"),
          body: Obx(() => subscribitionController.isLoading.isTrue
              ? Center(
                  child: LoadingBouncingGrid.circle(
                    borderColor: mybrowonColor,
                    backgroundColor: Colors.white,
                    // borderSize: 3.0,
                    // size: sp(20),
                    // backgroundColor: Color(0xff112A04),
                    //  duration: Duration(milliseconds: 500),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Tthanks_registeration".tr,
                          style:
                              TextStyle(color: Colors.green, fontSize: sp(14)),
                        ),
                        Text("admin_will_call".tr),
                        Text(""),
                        Text("Selected_teacher".tr +
                            subscribitionController
                                .selectedTeacher.value.user!.fullName),
                        // Text(" userName " +
                        //     subscribitionController
                        //         .selectedTeacher.value.user!.username),
                        Text(""),
                        Text("Selected_package".tr +
                            subscribitionController
                                .selectedPayement.value.sessionCount!
                                .toString()),
                        Text("session_cost".tr +
                            subscribitionController
                                .selectedPayement.value.price! +
                            "EGP".tr),
                        IconButton(
                            onPressed: () {
                              myBottomBarCtrl.selectedIndBottomBar.value = 0;

                              Get.offAll(HomePage());
                            },
                            icon: Icon(Icons.home))
                      ]),
                ))),
    );
  }
}
