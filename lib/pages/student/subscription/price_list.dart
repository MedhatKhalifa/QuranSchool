import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/profile/profile_page.dart';
import 'package:quranschool/pages/search/stepper_pages.dart';
import 'package:quranschool/pages/student/subscription/control/subscription_controller.dart';
import 'package:quranschool/pages/student/subscription/teacher_calendar.dart';

class SessionPriceList extends StatefulWidget {
  const SessionPriceList({super.key});

  @override
  State<SessionPriceList> createState() => _SessionPriceListState();
}

class _SessionPriceListState extends State<SessionPriceList> {
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
          () => subscribitionController.isLoadinpricelist.isTrue ||
                  subscribitionController.isLoadingAvail.isTrue
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
                          "Select_Package".tr,
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
                                  color: ((subscribitionController
                                                  .availabilities.length >=
                                              subscribitionController
                                                  .subPriceList[index]
                                                  .sessionCount!) &&
                                          ((subscribitionController
                                                          .subPriceList[index]
                                                          .subscriptionName! ==
                                                      'Free Session' &&
                                                  !currentUserController
                                                      .currentUser
                                                      .value
                                                      .freeSession) ||
                                              (subscribitionController
                                                      .subPriceList[index]
                                                      .subscriptionName! !=
                                                  'Free Session')))
                                      ? Colors.white
                                      : Color.fromARGB(255, 209, 209, 209),
                                  // border: Border.all(color: Colors.red),
                                ),
                                child: ListTile(
                                  trailing: Text(
                                      paymentOption.price.toString() +
                                          " EGP".tr),
                                  title: Text(paymentOption.subscriptionName!),
                                  subtitle: Text(paymentOption.description!),
                                  onTap: () {
                                    var _temp = subscribitionController
                                        .selectedPayement.value;
                                    subscribitionController
                                            .selectedPayement.value =
                                        subscribitionController
                                            .subPriceList[index];
                                    // do that if payement
                                    if ((subscribitionController
                                                .availabilities.length >=
                                            subscribitionController
                                                .subPriceList[index]
                                                .sessionCount!) &&
                                        ((subscribitionController
                                                        .subPriceList[index]
                                                        .subscriptionName! ==
                                                    'Free Session' &&
                                                !currentUserController
                                                    .currentUser
                                                    .value
                                                    .freeSession) ||
                                            (subscribitionController
                                                    .subPriceList[index]
                                                    .subscriptionName! !=
                                                'Free Session'))) {
                                      setState(() {
                                        _selectedPaymentOptionIndex =
                                            index as int;
                                        subscribitionController
                                                .selectedPayement.value =
                                            subscribitionController
                                                .subPriceList[index];
                                      });
                                    } else {
                                      subscribitionController
                                          .selectedPayement.value = _temp;
                                    }
                                  },
                                  leading: Radio(
                                    activeColor: mybrowonColor,
                                    value: index,
                                    groupValue: _selectedPaymentOptionIndex,
                                    onChanged: (value) {
                                      var _temp = subscribitionController
                                          .selectedPayement.value;
                                      subscribitionController
                                              .selectedPayement.value =
                                          subscribitionController
                                              .subPriceList[index];
                                      // do that if payement
                                      if ((subscribitionController
                                                  .availabilities.length >=
                                              subscribitionController
                                                  .subPriceList[index]
                                                  .sessionCount!) &&
                                          ((subscribitionController
                                                          .subPriceList[index]
                                                          .subscriptionName! ==
                                                      'Free Session' &&
                                                  !currentUserController
                                                      .currentUser
                                                      .value
                                                      .freeSession) ||
                                              (subscribitionController
                                                      .subPriceList[index]
                                                      .subscriptionName! !=
                                                  'Free Session'))) {
                                        setState(() {
                                          _selectedPaymentOptionIndex =
                                              value as int;
                                          subscribitionController
                                                  .selectedPayement.value =
                                              subscribitionController
                                                  .subPriceList[index];
                                        });
                                      } else {
                                        subscribitionController
                                            .selectedPayement.value = _temp;
                                      }

                                      // if (subscribitionController
                                      //             .selectedPayement
                                      //             .value
                                      //             .price! ==
                                      //         '0.00' &&
                                      //     !currentUserController
                                      //         .currentUser.value.freeSession) {
                                      //   setState(() {
                                      //     _selectedPaymentOptionIndex =
                                      //         value as int;
                                      //     subscribitionController
                                      //             .selectedPayement.value =
                                      //         subscribitionController
                                      //             .subPriceList[index];
                                      //   });
                                      // }
                                    },
                                  ),
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
        bottomNavigationBar: Obx(
          () => Visibility(
            visible: subscribitionController.isLoadinpricelist.isFalse,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: w(80),
                child: ElevatedButton(
                  child: Text('Select'.tr, style: TextStyle(fontSize: sp(17))),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFFD8C00))),
                  onPressed: () async {
                    if (_selectedPaymentOptionIndex != null) {
                      subscribitionController.selectedMeetings.clear();
                      Get.to(() => CalendarShow());
                    } else {
                      Get.snackbar("Warning".tr, "select_pack_first".tr,
                          colorText: Colors.black);
                    }

                    // buildQueryParams();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
