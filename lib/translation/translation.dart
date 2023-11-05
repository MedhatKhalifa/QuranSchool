import 'package:quranschool/translation/arabic.dart';
import 'package:quranschool/translation/english.dart';
import 'package:get/get.dart';

class Translate extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en': en, 'ar': ar};
}
