import 'package:get/get.dart';
import 'package:quranschool/core/db_links/db_links.dart';
import 'package:quranschool/pages/home_page/model/homepage_model.dart';
import 'package:dio/dio.dart';

class HomePageController extends GetxController {
  // Just this currentuser fetch User Model

  var homePage = HomePageModel().obs;
  var isLoading = false.obs;

  Future getHomePageData() async {
    try {
      isLoading(true);

      var dio = Dio();

      var response = await dio.get(
        homePage_url,
        options: Options(
          followRedirects: false,

          validateStatus: (status) {
            return status! < 600;
          },

          //headers: {},
        ),
      );

      if (response.statusCode == 200) {
        // READ HOME PAGE DATA
        homePage.value = HomePageModel.fromJson(response.data);
      } else {
        // try to load data from storage
      }
    } finally {
      isLoading.value = false;
    }
  }
}
