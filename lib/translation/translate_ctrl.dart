import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Translatectrl extends GetxController {
  var appLang = 'ar'.obs;

  @override
  void onInit() {
    super.onInit();
    checkstoredlang();
  }

  void checkstoredlang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appLang.value = prefs.getString('appLang') ?? 'ar';
    await prefs.setString('appLang', appLang.value);
  }
}
