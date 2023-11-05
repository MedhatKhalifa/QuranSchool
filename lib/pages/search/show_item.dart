import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';

import 'package:quranschool/core/db_links/db_links.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/pages/teacher/model/teacher_model.dart';

//  String playerFirstName;
//   String playerLastName;
//   String nationality;
//   String birthday;
//   double height;
//   double weight;
//   String currentCountry;
//   String currentCity;
//   String game;
//   String image;
//   String gender;

Widget showitem(Teacher shownItem) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListTile(
      leading: shownItem.user!.image != ""
          ? Padding(
              padding: EdgeInsets.all(sp(0)),
              child: CachedNetworkImage(
                fit: BoxFit.contain,
                imageUrl: shownItem.user!.image,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            )
          : Icon(
              shownItem.user!.gender == 'male'
                  ? FlutterIslamicIcons.muslim2
                  : FlutterIslamicIcons.muslimah2,
              //  color: Colors.white,
            ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            shownItem.user!.fullName,
            style: TextStyle(color: Color(0xFF707070)),
          ),
          shownItem.about != ""
              ? Text(
                  shownItem.about!,
                  style: TextStyle(color: Color(0xFF707070), fontSize: sp(7)),
                )
              : Text('')
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: Color(0xFFA58223),
          ),
          SizedBox(
            width: w(2),
          ),
          Text(
            shownItem.maxRating.toString(),
          ),
        ],
      ),
    ),
  );
}
