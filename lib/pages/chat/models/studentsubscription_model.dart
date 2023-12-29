import 'package:get/get.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';

List<StudSubModel> studSubModelfromListofMap(
    List<Map<String, dynamic>> jsonList) {
  return jsonList
      .map<StudSubModel>((json) => StudSubModel.fromJson(json))
      .toList();
}

final CurrentUserController currentUserController =
    Get.put(CurrentUserController());

class StudSubModel {
  StudSubModel({
    required this.teacherID,
    required this.teacherUsername,
    required this.teacherName,
    required this.teacherImage,
    required this.studentSubscriptionStatus,
    required this.studentID,
    required this.studentUsername,
    required this.studentName,
    required this.studentImage,
    required this.friendtID,
    required this.friendUsername,
    required this.friendtName,
    required this.friendImage,
    required this.unreadMsg,
    required this.remainingSessions,
  });
  late final String teacherID;
  late final String teacherUsername;
  late final String teacherName;
  late final String teacherImage;
  late final String studentSubscriptionStatus;
  late final String studentID;
  late final String studentUsername;
  late final String studentName;
  late final String studentImage;
  late final String friendtID;
  late final String friendUsername;
  late final String friendtName;
  late final String friendImage;
  late final int remainingSessions;
  bool unreadMsg = false;

  StudSubModel.fromJson(Map<String, dynamic> json) {
    teacherID = json['teacherID'] ?? "";
    teacherUsername = json['teacherUsername'] ?? "";
    teacherName = json['teacherName'] ?? "";
    teacherImage = json['teacherImage'];
    studentSubscriptionStatus = json['studentSubscriptionStatus'] ?? "";
    studentID = json['studentID'] ?? "";
    studentUsername = json['studentUsername'] ?? "";
    studentName = json['studentName'] ?? "";
    studentImage = json['studentImage'] ?? "";
    remainingSessions = json['remainingSessions'] ?? 0;

    friendtID = currentUserController.currentUser.value.userType != "student"
        ? json['studentID'] ?? ""
        : json['teacherID'] ?? "";
    friendUsername =
        currentUserController.currentUser.value.userType != "student"
            ? json['studentUsername'] ?? ""
            : json['teacherUsername'] ?? "";
    friendtName = currentUserController.currentUser.value.userType != "student"
        ? json['studentName'] ?? ""
        : json['teacherName'] ?? "";
    friendImage = currentUserController.currentUser.value.userType != "student"
        ? json['studentImage'] ?? ""
        : json['teacherImage'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['teacherID'] = teacherID;
    _data['teacherUsername'] = teacherUsername;
    _data['teacherName'] = teacherName;
    _data['teacherImage'] = teacherImage;
    _data['studentSubscriptionStatus'] = studentSubscriptionStatus;
    _data['studentID'] = studentID;
    _data['studentUsername'] = studentUsername;
    _data['studentName'] = studentName;
    _data['studentImage'] = studentImage;
    return _data;
  }
}
