import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/Auth/controller/sharedpref_function.dart';
import 'package:quranschool/pages/Auth/login/login_page.dart';
import 'package:quranschool/pages/search/stepper_pages.dart';
import 'package:quranschool/pages/student/subscription/control/subscription_controller.dart';
import 'package:quranschool/pages/search/price_list.dart';
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
  bool showtTuorial = true;

  @override
  void initState() {
    // TODO: implement initState
    //initTutorial();

    super.initState();
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        identify: "reviewbutton", // Optional identifier
        keyTarget: reviewbutton, // GlobalKey of the ListTile
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "check_teacher_avail".tr,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        identify: "selectbutton", // Optional identifier
        keyTarget: selectbutton, // GlobalKey of the ListTile
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "next_choose_teacher".tr,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
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
      alignSkip: Alignment.topRight,

      textSkip: "skip_dont_show".tr,
      paddingFocus: 10,
      opacityShadow: 0.8,
      focusAnimationDuration: Duration(milliseconds: 30),
      // imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      // onFinish: () {
      //   print("finish");
      // },
      // onClickTarget: (target) {
      //   print('onClickTarget: $target');
      // },
      // onClickTargetWithTapPosition: (target, tapDetails) {
      //   print("target: $target");
      //   print(
      //       "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      // },
      // onClickOverlay: (target) {
      //   print('onClickOverlay: $target');
      // },
      onSkip: () {
        currentUserController.showTutorial.value.searchteacher = false;
        storeTutorialData(
            currentUserController.showTutorial.value, 'showTutorial');
        return true;
      },
    )..show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return WillPopScope(
      onWillPop: () async {
        if (currentUserController.showTutorial.value.searchteacher) {
          tutorialCoachMark..skip();
        }

        return true; // Do not allow the default back button behavior
      },
      child: Scaffold(
        body: Obx(
          () {
            if (subscribitionController.isLoadingAvail.isFalse &&
                showtTuorial &&
                currentUserController.showTutorial.value.searchteacher) {
              initTutorial();
              showtTuorial = false;
            }
            return (subscribitionController.isLoadingAvail.isTrue ||
                    subscribitionController.isLoadingmeetings.isTrue)
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
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Color(0xFFA58223),
                                    ),
                                    SizedBox(
                                      width: w(2),
                                    ),
                                    Text(subscribitionController
                                        .selectedTeacher.value.maxRating
                                        .toString()),
                                  ],
                                ),
                                title: Text("Reviews".tr,
                                    style: TextStyle(color: Colors.grey)),
                              ),
                              Divider(color: Colors.grey[50], thickness: sp(1)),
                              ExpansionTile(
                                textColor: Colors.grey,
                                initiallyExpanded: true,
                                title: Center(
                                  child: Text(
                                      Get.locale?.languageCode == 'ar'
                                          ? 'ملخص السيرة'
                                          : 'Summary',
                                      style: TextStyle(color: Colors.black)),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        Get.locale?.languageCode == 'ar'
                                            ? subscribitionController
                                                .selectedTeacher.value.aboutAr!
                                            : subscribitionController
                                                .selectedTeacher.value.about!,
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                  SizedBox(height: h(5)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
          },
        ),
        bottomNavigationBar: Obx(
          () => (subscribitionController.isLoadingAvail.isTrue ||
                  subscribitionController.isLoadingmeetings.isTrue)
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
                          if (subscribitionController.meetings.length > 0) {
                            // subscribitionController.getAvaiTime();
                            subscribitionController.getSubscribitonList();
                            Get.to(() => SessionPriceList());
                          } else {
                            Get.snackbar(
                              'Warning'.tr,
                              'No_free_slots_teacher'.tr,
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
      ),
    );
  }
}

class StarRatingWidget extends StatelessWidget {
  final int maxRating;

  StarRatingWidget({required this.maxRating});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: maxRating,
      itemBuilder: (context, index) {
        return Icon(
          Icons.star,
          color: Colors.yellow,
        );
      },
    );
  }
}
