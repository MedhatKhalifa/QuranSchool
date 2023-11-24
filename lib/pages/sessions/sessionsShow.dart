import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/sessions/changeSessionTime.dart';
import 'package:quranschool/pages/sessions/controller/session_control.dart';
import 'package:quranschool/pages/sessions/rate.dart';
import 'package:quranschool/pages/sessions/videoScreen.dart';
import 'package:quranschool/pages/sessions/test.dart';
import 'package:quranschool/pages/sessions/videoConference.dart';
import 'package:quranschool/pages/student/subscription/confirmation.dart';
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
    mySesionController.selectedMeeting.value = Meeting("", DateTime.now(),
        DateTime.now(), Colors.black, true, true, -1, -1, -1, "", -1, "", -1);
  }

  int counterSelection = 0;
  final List<Meeting> meetings = <Meeting>[];
  bool showBottom = false;

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
                'Change Session Time',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to change the session time?',
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
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
                'Yes',
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
    return Scaffold(
      appBar: simplAppbar(true),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Next Sessions'),
                Tab(text: 'Old Sessions'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Obx(() => subscribitionController.isLoadingsession.isTrue
                      ? Center(
                          child: LoadingBouncingGrid.circle(
                            borderColor: mybrowonColor,
                            backgroundColor: Colors.white,
                          ),
                        )
                      : SfCalendar(
                          allowedViews: [
                            CalendarView.day,
                            CalendarView.week,
                            CalendarView.month,
                            CalendarView.timelineDay,
                            CalendarView.timelineWeek,
                            CalendarView.timelineWorkWeek,
                            CalendarView.timelineMonth,
                            CalendarView.schedule
                          ],

                          showNavigationArrow: true,
                          allowDragAndDrop: true,
                          view: CalendarView.schedule,
                          // timeSlotViewSettings: TimeSlotViewSettings(
                          //   timeInterval: Duration(minutes: 30),
                          // ),

                          // minDate: DateTime.now(),
                          // maxDate: DateTime.now().add(const Duration(days: 90)),
                          dataSource: MeetingDataSource(_getNextSessions()),

                          // dragAndDropSettings:
                          //     DragAndDropSettings(allowNavigation: true),

                          scheduleViewSettings: ScheduleViewSettings(
                            hideEmptyScheduleWeek: true,
                          ),
                          // monthViewSettings: const MonthViewSettings(
                          //     showTrailingAndLeadingDates: false,
                          //     appointmentDisplayMode:
                          //         MonthAppointmentDisplayMode.appointment,
                          //     showAgenda: true),
                          onLongPress: (day) {
                            setState(() {
                              if (day.targetElement ==
                                  CalendarElement.appointment) {
                                Meeting appointment = day.appointments![0];

                                if (calculateDifferenceInMinutes(appointment) >
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
                                    "Warning",
                                    "You can't change session timer within one hour",
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
                          },
                        )),
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
                              CalendarView.day,
                              CalendarView.week,
                              CalendarView.month,
                              CalendarView.timelineDay,
                              CalendarView.timelineWeek,
                              CalendarView.timelineWorkWeek,
                              CalendarView.timelineMonth,
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
                            ),
                            monthViewSettings: const MonthViewSettings(
                                showTrailingAndLeadingDates: false,
                                appointmentDisplayMode:
                                    MonthAppointmentDisplayMode.appointment,
                                showAgenda: true),
                            onTap: (day) {
                              print(day.targetElement);
                              mySesionController.selectedMeeting.value =
                                  day.appointments![0];
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
              minutesUntilEvent >= 30 && minutesUntilEvent <= 900000000;

          meetings.add(Meeting(
              isNextSession
                  ? minutesUntilEvent.toString() + " min to Start"
                  : s.sessionStatus!,
              DateTime.parse(s.date! + " " + s.time!),
              DateTime.parse(s.date! + " " + s.time!)
                  .add(Duration(minutes: 30)),
              isNextSession ? Colors.green : Colors.grey,
              false,
              isNextSession,
              s.teacher!,
              s.student!,
              s.studentRate!,
              s.teacherOpinion!,
              s.teacherRank!,
              s.review!,
              s.id!));
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
          meetings.add(Meeting(
              s.sessionStatus!,
              DateTime.parse(s.date! + " " + s.time!),
              DateTime.parse(s.date! + " " + s.time!)
                  .add(Duration(minutes: 30)),
              Colors.grey,
              false,
              false,
              s.teacher!,
              s.student!,
              s.studentRate!,
              s.teacherOpinion!,
              s.teacherRank!,
              s.review!,
              s.id!));
        }
      }
    }

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
