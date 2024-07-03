import 'dart:convert';

import 'package:quranschool/pages/Auth/Model/users.dart';
import 'package:intl/intl.dart';

List<Availability> parseAvailabilitysfromjson(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<Availability>((json) => Availability.fromJson(json))
      .toList();
}

List<Availability> parseAvailabilitysfromListofMap(
    List<Map<String, dynamic>> jsonList) {
  return jsonList
      .map<Availability>((json) => Availability.fromJson(json))
      .toList();
}

class Availability {
  Availability({
    this.id,
    this.day,
    this.fromTime,
    this.toTime,
    this.teacher,
    this.selected = false,
  });
  int? id;
  String? day;
  String? fromTime;
  String? toTime;
  int? teacher;
  bool selected = false;

  Availability.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? -1;
    fromTime = json['fromTime'] ?? -1;
    toTime = json['toTime'] ?? -1;
    teacher = json['teacher'] ?? -1;
    day = json['day'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['fromTime'] = this.fromTime;
    data['toTime'] = this.toTime;
    data['teacher'] = this.teacher;
    data['day'] = this.day;

    return data;
  }
}

// bool isTimeFormatValid(String time) {
//   final timePattern = r'^[0-2][0-9]:[0-5][0-9]$';
//   final RegExp regExp = RegExp(timePattern);
//   return regExp.hasMatch(time);
// }
bool isTimeFormatValid(String time) {
  try {
    final parsedTime = DateFormat('HH:mm').parseStrict(time);
    return parsedTime != null;
  } catch (e) {
    return false;
  }
}

generateIntervals(var originalList) {
  List<Availability> resultList = [];

  // Sorting the original list by day and fromTime
  // originalList.sort((a, b) {
  //   int dayComparison = a.day.compareTo(b.day);
  //   if (dayComparison != 0) {
  //     return dayComparison;
  //   } else {
  //     return DateFormat('HH:mm').parse(a.fromTime).compareTo(DateFormat('HH:mm').parse(b.fromTime));
  //   }
  // });

  for (var entry in originalList) {
    String fromTime = entry.fromTime;
    String toTime = entry.toTime;

    if (isTimeFormatValid(fromTime) &&
        isTimeFormatValid(toTime) &&
        fromTime != toTime) {
      DateTime fromDateTime = DateFormat('HH:mm').parse(fromTime);
      DateTime toDateTime = DateFormat('HH:mm').parse(toTime);

      while (fromDateTime.isBefore(toDateTime)) {
        DateTime nextTime = fromDateTime.add(Duration(minutes: 30));
        if (nextTime.isAfter(toDateTime)) {
          nextTime = toDateTime;
        }

        resultList.add(Availability(
          id: entry.id,
          day: entry.day,
          fromTime: DateFormat('HH:mm').format(fromDateTime),
          toTime: DateFormat('HH:mm').format(nextTime),
          teacher: entry.teacher,
        ));

        fromDateTime = nextTime;
      }
    }
  }

  return resultList;
}
