import 'dart:convert';

import 'package:quranschool/pages/Auth/Model/users.dart';

List<Teacher> parseTeachersfromjson(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Teacher>((json) => Teacher.fromJson(json)).toList();
}

List<Teacher> parseTeachersfromListofMap(List<Map<String, dynamic>> jsonList) {
  return jsonList.map<Teacher>((json) => Teacher.fromJson(json)).toList();
}

class Teacher {
  User? user;
  bool? man;
  bool? woman;
  bool? camera;
  bool? memorization;
  bool? tagweed;
  bool? children;
  double? maxRating;
  String? about;
  int? id;

  Teacher(
      {this.user,
      this.man,
      this.woman,
      this.camera,
      this.memorization,
      this.tagweed,
      this.children,
      this.maxRating,
      this.about,
      this.id});

  Teacher.fromJson(Map<String, dynamic> json) {
    user = json['userProfile'] != null
        ? new User.fromJson(json['userProfile'])
        : null;
    man = json['man'] ?? false;
    woman = json['woman'] ?? false;
    camera = json['camera'] ?? false;
    memorization = json['memorization'] ?? false;
    tagweed = json['tagweed'] ?? false;
    children = json['children'] ?? false;
    maxRating = json['maxRating'] ?? -1;
    about = json['about'] ?? "";
    id = json['id'] ?? -1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['man'] = this.man;
    data['woman'] = this.woman;
    data['camera'] = this.camera;
    data['memorization'] = this.memorization;
    data['tagweed'] = this.tagweed;
    data['children'] = this.children;
    data['maxRating'] = this.maxRating;
    data['about'] = this.about;
    data['id'] = this.id;
    return data;
  }
}
