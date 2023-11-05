import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/mybottom_bar/my_bottom_bar.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simplAppbar(true),
      body: Center(
        child: Text('Quran School'.tr),
      ),
      bottomNavigationBar: mybottomBarWidget(),
    );
  }
}
