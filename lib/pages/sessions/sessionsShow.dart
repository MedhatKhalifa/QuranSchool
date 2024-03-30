import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/bottom_bar_controller.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/home_page/profile_page_bottom.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:quranschool/pages/sessions/changeSessionTime.dart';
import 'package:quranschool/pages/sessions/controller/session_control.dart';
import 'package:quranschool/pages/sessions/rate.dart';
import 'package:quranschool/pages/sessions/videoScreen.dart';
import 'package:quranschool/pages/sessions/test.dart';
import 'package:quranschool/pages/sessions/videoConference.dart';
import 'package:quranschool/pages/search/confirmation.dart';
import 'package:quranschool/pages/student/subscription/control/subscription_controller.dart';
import 'package:quranschool/pages/teacher/model/availability_model.dart';
import 'package:quranschool/pages/teacher/model/meeting_model.dart';
import 'package:quranschool/pages/teacher/model/sessions_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class SessionsShow extends StatefulWidget {
  const SessionsShow({super.key});

  @override
  State<SessionsShow> createState() => _SessionsShowState();
}

class _SessionsShowState extends State<SessionsShow> {
  final SubscribitionController subscribitionController =
      Get.put(SubscribitionController());

  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());
  final MySesionController mySesionController = Get.put(MySesionController());

  @override
  void initState() {
    super.initState();
    mySesionController.selectedMeeting.value = Meeting(
        "",
        DateTime.now(),
        DateTime.now(),
        Colors.black,
        true,
        true,
        -1,
        -1,
        -1,
        "",
        -1,
        "",
        -1,
        "",
        "");
  }

  int counterSelection = 0;
  final List<Meeting> meetings = <Meeting>[];
  bool showBottom = false;
  final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());

  int calculateDifferenceInMinutes(Meeting _meeting) {
    // sessionDateTime = DateTime.parse(
    //   '${mySesionController.nextSession.value.date} ${mySesionController.nextSession.value.time}');
    //   _meeting.from
    final DateTime now = DateTime.now();
    final Duration difference = _meeting.from.difference(now);
    return difference.inMinutes;
  }

  DateTime? _datePicked = DateTime.now();

  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context, appointment) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });

      _selectTime(context, appointment);
    }
  }

  Future<void> _selectTime(BuildContext context, Meeting appointment) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedDate = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
      appointment.from = selectedDate!;
      // Do something with the selected date and time
      print("Selected Date and Time: $selectedDate");
      mySesionController.updateMySession(appointment);
      Navigator.of(context).pop();
    }
  }

  Future<void> _showChangeSessionTimeDialog(
      BuildContext context, appointment) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.hourglass_empty, color: Colors.orange),
              SizedBox(width: 10),
              Text(
                'change_session'.tr,
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'sure_change_session'.tr,
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'.tr),
            ),
            TextButton(
              onPressed: () {
                // Handle changing the session time
                // ...
                //_selectDate(context, appointment);
                _selectDate(context, appointment);
                // Navigator.of(context).pop(); // Close the dialog
                //  Get.to(ChangeSesionTime());
              },
              child: Text(
                'Yes'.tr,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        // Override the back button behavior to navigate to a specific page, e.g., '/home'
        if (currentUserController.currentUser.value.id == -1) {
          myBottomBarCtrl.selectedIndBottomBar.value = 3;
        } else if (currentUserController.currentUser.value.userType ==
            "student") {
          myBottomBarCtrl.selectedIndBottomBar.value = 5;
        } else if (currentUserController.currentUser.value.userType ==
            "teacher") {
          myBottomBarCtrl.selectedIndBottomBar.value = 4;
        }
        Get.to(ProfilePageBottom());
        return false; // Do not allow the default back button behavior
      },
      child: Scaffold(
        appBar: simplAppbar(true),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: 'Next_sessions'.tr),
                  Tab(text: 'Old_session'.tr),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                      child: Obx(() => subscribitionController
                              .isLoadingsession.isTrue
                          ? Center(
                              child: LoadingBouncingGrid.circle(
                                borderColor: mybrowonColor,
                                backgroundColor: Colors.white,
                              ),
                            )
                          : SfCalendar(
                              allowedViews: [
                                CalendarView.week,
                                CalendarView.month,
                                CalendarView.schedule
                              ],

                              showNavigationArrow: true,
                              allowDragAndDrop: true,
                              view: CalendarView.schedule,
                              // timeSlotViewSettings: TimeSlotViewSettings(
                              //   timeInterval: Duration(minutes: 30),
                              // ),

                              appointmentBuilder: (BuildContext context,
                                  CalendarAppointmentDetails details) {
                                final Meeting meeting =
                                    details.appointments.first;

                                // Check the current locale language
                                String languageCode =
                                    Get.locale?.languageCode ?? 'en';

                                // Define the date format based on the language
                                DateFormat formatter = languageCode == 'ar'
                                    ? DateFormat.jm('ar')
                                    : DateFormat.jm('en');

                                // Format the time
                                String formattedTime =
                                    formatter.format(meeting.from);

                                if (currentUserController
                                        .currentUser.value.userType ==
                                    "teacher") {
                                  return GestureDetector(
                                    onTap: () {
                                      // Handle long press action here
                                      if (currentUserController
                                              .currentUser.value.userType ==
                                          "teacher") {
                                        for (Meeting appointment
                                            in details.appointments) {
                                          if (appointment.eventName
                                              .contains(', Paid')) {
                                            if (calculateDifferenceInMinutes(
                                                    appointment) >
                                                60) {
                                              _showChangeSessionTimeDialog(
                                                  context, appointment);
                                            } else {
                                              Get.snackbar(
                                                "Warning".tr,
                                                "cannot_change_withinhour".tr,
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                duration: Duration(seconds: 5),
                                              );
                                            }
                                          }
                                        }
                                      }
                                    },
                                    child: Container(
                                      //color: meeting.background,
                                      decoration: BoxDecoration(
                                          color: meeting.background,
                                          borderRadius: BorderRadius.circular(
                                              5) // Adjust the value as needed
                                          ),
                                      child: Column(
                                        children: [
                                          Text(
                                            meeting.eventName,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                formattedTime,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Icon(Icons.edit),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ), // Replace this with your desired icon
                                  );
                                } else {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: meeting.background,
                                        borderRadius: BorderRadius.circular(
                                            5) // Adjust the value as needed
                                        ),
                                    child: Column(
                                      children: [
                                        Text(
                                          meeting.eventName,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              formattedTime,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },

                              // minDate: DateTime.now(),
                              // maxDate: DateTime.now().add(const Duration(days: 90)),
                              dataSource: MeetingDataSource(_getNextSessions()),

                              // dragAndDropSettings:
                              //     DragAndDropSettings(allowNavigation: true),

                              scheduleViewSettings: ScheduleViewSettings(
                                  hideEmptyScheduleWeek: true,
                                  monthHeaderSettings: MonthHeaderSettings(
                                    height: h(13),
                                    textAlign: TextAlign.center,
                                  )),
                              // monthViewSettings: const MonthViewSettings(
                              //     showTrailingAndLeadingDates: false,
                              //     appointmentDisplayMode:
                              //         MonthAppointmentDisplayMode.appointment,
                              //     showAgenda: true),

                              onLongPress: (day) {
                                if (currentUserController
                                        .currentUser.value.userType ==
                                    "teacher") {
                                  setState(() {
                                    if (day.targetElement ==
                                        CalendarElement.appointment) {
                                      Meeting appointment =
                                          day.appointments![0];

                                      if (calculateDifferenceInMinutes(
                                              appointment) >
                                          60) {
                                        _showChangeSessionTimeDialog(
                                            context, appointment);
                                        // Get.dialog(
                                        //   AlertDialog(
                                        //     title: Row(
                                        //       children: [
                                        //         Icon(Icons.hourglass_empty),
                                        //         SizedBox(width: 10),
                                        //         Text('Change Session Time'),
                                        //       ],
                                        //     ),
                                        //     content: Text(
                                        //         'Are you sure you want to change the session time?'),
                                        //     actions: [
                                        //       TextButton(
                                        //         onPressed: () {
                                        //           Get.back(); // Dismiss the dialog
                                        //         },
                                        //         child: Text('No'),
                                        //       ),
                                        //       TextButton(
                                        //         onPressed: () {
                                        //           // Handle changing the session time
                                        //           // ...
                                        //           _selectDate(context, appointment);
                                        //           // Navigator.of(context).pop();
                                        //           //  Get.to(ChangeSesionTime());
                                        //         },
                                        //         child: Text('Yes'),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // );
                                      } else {
                                        Get.snackbar(
                                          "Warning".tr,
                                          "cannot_change_withinhour".tr,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                          duration: Duration(seconds: 5),
                                        );
                                      }
                                      // if (appointment.selected) {
                                      //   mySesionController.getToken(
                                      //       appointment.teacher, appointment.student);
                                      // }
                                    }
                                  });
                                }
                              },
                            )),
                    ),
                    Obx(() => subscribitionController.isLoadingsession.isTrue
                        ? Center(
                            child: LoadingBouncingGrid.circle(
                              borderColor: mybrowonColor,
                              backgroundColor: Colors.white,
                            ),
                          )
                        : SizedBox(
                            height: h(80),
                            child: SfCalendar(
                              allowedViews: [
                                CalendarView.month,
                                CalendarView.schedule
                              ],
                              showNavigationArrow: true,
                              view: CalendarView.schedule,
                              // minDate: DateTime.now(),
                              maxDate: DateTime
                                  .now(), //.add(const Duration(days: 90)),
                              dataSource: MeetingDataSource(_getOldSessions()),

                              scheduleViewSettings: ScheduleViewSettings(
                                  hideEmptyScheduleWeek: true,
                                  monthHeaderSettings: MonthHeaderSettings(
                                    height: h(13),
                                    textAlign: TextAlign.center,
                                  )),
                              monthViewSettings: const MonthViewSettings(
                                  showTrailingAndLeadingDates: false,
                                  appointmentDisplayMode:
                                      MonthAppointmentDisplayMode.appointment,
                                  showAgenda: true),
                              onTap: (day) {
                                print(day.targetElement);
                                mySesionController.selectedMeeting.value =
                                    day.appointments![0];
                                if (mySesionController
                                        .selectedMeeting.value.eventName !=
                                    "No Evaluation") {
                                  mySesionController
                                          .selectedSession.value.studentRate =
                                      mySesionController
                                          .selectedMeeting.value.studentRate;
                                  mySesionController.selectedSession.value.id =
                                      mySesionController
                                          .selectedMeeting.value.id;
                                  mySesionController
                                          .selectedSession.value.teacherRank =
                                      mySesionController
                                          .selectedMeeting.value.teacherRank;
                                  mySesionController
                                          .selectedSession.value.review =
                                      mySesionController
                                          .selectedMeeting.value.review;
                                  mySesionController.selectedSession.value
                                          .teacherOpinion =
                                      mySesionController
                                          .selectedMeeting.value.teacherOpinion;
                                  mySesionController.feedbackEdit.value = false;
                                  Get.to(RateSession());
                                }

                                print(mySesionController.selectedMeeting);
                                // setState(() {
                                //   if (day.targetElement ==
                                //       CalendarElement.appointment) {
                                //     Meeting appointment = day.appointments![0];
                                //     if (appointment.selected) {
                                //       mySesionController.getToken(
                                //           appointment.teacher, appointment.student);
                                //     }
                                //   }
                                // });
                              },
                            ),
                          )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Meeting> _getNextSessions() {
    showBottom = true;

    meetings.clear();
    for (var s in subscribitionController.sessions) {
      if (s.date != null && s.time != null) {
        DateTime sessionDateTime = DateTime.parse(s.date! + " " + s.time!);
        DateTime now = DateTime.now();
        now = now.subtract(Duration(minutes: 29));
        if (sessionDateTime.isAfter(now)) {
          int minutesUntilEvent = DateTime.parse(s.date! + " " + s.time!)
              .difference(DateTime.now())
              .inMinutes;

          bool isNextSession =
              minutesUntilEvent >= 35 && minutesUntilEvent <= 30;

          meetings.add(Meeting(
              currentUserController.currentUser.value.accountToken == "teacher"
                  ? s.teacherName!
                  : s.studentName! + ' , ' + s.studentSubscriptionStatus!,
              DateTime.parse(s.date! + " " + s.time!),
              DateTime.parse(s.date! + " " + s.time!)
                  .add(Duration(minutes: 30)),
              s.studentSubscriptionStatus == 'Paid'
                  ? Colors.green
                  : Colors.grey,
              // isNextSession ? Colors.green : Colors.grey,
              false,
              isNextSession,
              s.teacher!,
              s.student!,
              s.studentRate!,
              s.teacherOpinion!,
              s.teacherRank!,
              s.review!,
              s.id!,
              s.teacherName!,
              s.studentName!));
        }
      }
    }

    return meetings;
  }

  List<Meeting> _getOldSessions() {
    showBottom = false;
    List<Meeting> meetings = [];
    DateTime now = DateTime.now();

    for (var s in subscribitionController.sessions) {
      if (s.date != null && s.time != null) {
        DateTime sessionDateTime = DateTime.parse(s.date! + " " + s.time!);
        if (sessionDateTime.isBefore(now) &&
            !sessionDateTime.isAfter(now.subtract(Duration(minutes: 30)))) {
          String _label = s.studentRate == -1
              ? "No Evaluation"
              : "evaluation : " + s.studentRate.toString();
          if (currentUserController.currentUser.value.userType == "teacher") {
            _label = s.teacherRank == -1
                ? "No Evaluation"
                : "evaluation : " + s.teacherRank.toString();
          }

          meetings.add(Meeting(
              _label,
              DateTime.parse(s.date! + " " + s.time!),
              DateTime.parse(s.date! + " " + s.time!)
                  .add(Duration(minutes: 30)),
              _label == "No Evaluation" ? Colors.grey : Colors.green,
              false,
              false,
              s.teacher!,
              s.student!,
              s.studentRate!,
              s.teacherOpinion!,
              s.teacherRank!,
              s.review!,
              s.id!,
              s.teacherName!,
              s.studentName!));
        }
      }
    }
    // Sort meetings in descending order by start time
    meetings.sort((a, b) => a.from.compareTo(b.from)); // Newest to oldest
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}
