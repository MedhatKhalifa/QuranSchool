import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/Auth/controller/sharedpref_function.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/student/subscription/control/subscription_controller.dart';
import 'package:quranschool/pages/teacher/model/availability_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

// teacher add avaialble time
class AvailabilityInputPage extends StatefulWidget {
  @override
  State<AvailabilityInputPage> createState() => _AvailabilityInputPageState();
}

class _AvailabilityInputPageState extends State<AvailabilityInputPage> {
  // Sample list of availability data
  final List<Map<String, dynamic>> availabilityList = [
    // ... your availability data here
  ];

  final SubscribitionController subscribitionController =
      Get.put(SubscribitionController());

  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

  bool hasConflict(List<Availability> existingList, String day, String fromTime,
      String toTime) {
    DateTime newFromTime = DateFormat('HH:mm').parse(fromTime);
    DateTime newToTime = DateFormat('HH:mm').parse(toTime);

    for (var entry in existingList) {
      if (entry.day == day) {
        DateTime existingFromTime = DateFormat('HH:mm').parse(entry.fromTime!);
        DateTime existingToTime = DateFormat('HH:mm').parse(entry.toTime!);

        // Check for intersection between the existing and new time intervals
        // if (!((newFromTime.isAfter(existingToTime) ||
        //         newToTime.isBefore(existingFromTime)) ||
        //     (newFromTime.isBefore(existingFromTime) &&
        //         newToTime.isAfter(existingToTime))))
        if (!((newFromTime.isAfter(existingToTime) ||
            newFromTime == existingToTime ||
            newToTime == existingFromTime ||
            newToTime.isBefore(existingFromTime)))) {
          // Conflict found
          return true;
        }
      }
    }

    // No conflict found
    return false;
  }

  Future<void> _showAvailabilityDialog(BuildContext context) async {
    String selectedDay = 'Sunday';
    TimeOfDay selectedFromTime = TimeOfDay(hour: 12, minute: 0);
    TimeOfDay selectedToTime = TimeOfDay(hour: 14, minute: 0);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Availability'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => DropdownButton<String>(
                  value: subscribitionController.selectedDay.value,
                  items: [
                    'Saturday',
                    'Sunday',
                    'Monday',
                    'Tuesday',
                    'Wednesday',
                    'Thursday',
                    'Friday',
                  ].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.tr),
                      );
                    },
                  ).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      subscribitionController.selectedDay.value = value;
                    }
                  },
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('from_time'.tr),
                  TextButton(
                    onPressed: () async {
                      TimeOfDay? result = await showTimePicker(
                        context: context,
                        initialTime:
                            subscribitionController.selectedFromTime.value,
                      );
                      if (result != null) {
                        subscribitionController.selectedFromTime.value = result;
                      }
                    },
                    child: Obx(
                      () => Text(subscribitionController.selectedFromTime.value
                          .format(context)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('to_time'.tr),
                  TextButton(
                    onPressed: () async {
                      TimeOfDay? result = await showTimePicker(
                        context: context,
                        initialTime:
                            subscribitionController.selectedToTime.value,
                      );
                      if (result != null) {
                        subscribitionController.selectedToTime.value = result;
                      }
                    },
                    child: Obx(() => Text(subscribitionController
                        .selectedToTime.value
                        .format(context))),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'.tr),
            ),
            TextButton(
              onPressed: () {
                // Convert selected times to 24-hour format (HH:mm)
                String formattedFromTime =
                    '${subscribitionController.selectedFromTime.value.hour}:${subscribitionController.selectedFromTime.value.minute.toString().padLeft(2, '0')}';
                String formattedToTime =
                    '${subscribitionController.selectedToTime.value.hour}:${subscribitionController.selectedToTime.value.minute.toString().padLeft(2, '0')}';

                // Do something with selected values
                print('Selected Day: $selectedDay');
                print(
                    'Selected From Time: ${selectedFromTime.format(context)}');
                print('Selected To Time: ${selectedToTime.format(context)}');
                // Check if formattedToTime is after formattedFromTime
                if (formattedToTime.compareTo(formattedFromTime) > 0) {
                  // Check if new adding conflict with the current avai
                  if (hasConflict(
                      subscribitionController.availabilities,
                      subscribitionController.selectedDay.value,
                      formattedFromTime,
                      formattedToTime)) {
                    Get.snackbar(
                      "Warning".tr,
                      "coflict_for_existing_times".tr,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 2),
                    );
                  } else {
                    // Do something with selected values
                    subscribitionController.addAvaiTime(
                        currentUserController.currentUser.value.id.toString(),
                        subscribitionController.selectedDay.value,
                        formattedFromTime,
                        formattedToTime);
                    Navigator.of(context).pop();
                  }
                } else {
                  // Show an error message or take appropriate action

                  Get.snackbar(
                    "Warning".tr,
                    "invalid_time_after_before".tr,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 2),
                  );
                }

                // Close the dialog
              },
              child: Text('Save'.tr),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, teacherId, availID) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.red,
              ),
              SizedBox(width: 8),
              Text(
                'Warning'.tr,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text('sure_del_avail'.tr),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'.tr),
            ),
            TextButton(
              onPressed: () {
                // Perform the delete operation
                subscribitionController.delAvaiTime(teacherId, availID);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Delete'.tr,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  ///// Tutorial
  ///
  ///
  late TutorialCoachMark tutorialCoachMark;
  final reviewbutton = GlobalKey();
  final selectbutton = GlobalKey();
  TutorialCoachMark? tutorial;
  bool showtTuorial = true;
  void initTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: mybrowonColor,
      alignSkip: Alignment.topRight,

      textSkip: "skip_dont_show".tr,
      paddingFocus: 10,
      opacityShadow: 0.8,
      focusAnimationDuration: Duration(milliseconds: 30),
      // imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      // onFinish: () {
      //   print("finish");
      // },
      // onClickTarget: (target) {
      //   print('onClickTarget: $target');
      // },
      // onClickTargetWithTapPosition: (target, tapDetails) {
      //   print("target: $target");
      //   print(
      //       "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      // },
      // onClickOverlay: (target) {
      //   print('onClickOverlay: $target');
      // },
      onSkip: () {
        currentUserController.showTutorial.value.searchteacher = false;
        storeTutorialData(
            currentUserController.showTutorial.value, 'showTutorial');
        return true;
      },
    )..show(context: context);
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        identify: "reviewbutton", // Optional identifier
        keyTarget: reviewbutton, // GlobalKey of the ListTile
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "check_teacher_avail".tr,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        identify: "selectbutton", // Optional identifier
        keyTarget: selectbutton, // GlobalKey of the ListTile
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "next_choose_teacher".tr,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );

    return targets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simplAppbar(true, "myAvailability".tr),
      body: Obx(
        () => subscribitionController.isLoadingAvail.isTrue
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
            : Obx(
                () => SfCalendar(
                  view: CalendarView.week,
                  scheduleViewSettings: const ScheduleViewSettings(
                    hideEmptyScheduleWeek: false,
                  ),
                  viewNavigationMode: ViewNavigationMode.none,
                  firstDayOfWeek: 6,
                  minDate: DateTime(2023, 7, 1),
                  maxDate: DateTime(2023, 7, 8),
                  initialDisplayDate: DateTime(2023, 7, 1),
                  dataSource: _getCalendarDataSource(),
                  headerDateFormat: 'yyyy',
                  monthViewSettings: const MonthViewSettings(
                    dayFormat: 'EEE', // Display only day name (Sun, Mon, ...)
                  ),
                  onLongPress: (day) {
                    // Filter freeSlots to get times when the day matches

                    if (day.targetElement == CalendarElement.appointment) {
                      day.appointments![0];

                      _showDeleteConfirmationDialog(
                          context,
                          currentUserController.currentUser.value.id.toString(),
                          day.appointments![0].id);

                      //appointment.background = Colors.red;
                    }
                  },
                ),
              ),
      ),
      bottomNavigationBar: Obx(
        () => Visibility(
          visible: subscribitionController.isLoadingAvail.isFalse,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: w(80),
              child: ElevatedButton(
                child: Text('add_new'.tr, style: TextStyle(fontSize: sp(12))),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFFFD8C00))),
                onPressed: () async {
                  // buildQueryParams();
                  _showAvailabilityDialog(context);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  _DataSource _getCalendarDataSource() {
    List<Appointment> appointments = [];

    for (var availability in subscribitionController.availabilities) {
      String day = availability.day!;
      String fromTime = availability.fromTime!;
      String toTime = availability.toTime!;

      // Convert day name to actual date (you may need to adjust this logic based on your use case)
      DateTime startDate = _getStartDateFromDayName(day);

      // Create appointment for each availability
      Appointment appointment = Appointment(
        id: availability.id,
        startTime: DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
          int.parse(fromTime.split(':')[0]),
          int.parse(fromTime.split(':')[1]),
        ),
        endTime: DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
          int.parse(toTime.split(':')[0]),
          int.parse(toTime.split(':')[1]),
        ),
        subject: 'Teacher Availability',
        color: Colors.blue, // Set color as needed
      );

      appointments.add(appointment);
    }

    return _DataSource(appointments);
  }

  DateTime _getStartDateFromDayName(String dayName) {
    // Map day names to their corresponding numerical values
    Map<String, int> dayNameMap = {
      'MONDAY': DateTime.monday,
      'TUESDAY': DateTime.tuesday,
      'WEDNESDAY': DateTime.wednesday,
      'THURSDAY': DateTime.thursday,
      'FRIDAY': DateTime.friday,
      'SATURDAY': DateTime.saturday,
      'SUNDAY': DateTime.sunday,
    };

    // Convert day name to actual date
    DateTime now = DateTime.now();

    now = DateTime(
      2023,
      6,
      30,
      0,
      0,
    );
    int currentDayOfWeek = now.weekday;
    int targetDayOfWeek = dayNameMap[dayName.toUpperCase()] ?? DateTime.monday;

    int daysToAdd = targetDayOfWeek - currentDayOfWeek;
    if (daysToAdd <= 0) {
      daysToAdd += 7;
    }

    return now.add(Duration(days: daysToAdd));
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
