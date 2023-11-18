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
      this.id);

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
  double teacherRank;
  String review;
  int id;
}
