import 'package:flutter/material.dart';

class Meeting {
  Meeting(
    this.eventName,
    this.from,
    this.to,
    this.background,
    this.isAllDay,
    this.selected,
    this.teacher,
    this.student,
    this.studentRate,
    this.teacherOpinion,
    this.teacherRank,
    this.review,
    this.id,
    this.studentName,
    this.teacherName,
  );

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  bool selected;
  int teacher;
  int student;
  int studentRate;
  String teacherOpinion;
  int teacherRank;
  String review;
  int id;
  String studentName;
  String teacherName;
}
