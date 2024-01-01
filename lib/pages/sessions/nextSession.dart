import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/bottom_bar_controller.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:quranschool/pages/sessions/controller/session_control.dart';
import 'package:slide_countdown/slide_countdown.dart';

class NextSession extends StatefulWidget {
  @override
  _NextSessionState createState() => _NextSessionState();
}

class _NextSessionState extends State<NextSession> {
  late Timer _timer;
  late DateTime sessionDateTime;
  final MySesionController mySesionController = Get.put(MySesionController());
  final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());

  late int remainingMinutes;
  @override
  void initState() {
    super.initState();
    remainingMinutes = mySesionController.diffMinutes.value;
    if (remainingMinutes > 0) {
      sessionDateTime = DateTime.parse(
          '${mySesionController.nextSession.value.date} ${mySesionController.nextSession.value.time}');
      startTimer();
    } else {
      _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        // Your timer logic here
        print("Timer is running...");
      });
    }
  }

  int calculateDifferenceInMinutes(DateTime sessionDateTime) {
    final DateTime now = DateTime.now();
    final Duration difference = sessionDateTime.difference(now);
    return difference.inMinutes;
  }

  void startTimer() {
    const oneMinute = Duration(minutes: 1);
    _timer = Timer.periodic(oneMinute, (timer) {
      setState(() {
        // Calculate the remaining time
        int remainingMinutes = calculateDifferenceInMinutes(sessionDateTime);
        if (remainingMinutes <= 0) {
          timer.cancel();
        }

        print("Remaining time: $remainingMinutes minutes");
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Override the back button behavior to navigate to a specific page, e.g., '/home'
        myBottomBarCtrl.selectedIndBottomBar.value = 0;
        Get.to(HomePage());
        return false; // Do not allow the default back button behavior
      },
      child: Scaffold(
        appBar: simplAppbar(false, "my_next_session".tr),
        body: Container(
          child: Obx(() => mySesionController.isNextSessionloading.value == true
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
              : mySesionController.diffMinutes.value == -1000001
                  ? Center(child: Text(' Please Subscribe first '))
                  : mySesionController.diffMinutes.value == -1000002
                      ? Center(
                          child:
                              Text(' Please renew your subscribtion  first '))
                      : ListView(
                          children: [
                            SizedBox(height: h(20)),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text('Your session will at '.tr)),
                            ),
                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text((DateFormat('dd/MMM/yy hh:mm',
                                                Get.locale?.languageCode)
                                            .format(DateTime.parse(
                                                mySesionController.nextSession
                                                        .value.date! +
                                                    ' ' +
                                                    mySesionController
                                                        .nextSession
                                                        .value
                                                        .time!)))
                                        .toString()))),
                            // Visibility(
                            //   visible:
                            //       mySesionController.diffMinutes.value < 60 &&
                            //           mySesionController.diffMinutes.value > 1,
                            //   child: const Padding(
                            //     padding: EdgeInsets.all(8.0),
                            //     child: Center(
                            //         child: Text(
                            //             'Remaining time until the session starts is...')),
                            //   ),
                            // ),
                            // Visibility(
                            //   visible:
                            //       mySesionController.diffMinutes.value < 60 &&
                            //           mySesionController.diffMinutes.value > 1,
                            //   child: Center(
                            //       child: SlideCountdown(
                            //     // showZeroValue: true,
                            //     // durationTitle: Get.locale?.languageCode == 'ar'
                            //     //     ? DurationTitle.ar()
                            //     //     : DurationTitle.en(),
                            //     durationTitle: DurationTitle.en(),
                            //     slideDirection: SlideDirection.down,
                            //     separatorType: SeparatorType.title,
                            //     duration: Duration(
                            //         minutes:
                            //             mySesionController.diffMinutes.value),
                            //   )),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(25),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: mySesionController
                                                    .diffMinutes.value <
                                                30 &&
                                            mySesionController
                                                    .diffMinutes.value >
                                                -30
                                        ? MaterialStateProperty.all<Color>(
                                            mybrowonColor)
                                        : MaterialStateProperty.all<Color>(
                                            Colors.grey), // Change this color
                                    // You can add more styles here, like padding, shape, etc.
                                  ),
                                  onPressed: () {
                                    if (mySesionController.diffMinutes.value <
                                            30 &&
                                        mySesionController.diffMinutes.value >
                                            -30) {
                                      mySesionController.getToken(
                                          mySesionController
                                              .nextSession.value.teacher,
                                          mySesionController
                                              .nextSession.value.student);
                                    } else {
                                      final snackBar = SnackBar(
                                        content: Text(
                                          'The session hasn\'t started yet.',
                                          style: TextStyle(
                                              color: Colors
                                                  .white), // Set text color to white
                                        ),
                                        backgroundColor: Colors
                                            .red, // Set the background color to red
                                        duration: Duration(
                                            seconds:
                                                3), // Set the duration for how long the SnackBar will be displayed
                                      );

                                      // Use ScaffoldMessenger to show the SnackBar
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: const Text(' Join Session ')),
                            ),
                          ],
                        )),
        ),
        bottomNavigationBar: MybottomBar(),
      ),
    );
  }
}
