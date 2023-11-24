import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    }
  }

  int calculateDifferenceInMinutes(DateTime sessionDateTime) {
    final DateTime now = DateTime.now();
    final Duration difference = sessionDateTime.difference(now);
    return difference.inMinutes;
  }

  void startTimer() {
    const oneMinute = const Duration(minutes: 1);
    _timer = Timer.periodic(oneMinute, (timer) {
      setState(() {
        // Calculate the remaining time
        int remainingMinutes = calculateDifferenceInMinutes(sessionDateTime);

        // If the remaining time is zero or negative, stop the timer
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
      appBar: simplAppbar(false, "Your next session"),
      body: Obx(
        () => mySesionController.isNextSessionloading.isTrue
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
            : ListView(
                children: [
                  SizedBox(height: h(20)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text('Your next Session will start after')),
                  ),
                  Center(
                      child: SlideCountdown(
                    duration:
                        Duration(minutes: mySesionController.diffMinutes.value),
                  )),
                  if (remainingMinutes < 100000)
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: ElevatedButton(
                          onPressed: () {
                            mySesionController.getToken(
                                mySesionController.nextSession.value.teacher,
                                mySesionController.nextSession.value.student);
                          },
                          child: Text(' Join Session ')),
                    )
                ],
              ),
      ),
      bottomNavigationBar: mybottomBarWidget(),
    );
  }
}
