import 'package:quranschool/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:quranschool/core/size_config.dart';

simplAppbar(bool showbackbutton, [String? tilte]) {
  return AppBar(
    automaticallyImplyLeading: showbackbutton,

    backgroundColor: Colors.transparent,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/appbar.png'),
          fit: BoxFit.fill,
        ),
        // gradient: LinearGradient(
        //   begin: Alignment.center,
        //   end: Alignment.bottomLeft,
        //   colors: [
        //     Color.fromARGB(255, 166, 127, 36),
        //     Color.fromARGB(255, 173, 149, 85),
        //     Color.fromARGB(255, 160, 119, 37),
        //     Color.fromARGB(255, 160, 119, 37),
        //   ],
        // ),
      ),
    ),
    //elevation: 0, // 2
    title: Text(
      tilte ?? "",
      style: TextStyle(fontSize: sp(10)),
    ),
    centerTitle: true,
  );
}
