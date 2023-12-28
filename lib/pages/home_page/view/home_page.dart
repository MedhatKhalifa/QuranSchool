import 'dart:io';

import 'package:get/get.dart';
import 'package:quranschool/pages/Auth/profile/profile_page.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('sure_exit'.tr),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'.tr),
              ),
              TextButton(
                onPressed: () => exit(0), // Navigator.of(context).pop(true),
                child: Text('Yes'.tr),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        drawer: Drawer(child: UserProfilePage(showbottombar: false)),
        //appBar: simplAppbar(true),
        body: UserProfilePage(showbottombar: false),
        bottomNavigationBar: MybottomBar(),
      ),
    );
  }
}
