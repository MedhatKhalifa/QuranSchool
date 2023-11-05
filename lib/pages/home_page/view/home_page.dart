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
    return Scaffold(
      drawer: Drawer(child: UserProfilePage(showbottombar: false)),
      appBar: simplAppbar(true),
      body: const Center(child: Text('Home')),
      bottomNavigationBar: mybottomBarWidget(),
    );
  }
}
