import 'package:flutter/material.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';

class SearchStudent extends StatefulWidget {
  const SearchStudent({super.key});

  @override
  State<SearchStudent> createState() => _SearchStudentState();
}

class _SearchStudentState extends State<SearchStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simplAppbar(false),
      body: Center(child: Text('Search For Your Student')),
      bottomNavigationBar: MybottomBar(),
    );
  }
}
