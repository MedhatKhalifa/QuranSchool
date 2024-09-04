import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';

import 'package:quranschool/core/db_links/db_links.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/pages/student/subscription/control/subscription_controller.dart';
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
              child: Container(
                width: w(18), // Set relative width
                height: w(22), // Set relative height
                child: ClipOval(
                  child: CachedNetworkImage(
                    fit: BoxFit
                        .cover, // Ensures the image fits inside the circle
                    imageUrl: shownItem.user!.image,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
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
          Text(
            Get.locale?.languageCode == 'ar'
                ? shownItem.aboutAr!
                : shownItem.about!,
            style: TextStyle(color: Color(0xFF707070), fontSize: sp(7)),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )
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
