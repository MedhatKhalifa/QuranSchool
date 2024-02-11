import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/Auth/login/login_page.dart';
import 'package:quranschool/pages/search/stepper_pages.dart';
import 'package:quranschool/pages/student/subscription/control/subscription_controller.dart';
import 'package:quranschool/pages/student/subscription/price_list.dart';
import 'package:quranschool/pages/teacher/teacher_avail_show.dart';
import 'package:readmore/readmore.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class DetailSearchTeacher extends StatefulWidget {
  const DetailSearchTeacher({Key? key});

  @override
  State<DetailSearchTeacher> createState() => _DetailSearchTeacherState();
}

class _DetailSearchTeacherState extends State<DetailSearchTeacher> {
  final SubscribitionController subscribitionController =
      Get.put(SubscribitionController());
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

  late TutorialCoachMark tutorialCoachMark;
  final reviewbutton = GlobalKey();
  final selectbutton = GlobalKey();
  TutorialCoachMark? tutorial;

  @override
  void initState() {
    // TODO: implement initState
    initTutorial();

    super.initState();
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "reviewbutton", // Optional identifier
        keyTarget: reviewbutton, // GlobalKey of the ListTile
        contents: [
          TargetContent(),
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "selectbutton", // Optional identifier
        keyTarget: selectbutton, // GlobalKey of the ListTile
        contents: [
          TargetContent(),
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );

    return targets;
  }

  void initTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: mybrowonColor,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.5,
      focusAnimationDuration: Duration(milliseconds: 30),
      // imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
        return true;
      },
    )..show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Obx(
        () {
          initTutorial();
          return subscribitionController.isLoadingAvail.isTrue
              ? Center(
                  child: LoadingBouncingGrid.circle(
                    borderColor: mybrowonColor,
                    backgroundColor: Colors.white,
                    // borderSize: 3.0,
                    // size: sp(20),
                    // backgroundColor: Color(0xff112A04),
                    //  duration: Duration(milliseconds: 500),
                  ),
                )
              : Stack(
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
                          subscribitionController
                              .selectedTeacher.value.user!.image,
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
                            //mystepper(2),
                            Center(
                                child: Text(
                                    subscribitionController
                                        .selectedTeacher.value.user!.fullName,
                                    style: TextStyle(color: Colors.grey))),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ReadMoreText(
                                  subscribitionController
                                      .selectedTeacher.value.about!,
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
                              key: reviewbutton,
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
                );
        },
      ),
      bottomNavigationBar: Obx(
        () => subscribitionController.isLoadingAvail.isTrue
            ? Text('')
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: w(80),
                  child: ElevatedButton(
                    key: selectbutton,
                    child: Text(
                        currentUserController.currentUser.value.id != -1
                            ? 'Select'.tr
                            : "login".tr,
                        style: TextStyle(fontSize: sp(17))),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFFFD8C00))),
                    onPressed: () async {
                      //Get.to(()=>MainProfilePage());
                      // buildQueryParams();
                      if (currentUserController.currentUser.value.id != -1) {
                        if (subscribitionController.availabilities.length > 0) {
                          // subscribitionController.getAvaiTime();
                          subscribitionController.getSubscribitonList();
                          Get.to(() => SessionPriceList());
                        } else {
                          Get.snackbar(
                            'Warning',
                            'No free slots available. The teacher will not be available for the next three months.',
                            backgroundColor: Colors
                                .orange, // Set the background color for a warning.
                            colorText: Colors
                                .white, // Set the text color for better visibility.
                          );
                        }

                        // subscribitionController.getSessionsbyteaherID();
                      } else {
                        Get.to(() => LoginPage());
                      }
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
