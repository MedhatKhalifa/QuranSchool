import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/pages/student/subscription/control/subscription_controller.dart';
import 'package:quranschool/pages/student/subscription/price_list.dart';
import 'package:quranschool/pages/teacher/teacher_avail_show.dart';
import 'package:readmore/readmore.dart';

class DetailSearchTeacher extends StatefulWidget {
  const DetailSearchTeacher({Key? key});

  @override
  State<DetailSearchTeacher> createState() => _DetailSearchTeacherState();
}

class _DetailSearchTeacherState extends State<DetailSearchTeacher> {
  final SubscribitionController subscribitionController =
      Get.put(SubscribitionController());
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background image covering the first 20% of the screen height
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: h(20),
            child: Image.asset(
              'assets/images/back_search.png',
              fit: BoxFit
                  .fill, // Add this line to make the image cover the whole width
              //width: double.infinity, // Add this line to make the image cover the whole width
            ),
          ),

          Positioned(
            top: h(20) - h(6),
            child: CircleAvatar(
              radius: h(6),
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                subscribitionController.selectedTeacher.value.user!.image,
              ),
            ),
          ),

          Positioned(
            top: h(25), // Adjust the vertical position as needed
            left: 0,
            right: 0,
            child: SizedBox(
              height: h(70),
              child: ListView(
                children: [
                  Center(
                      child: Text(
                          subscribitionController
                              .selectedTeacher.value.user!.fullName,
                          style: TextStyle(color: Colors.grey))),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ReadMoreText(
                        subscribitionController.selectedTeacher.value.about!,
                        trimLines: 2,
                        colorClickableText: Colors.black,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'show_more'.tr,
                        trimExpandedText: '.show_less'.tr,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey[50], thickness: sp(1)),
                  ListTile(
                    onTap: () {
                      subscribitionController.getAvaiTime();
                      Get.to(TeacherCalendarShow());
                    },
                    leading: Icon(Icons.calendar_month),
                    title: Text("aval_appoint".tr,
                        style: TextStyle(color: Colors.grey)),
                  ),
                  // Divider(color: Colors.grey[50], thickness: sp(1)),
                  // ListTile(
                  //   onTap: () {},
                  //   leading: Icon(Icons.school),
                  //   title: Text("Academic certificates",
                  //       style: TextStyle(color: Colors.grey)),
                  // ),
                  Divider(color: Colors.grey[50], thickness: sp(1)),
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.star),
                    title: Text("Reviews".tr,
                        style: TextStyle(color: Colors.grey)),
                  ),
                  Divider(color: Colors.grey[50], thickness: sp(1)),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: w(80),
          child: ElevatedButton(
            child: Text('Select'.tr, style: TextStyle(fontSize: sp(17))),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFFFD8C00))),
            onPressed: () async {
              //Get.to(()=>MainProfilePage());
              // buildQueryParams();
              subscribitionController.getSubscribitonList();
              subscribitionController.getAvaiTime();
              // subscribitionController.getSessionsbyteaherID();
              Get.to(() => SessionPriceList());
            },
          ),
        ),
      ),
    );
  }
}
