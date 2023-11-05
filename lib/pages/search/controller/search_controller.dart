import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:quranschool/core/db_links/db_links.dart';

import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';

import 'package:quranschool/pages/search/model/searchwords_model.dart';
import 'package:quranschool/pages/search/show_result.dart';
import 'package:quranschool/pages/teacher/model/teacher_model.dart';

class SearchController1 extends GetxController {
  var totalListLen = 1.obs;
  var currentListLen = 1.obs;
  var from = 0.obs;
  int _step = 800000000;
  var shownItems = [Teacher()].obs;
  var searchWords = SearchWords().obs;
  var bodyMessage = "".obs;
  var statusofSerach = "no_request".obs;
  var man = false.obs;
  var woman = false.obs;
  var camera = false.obs;
  var memorization = false.obs;
  var tagweed = false.obs;
  var children = false.obs;
  var queryparmater = ''.obs;
  var maxRating = -1.obs;
  var teachers = [].obs;
  var agefromlist = List<String>.generate(90, (counter) => "$counter").obs;
  var agetolist = List<String>.generate(90, (counter) => "$counter").obs;

  String _birthfrom = "";
  String _birthto = "";

  var isLoading = false.obs;
  final CurrentUserController userctrl = Get.put(CurrentUserController());

  @override
  void onInit() {
    super.onInit();
  }

  updatedate(range) {}

  Future getdata(bool restartsearch) async {
    try {
      isLoading(true);
      var dio = Dio();

      final now = new DateTime.now();
      totalListLen.value = 0;
      _birthfrom = "";
      _birthto = "";
      if ((searchWords.value.birthdayfrom != "") &
          (searchWords.value.birthdayto != "")) {
        int birthdateYear =
            now.year - int.parse(searchWords.value.birthdayfrom);
        _birthfrom = '${birthdateYear.toString()}-12-31';
        if (searchWords.value.birthdayto == "") {
          searchWords.value.birthdayto = "90";
        }

        int birthdateYear2 = now.year - int.parse(searchWords.value.birthdayto);
        _birthto = '${birthdateYear2.toString()}-01-01';
      }

      var response = await dio.post(
        search_Url,
        data: {
          // 'from': searchWords.value.from.toString(),
          // 'to': (searchWords.value.from + _step).toString(),

          'from': 0.toString(),
          'to': 600000000000.toString(),

          'showType': searchWords.value.accountType,
          'nationality': searchWords.value.nationality,
          'gender': searchWords.value.gender,
          'country': searchWords.value.country,
          'birthdayfrom': _birthto,
          'birthdayto': _birthfrom,
          'game': searchWords.value.game,
          // 'birthdayfrom': "",
          // 'birthdayto': "",
          'searchWord': searchWords.value.searchWord,

          //'gender': 'male',
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 600;
          },
          //headers: {},
        ),
      );

      if (response.statusCode == 200) {
        // searchWords.value.from = searchWords.value.from + _step + 1;
        totalListLen.value = response.data['length'];

        for (var dic in response.data['data'])
        // item.forEach((k, v) {
        //   if (k == "playerId") {
        //     shownItems.add(v);
        //   }
        // }
        {
          // dic = unifyProfileReading(dic);
          shownItems.add(Teacher.fromJson(dic));
        }
        //);
        if (totalListLen.value > 0) {
          searchWords.value.from = totalListLen.value + 1;
          statusofSerach.value = 'result';
        }
        if (totalListLen.value == 0) {
          searchWords.value.from = totalListLen.value + 1;
          statusofSerach.value = 'No_result';
        }
        // _redirectUser();
      } else {
        _failmessage(response);
      }
    } finally {
      isLoading.value = false;
    }
  }

  _failmessage(response) async {
    isLoading(false);
    statusofSerach.value = 'No_result';
    Get.snackbar('${response.statusCode}', 'fetch_failed'.tr,
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
  }

  Future getteacherFilter() async {
    isLoading(true);
    var dio = Dio();
    var response = await dio.get(
      searchTeacherUrl + queryparmater.value,
      //  r'https://quraanshcool.pythonanywhere.com/api/userprofile/check-teacher?man=true&woman=true&camera=true&memorization=true&tagweed=true&children=true',
      options: Options(
        // followRedirects: false,
        validateStatus: (status) {
          return status! < 505;
        },
        //headers: {},
      ),
    );
    // List<Teacher> teachers = [];
    if (response.statusCode == 200) {
      //playerId

      teachers.value = parseTeachersfromListofMap(
          response.data.cast<Map<String, dynamic>>());

      print(teachers.value);
      isLoading.value = false;
      Get.to(const ShowResult());
      // teachers = parseTeachersfromListofMap(response.data);
//       for (var item in response.data)
//       {
// Teacher
//       }
      // item.forEach((k, v) {
      //   if (k == "playerId") {
      //     playeridlist.add(v);
      //   }
      // });

      //_regiuser.playerId = response.data[0]['playerId'];
    } else {
      isLoading.value = false;
      _failmessage(response);
    }
    isLoading.value = false;
    return teachers;
  }
}
