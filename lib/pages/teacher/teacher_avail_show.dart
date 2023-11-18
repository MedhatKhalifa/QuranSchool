import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/student/subscription/control/subscription_controller.dart';
import 'package:quranschool/pages/teacher/model/availability_model.dart';
import 'package:quranschool/pages/teacher/model/meeting_model.dart';
import 'package:quranschool/pages/teacher/model/sessions_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import 'package:flutter/scheduler.dart';

class TeacherCalendarShow extends StatefulWidget {
  const TeacherCalendarShow({super.key});

  @override
  State<TeacherCalendarShow> createState() => _TeacherCalendarShowState();
}

class _TeacherCalendarShowState extends State<TeacherCalendarShow> {
  final SubscribitionController subscribitionController =
      Get.put(SubscribitionController());

  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

  generateString() {
    return " I have selected teacher " +
        subscribitionController.selectedTeacher.value.user!.fullName +
        ", userName " +
        subscribitionController.selectedTeacher.value.user!.username +
        " and seleted Package " +
        subscribitionController.selectedPayement.value.price! +
        " EGP for No of sessions " +
        subscribitionController.selectedPayement.value.sessionCount!.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int counterSelection = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: simplAppbar(
          true, subscribitionController.selectedTeacher.value.user!.fullName),
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
            : subscribitionController.meetings.length > 0
                ? SfCalendar(
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
                    scheduleViewSettings: ScheduleViewSettings(
                      hideEmptyScheduleWeek: true,
                    ),
                    minDate: DateTime.now(),
                    maxDate: DateTime.now().add(const Duration(days: 90)),
                    dataSource: MeetingDataSource(_getDataSource()),

                    monthViewSettings: const MonthViewSettings(
                        showTrailingAndLeadingDates: false,
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.appointment,
                        showAgenda: true),
                    // onTap: (day) {

                    //   // Filter freeSlots to get times when the day matches

                    //   setState(() {
                    //     if (day.targetElement == CalendarElement.appointment) {
                    //       Meeting appointment = day.appointments![0];
                    //       appointment.selected = !appointment.selected;

                    //       if (appointment.selected) {
                    //         appointment.background = Colors.green;
                    //         counterSelection++;
                    //       } else {
                    //         appointment.background = Colors.grey;
                    //         counterSelection--;
                    //       }
                    //       //appointment.background = Colors.red;
                    //     }

                    //   });
                    // },
                  )
                : Center(child: Text('No Free Slots')),
      ),
    );
  }

  List<Meeting> _getDataSource() {
    // final List<Meeting> meetings = <Meeting>[];
    // final DateTime today = DateTime.now();
    // final DateTime startTime =
    //     DateTime(today.year, today.month, today.day, 9, 0, 0);
    // final DateTime endTime = startTime.add(const Duration(hours: 2));
    // meetings.add(Meeting(
    //     'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    // meetings.add(Meeting(
    //     'Medhat', startTime, endTime, Color.fromARGB(255, 134, 15, 61), false));
    return subscribitionController.meetings;
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
