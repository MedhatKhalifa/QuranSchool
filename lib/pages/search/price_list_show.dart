import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/profile/profile_page.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/search/search_page.dart';
import 'package:quranschool/pages/search/stepper_pages.dart';
import 'package:quranschool/pages/student/subscription/control/subscription_controller.dart';
import 'package:quranschool/pages/search/teacher_calendar.dart';

class PriceShow extends StatefulWidget {
  const PriceShow({super.key});

  @override
  State<PriceShow> createState() => _PriceShowState();
}

class _PriceShowState extends State<PriceShow> {
  int? _selectedPaymentOptionIndex;
  final SubscribitionController subscribitionController =
      Get.put(SubscribitionController());

  var selectedPayement;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              "assets/images/brown_back.png"), // Update with your image path
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Obx(
            () => subscribitionController.isLoadinpricelist.isTrue
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
                : Center(
                    child: ListView(
                      children: [
                        //  mystepper(3),
                        SizedBox(height: h(3)),
                        Center(
                          child: Text(
                            "package_price".tr,
                            //  style: TextStyle(color: Colors.grey)
                          ),
                        ),
                        SizedBox(height: h(2)),
                        Image.asset(
                          "assets/images/logo/logo.png",
                          width: w(45),
                          height: h(25),
                          fit: BoxFit.fitHeight,
                          //color: Colors.red,
                        ),
                        SizedBox(height: sp(5)),
                        SizedBox(
                          height: h(60),
                          child: ListView.builder(
                            itemCount:
                                subscribitionController.subPriceList.length,
                            itemBuilder: (context, index) {
                              // print((subscribitionController.subPriceList[index]
                              //                 .subscriptionName! ==
                              //             'Free Session' &&
                              //         currentUserController
                              //             .currentUser.value.freeSession) ||
                              //     subscribitionController.subPriceList[index]
                              //             .subscriptionName! !=
                              //         'Free Session');

                              final paymentOption =
                                  subscribitionController.subPriceList[index];

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white

                                      // border: Border.all(color: Colors.red),
                                      ),
                                  child: ListTile(
                                    trailing: Text(
                                      paymentOption.price.toString() +
                                          " EGP".tr,
                                      style: TextStyle(
                                          fontSize: sp(11),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    title: Text(
                                        Get.locale?.languageCode == 'ar'
                                            ? paymentOption.subscriptionNameAr!
                                            : paymentOption.subscriptionName!,
                                        style: TextStyle(
                                            fontSize: sp(11),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    subtitle: Text(
                                        Get.locale?.languageCode == 'ar'
                                            ? paymentOption.descriptionAr!
                                            : paymentOption.description!),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                'select_teacher_process'.tr),
                                            content: Text(
                                                'select_teacher_process'.tr),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SearchPage2()),
                                                  );
                                                },
                                                child: Text(
                                                    'go_to_search_page'.tr),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Cancel'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          bottomNavigationBar: MybottomBar()),
    );
  }
}
