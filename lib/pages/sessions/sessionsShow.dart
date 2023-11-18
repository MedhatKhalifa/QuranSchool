import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
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
                          view: CalendarView.schedule,
                          minDate: DateTime.now(),
                          maxDate: DateTime.now().add(const Duration(days: 90)),
                          dataSource: MeetingDataSource(_getNextSessions()),
                          scheduleViewSettings: ScheduleViewSettings(
                            hideEmptyScheduleWeek: true,
                          ),
                          monthViewSettings: const MonthViewSettings(
                              showTrailingAndLeadingDates: false,
                              appointmentDisplayMode:
                                  MonthAppointmentDisplayMode.appointment,
                              showAgenda: true),
                          onTap: (day) {
                            setState(() {
                              if (day.targetElement ==
                                  CalendarElement.appointment) {
                                Meeting appointment = day.appointments![0];
                                if (appointment.selected) {
                                  mySesionController.getToken(
                                      appointment.teacher, appointment.student);
                                }
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
                          view: CalendarView.schedule,
                          // minDate: DateTime.now(),
                          maxDate:
                              DateTime.now(), //.add(const Duration(days: 90)),
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
                        )),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => subscribitionController.isLoadingsession.isTrue
            ? Text('')
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: Text("Start", style: TextStyle(fontSize: sp(14))),
                      onPressed: () async {},
                    ),
                    ElevatedButton(
                      child: Text("change time",
                          style: TextStyle(fontSize: sp(14))),
                      onPressed: () async {},
                    ),
                    ElevatedButton(
                      child: Text("rate", style: TextStyle(fontSize: sp(14))),
                      onPressed: () async {
                        //  Get.to(RateSession());

                        Get.to(() => RateSession());
                      },
                    ),
                  ],
                )),
      ),
    );
  }

  List<Meeting> _getNextSessions() {
    meetings.clear();
    for (var s in subscribitionController.sessions) {
      if (s.date != null && s.time != null) {
        DateTime sessionDateTime = DateTime.parse(s.date! + " " + s.time!);
        if (sessionDateTime.isAfter(DateTime.now())) {
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
