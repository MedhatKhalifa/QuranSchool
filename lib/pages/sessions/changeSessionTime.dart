import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:quranschool/pages/sessions/st.dart';
import 'package:quranschool/pages/student/subscription/control/subscription_controller.dart';

class ChangeSesionTime extends StatefulWidget {
  const ChangeSesionTime({super.key});

  @override
  State<ChangeSesionTime> createState() => _ChangeSesionTimeState();
}

class _ChangeSesionTimeState extends State<ChangeSesionTime> {
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());
  final SubscribitionController subscribitionController =
      Get.put(SubscribitionController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Execute your background function here

        // subscribitionController.getSessionsbyteaherID(
        //     currentUserController.currentUser.value.id,
        //     currentUserController.currentUser.value.userType);
        Get.to(HomePage());
        // Navigate to a specific page (in this case, FirstPage)
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => SessionsShow()),
        //   (route) => false,
        // );

        // Always return false to prevent the default back button behavior
        return false;
      },
      child: Scaffold(
        appBar: simplAppbar(true),
        body: Text(' fff '),
      ),
    );
  }
}
