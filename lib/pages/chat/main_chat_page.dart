import 'package:flutter/material.dart';
import 'package:quranschool/pages/chat/people_list.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';

class MainChatPage extends StatefulWidget {
  const MainChatPage({Key? key}) : super(key: key);

  @override
  State<MainChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simplAppbar(true, " Chat List "),
      body: PeopleList(),
    );
  }
}
