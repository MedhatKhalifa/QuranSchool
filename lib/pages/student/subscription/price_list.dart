import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/core/theme.dart';
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
                      SizedBox(height: h(3)),
                      Center(
                        child: Text(
                          "Select Your Package",
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
                            final paymentOption =
                                subscribitionController.subPriceList[index];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  // border: Border.all(color: Colors.red),
                                ),
                                child: ListTile(
                                  trailing: Text(
                                      paymentOption.price.toString() + " EGP"),
                                  title: Text(paymentOption.subscriptionName!),
                                  subtitle: Text(paymentOption.description!),
                                  leading: Radio(
                                    activeColor: mybrowonColor,
                                    value: index,
                                    groupValue: _selectedPaymentOptionIndex,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedPaymentOptionIndex =
                                            value as int;
                                        subscribitionController
                                                .selectedPayement.value =
                                            subscribitionController
                                                .subPriceList[index];
                                      });
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
                      Get.snackbar("Warning", "Please Select Package First",
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
