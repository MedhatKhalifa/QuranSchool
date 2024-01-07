import 'package:im_stepper/stepper.dart';
import 'package:flutter/material.dart';
import 'package:quranschool/core/theme.dart';

mystepper(int activeicon) {
  return IconStepper(
    steppingEnabled: false,
    enableNextPreviousButtons: false,
    icons: [
      Icon(
        Icons.search,
        color: Colors.white,
      ),
      Icon(Icons.supervised_user_circle, color: Colors.white),
      Icon(Icons.person, color: Colors.white),
      Icon(Icons.attach_money, color: Colors.white),
      Icon(Icons.event, color: Colors.white),
      Icon(Icons.done, color: Colors.white),
    ],
    activeStepBorderColor: mybrowonColor,
    lineColor: Colors.grey,
    stepColor: Colors.grey,
    activeStepColor: mybrowonColor,
    activeStep: activeicon,
  );
}
