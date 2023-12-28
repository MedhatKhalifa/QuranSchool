import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
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
    return Scaffold(
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
                        child: Text(' Please renew your subscribtion  first '))
                    : ListView(
                        children: [
                          SizedBox(height: h(20)),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                                Center(child: Text('Your session will  '.tr)),
                          ),
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(' at : ' +
                                      (DateFormat('yy/MM/dd HH:mm').format(
                                              DateTime.parse(mySesionController
                                                      .nextSession.value.date! +
                                                  ' ' +
                                                  mySesionController.nextSession
                                                      .value.time!)))
                                          .toString()))),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                                child:
                                    Text('Your next Session will start after')),
                          ),
                          Center(
                              child: SlideCountdown(
                            durationTitle: Get.locale?.languageCode == 'ar'
                                ? DurationTitle.ar()
                                : DurationTitle.en(),
                            slideDirection: SlideDirection.down,
                            separatorType: SeparatorType.title,
                            duration: Duration(
                                minutes: mySesionController.diffMinutes.value),
                          )),
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: ElevatedButton(
                                onPressed: () {
                                  if (mySesionController.diffMinutes.value <
                                          40 &&
                                      mySesionController.diffMinutes.value >
                                          -30) {
                                    mySesionController.getToken(
                                        mySesionController
                                            .nextSession.value.teacher,
                                        mySesionController
                                            .nextSession.value.student);
                                  }
                                },
                                child: const Text(' Join Session ')),
                          ),
                        ],
                      )),
      ),
      bottomNavigationBar: MybottomBar(),
    );
  }
}
