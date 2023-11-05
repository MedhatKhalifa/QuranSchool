import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/sessions/session_control.dart';
import 'package:quranschool/pages/sessions/sharescreen.dart';
import 'package:quranschool/pages/sessions/videoConference.dart';
import 'package:quranschool/pages/student/subscription/control/subscription_controller.dart';
import 'package:quranschool/pages/teacher/model/availability_model.dart';
import 'package:quranschool/pages/teacher/model/meeting_model.dart';
import 'package:quranschool/pages/teacher/model/sessions_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import 'package:flutter/scheduler.dart';

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
    // TODO: implement initState
    super.initState();
  }

  int counterSelection = 0;
  final List<Meeting> meetings = <Meeting>[];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: simplAppbar(true),
      body: Obx(() => subscribitionController.isLoadingsession.isTrue
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
              dataSource: MeetingDataSource(_getDataSource()),
              scheduleViewSettings: ScheduleViewSettings(
                hideEmptyScheduleWeek: true,
              ),
              monthViewSettings: const MonthViewSettings(
                  showTrailingAndLeadingDates: false,
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                  showAgenda: true),
              onTap: (day) {
                // Filter freeSlots to get times when the day matches

                setState(() {
                  if (day.targetElement == CalendarElement.appointment) {
                    Meeting appointment = day.appointments![0];
                    if (appointment.selected) {
                      mySesionController.getToken(
                          appointment.teacher, appointment.student);
                      // Get.to(MyVideoCall());
                      // print('Go to Video');
                      // Get.to(VideoScreenCall());
                    }
                    //appointment.background = Colors.red;
                  }
                });
              },
            )),
    );
  }

  List<Meeting> _getDataSource() {
    meetings.clear();
    for (var s in subscribitionController.sessions) {
      if (s.date != null && s.time != null) {
        DateTime sessionDateTime = DateTime.parse(s.date! + " " + s.time!);
        if (sessionDateTime.isAfter(DateTime.now())) {
          // Calculate the time difference in minutes.
          int minutesUntilEvent = DateTime.parse(s.date! + " " + s.time!)
              .difference(DateTime.now())
              .inMinutes;

          // Check if there are at least 30 minutes left for the event.
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
              s.student!));
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
