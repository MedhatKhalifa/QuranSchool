import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog before going back in the page.
        bool shouldGoBack = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Do you want to go back?'),
              content: Text('All unsaved changes will be lost.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Yes'),
                ),
              ],
            );
          },
        );

        // Return the result of the confirmation dialog.
        return shouldGoBack;
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
                          "Thank you for registering with us",
                          style:
                              TextStyle(color: Colors.green, fontSize: sp(14)),
                        ),
                        Text("An administrator will reach out to you shortly"),
                        Text(""),
                        Text(" The selected teacher's " +
                            subscribitionController
                                .selectedTeacher.value.user!.fullName +
                            ", userName " +
                            subscribitionController
                                .selectedTeacher.value.user!.username),
                        Text(""),
                        Text("The chosen package consists of " +
                            subscribitionController
                                .selectedPayement.value.sessionCount!
                                .toString()),
                        Text(" sessions at a cost of " +
                            subscribitionController
                                .selectedPayement.value.price! +
                            "EGP"),
                        IconButton(
                            onPressed: () {
                              Get.to(HomePage());
                            },
                            icon: Icon(Icons.home))
                      ]),
                ))),
    );
  }
}
