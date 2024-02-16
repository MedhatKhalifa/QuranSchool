import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/Auth/controller/login_controller.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/search/stepper_pages.dart';
import 'package:quranschool/pages/search/confirmation.dart';
import 'package:quranschool/pages/student/subscription/control/subscription_controller.dart';
import 'package:quranschool/pages/teacher/model/availability_model.dart';
import 'package:quranschool/pages/teacher/model/meeting_model.dart';
import 'package:quranschool/pages/teacher/model/sessions_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import 'package:flutter/scheduler.dart';

class CalendarShow extends StatefulWidget {
  const CalendarShow({super.key});

  @override
  State<CalendarShow> createState() => _CalendarShowState();
}

class _CalendarShowState extends State<CalendarShow> {
  final SubscribitionController subscribitionController =
      Get.put(SubscribitionController());

  final LoginController loginController = Get.put(LoginController());

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

  var freeSlots, sessions, filteredSlots = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: simplAppbar(
          true,
          "Select".tr +
              subscribitionController.selectedPayement.value.sessionCount
                  .toString() +
              " sesions".tr),
      body: Obx(
        () => subscribitionController.isLoadingmeetings.isTrue
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
            : Column(
                children: [
                  // mystepper(4),
                  Expanded(
                    child: SfCalendar(
                      showNavigationArrow: true,
                      view: CalendarView.schedule,
                      minDate: DateTime.now(),
                      maxDate: DateTime.now().add(const Duration(days: 90)),
                      dataSource: MeetingDataSource(_getDataSource()),
                      onViewChanged: (ViewChangedDetails viewChangedDetails) {
                        List<DateTime> dates = viewChangedDetails.visibleDates;
                        SchedulerBinding.instance!
                            .addPostFrameCallback((Duration duration) {
                          setState(() {
                            var _month = DateFormat('MMMM')
                                .format(viewChangedDetails.visibleDates[
                                    viewChangedDetails.visibleDates.length ~/
                                        2])
                                .toString();
                            var _year = DateFormat('yyyy')
                                .format(viewChangedDetails.visibleDates[
                                    viewChangedDetails.visibleDates.length ~/
                                        2])
                                .toString();

                            print(_month + _year);
                          });
                        });
                      },
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
                        // Filter freeSlots to get times when the day matches

                        setState(() {
                          if (day.targetElement ==
                              CalendarElement.appointment) {
                            Meeting appointment = day.appointments![0];
                            if (subscribitionController.countofSelectSession <
                                    subscribitionController
                                        .selectedPayement.value.sessionCount! ||
                                appointment.selected) {
                              appointment.selected = !appointment.selected;

                              if (appointment.selected) {
                                subscribitionController.selectedMeetings
                                    .add(appointment);
                                appointment.background = Colors.green;
                                subscribitionController.countofSelectSession++;
                              } else {
                                subscribitionController.selectedMeetings
                                    .remove(appointment);
                                appointment.background = Colors.grey;
                                subscribitionController.countofSelectSession--;
                              }
                            }
                            //appointment.background = Colors.red;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: w(80),
          child: ElevatedButton(
            child: Text(
                subscribitionController.countofSelectSession ==
                        subscribitionController
                            .selectedPayement.value.sessionCount!
                    ? 'Submit'.tr
                    : 'Selected_sessions'.tr +
                        subscribitionController.countofSelectSession
                            .toString() +
                        'out_of'.tr +
                        subscribitionController
                            .selectedPayement.value.sessionCount!
                            .toString(),
                style: TextStyle(fontSize: sp(14))),
            style: ButtonStyle(
                backgroundColor: subscribitionController.countofSelectSession <
                        subscribitionController
                            .selectedPayement.value.sessionCount!
                    ? MaterialStateProperty.all(Colors.grey)
                    : MaterialStateProperty.all(Color(0xFFFD8C00))),
            onPressed: () async {
              // buildQueryParams();
              print(subscribitionController.selectedMeetings);
              if (subscribitionController.countofSelectSession ==
                  subscribitionController
                      .selectedPayement.value.sessionCount!) {
                subscribitionController.createStudentSubsc();
                // if (subscribitionController
                //         .selectedPayement.value.subscriptionName! ==
                //     'Free Session') {
                //   loginController.setFreeSession();
                // }
                Get.to(ConfirmationPage());
                //Get.snackbar("Note", generateString(), colorText: Colors.black);
              } else {
                Get.snackbar("Warning".tr, "select_session_first".tr,
                    colorText: Colors.black);
              }
            },
          ),
        ),
      ),
    );
  }

// OkAY
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
