import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';

class ContainerCard extends StatelessWidget {
  final String text;
  final bool isClicked;
  final String variable;
  final IconData myicons;
  ContainerCard(
      {required this.text,
      required this.isClicked,
      required this.variable,
      required this.myicons});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        color: isClicked ? myorangeColor : Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            myicons,
            color: isClicked ? Colors.white : Colors.grey,
            size: sp(30),
          ),
          SizedBox(height: h(1)),
          Text(
            text,
            style: TextStyle(
                fontSize: sp(8), color: isClicked ? Colors.white : Colors.grey),
          ),
        ],
      ),
    );
  }
}
