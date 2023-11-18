import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:quranschool/pages/Auth/Model/users.dart';

List<Session> parseSessionsfromjson(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Session>((json) => Session.fromJson(json)).toList();
}

parseSessionsfromListofMap(List<Map<String, dynamic>> jsonList) {
  return jsonList.map<Session>((json) => Session.fromJson(json)).toList();
}

class Session {
  bool selected = false;
  int? id;
  String? date;
  String? time;
  bool? teacherAttendance;
  bool? studentAttendance;
  String? sessionStatus;
  String? teacherOpinion;
  String? review;
  int? teacher;
  int? studentRate;
  int? student;
  double? teacherRank;

  Session({
    this.teacherAttendance,
    this.studentAttendance,
    this.sessionStatus,
    this.teacherOpinion,
    this.teacherRank,
    this.date,
    this.time,
    this.review,
    this.teacher,
    this.studentRate,
    this.student,
    this.selected = false,
  });

  Session.fromJson(Map<String, dynamic> json) {
    teacherAttendance = json['teacherAttendance'] ?? false;
    studentAttendance = json['studentAttendance'] ?? false;
    sessionStatus = json['sessionStatus'] ?? "";
    teacherOpinion = json['teacherOpinion'] ?? "";
    date = json['date'] ?? "";
    time = json['time'] ?? "";
    id = json['id'] ?? -1;

    teacher = json['teacher'] ?? -1;
    studentRate = json['studentRate'] ?? -1;
    teacherRank = json['teacherRank'] ?? -1;
    student = json['student'] ?? -1;
    review = json['review'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['teacherAttendance'] = this.teacherAttendance;
    data['studentAttendance'] = this.studentAttendance;
    data['sessionStatus'] = this.sessionStatus;
    data['teacherOpinion'] = this.teacherOpinion;
    data['review'] = this.review;
    data['teacher'] = this.teacher;
    data['studentRate'] = this.studentRate;
    data['student'] = this.student;
    data['teacherRank'] = this.teacherRank;
    return data;
  }
}

List<Session> generateDatetimeSessions(int teacherId, int studentId, int days) {
  final List<Session> sessions = [];
  final DateTime now = DateTime.now();

  for (int day = 0; day < days; day++) {
    DateTime sessionDate = now.add(Duration(days: day));

    // Calculate the nearest start time, either 00 or 30 minutes past the hour
    int currentMinute = sessionDate.minute;
    int nearestMinute = (currentMinute < 30) ? 30 : 0;

    // Set the start time to the nearest minute
    sessionDate = DateTime(
      sessionDate.year,
      sessionDate.month,
      sessionDate.day,
      sessionDate.hour,
      nearestMinute,
    );

    if (day > 0) {
      sessionDate = DateTime(
        sessionDate.year,
        sessionDate.month,
        sessionDate.day,
        0,
        nearestMinute,
      );
    }

    // Generate sessions with 30-minute intervals from the nearest start time
    for (int hour = sessionDate.hour; hour < 24; hour++) {
      final DateTime sessionTime =
          sessionDate.add(Duration(hours: hour - sessionDate.hour));
      sessions.add(Session(
        date: DateFormat('yyyy-MM-dd').format(sessionTime),
        time: DateFormat('HH:mm').format(sessionTime),
        sessionStatus: 'Pending Approval',
        teacher: teacherId,
        student: studentId,
      ));

      // Add a second session for the next half-hour interval
      if (hour < 23) {
        final DateTime nextHalfHour = sessionTime.add(Duration(minutes: 30));
        sessions.add(Session(
          date: DateFormat('yyyy-MM-dd').format(nextHalfHour),
          time: DateFormat('HH:mm').format(nextHalfHour),
          sessionStatus: 'Pending Approval',
          teacher: teacherId,
          student: studentId,
        ));
      }
    }
  }

  return sessions;
}
