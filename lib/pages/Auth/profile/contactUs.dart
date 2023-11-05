import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widget/mybottom_bar/my_bottom_bar.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simplAppbar(true),
      body: Center(
        child: Text('Tel_010000000'.tr),
      ),
      bottomNavigationBar: mybottomBarWidget(),
    );
  }
}
