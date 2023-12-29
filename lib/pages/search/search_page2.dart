import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/Auth/controller/login_controller.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/bottom_bar_controller.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:quranschool/pages/search/filter_containers.dart';
import 'package:quranschool/pages/search/show_item.dart';
import 'package:quranschool/pages/teacher/model/teacher_model.dart';
import 'package:search_choices/search_choices.dart';

import 'package:quranschool/core/size_config.dart';

import 'package:quranschool/pages/search/controller/search_controller.dart';
import 'package:quranschool/pages/search/model/searchwords_model.dart';
import 'package:intl/intl.dart';

class SearchPage2 extends StatefulWidget {
  @override
  _SearchPage2State createState() => _SearchPage2State();
}

class _SearchPage2State extends State<SearchPage2> {
  // define variable
  final SearchController1 searchController = Get.put(SearchController1());
  final LoginController loginController = Get.put(LoginController());
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());
  final TextEditingController controller = TextEditingController();
  final scrollController = ScrollController();
  // for date and time
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();

  ///
  /// filter Containers
  ///
  List<bool> containerClicked = List.generate(6, (index) => false);

  List<String> containerText = [
    'man',
    'woman',
    'children',
    'Camera',
    'memorization',
    'tagweed',
    // 'maxrate',
  ];

  Map<String, bool> containerState = {};
  List<IconData> myicons = [
    FlutterIslamicIcons.muslim2,
    FlutterIslamicIcons.muslimah2,
    FontAwesomeIcons.children,
    FontAwesomeIcons.video,
    FontAwesomeIcons.headSideVirus,
    FlutterIslamicIcons.quran2,
  ];

  List<String> containerVariables = List.generate(6, (index) => '');

  void handleContainerClick(int index) {
    setState(() {
      containerClicked[index] = !containerClicked[index];
      if (containerClicked[index]) {
        // Perform an action when a container is clicked
        if (index == 0) {
          print('man');
        } else if (index == 1) {
          print('woman');
        }
        containerVariables[index] = 'Clicked';
      } else {
        // Perform a different action when a container is unclicked
        containerVariables[index] = 'Unclicked';
        if (index == 0) {
          print('not man');
        } else if (index == 1) {
          print('not woman');
        }
      }
    });
  }

  //////
  final MyBottomBarCtrl myBottomBarCtrl = Get.put(MyBottomBarCtrl());

  bool isSearching = false;
  String _search_text = '';

  final _formKey = GlobalKey<FormState>();
  // Inital state
  void initState() {
    //searchController.getdata();
    // scrollController.addListener(() {
    //   if (scrollController.position.pixels ==
    //       scrollController.position.maxScrollExtent) {
    //     if (searchController.from.value < searchController.totalListLen.value) {
    //       searchController.getdata(false);
    //     }

    //     //return state.products;
    //   }
    // });

    // Initialize the container state map
    for (String text in containerText) {
      containerState[text] = false;
    }
    dateinput.text = ""; //set the initial value of text field
    timeinput.text = ""; //set the initial value of text field
    super.initState();
  }

  void toggleContainerState(String text, index) {
    setState(() {
      containerClicked[index] = !containerClicked[index];
      containerState[text] = !containerState[text]!;
    });
  }

  String buildQueryParams() {
    List<String> queryParams = [];
    if (searchController.searchWords.value.searchWord != "") {
      queryParams
          .add("fullName=" + searchController.searchWords.value.searchWord);
    }
    for (int index = 0; index < containerText.length; index++) {
      String text = containerText[index];
      bool clicked = containerClicked[index];

      if (clicked) {
        // Do something with the text when containerClicked is true
        queryParams.add('$text=${containerState[text]}');
      }
    }

    // for (String text in containerText  containerClicked[index]) {
    //   queryParams.add('$text=${containerState[text]}');
    // }
    print(queryParams.join('&'));
    return queryParams.join('&');
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  ///////////////////

  String searchQuery = "Search query";

  ////////////////////

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        // Override the back button behavior to navigate to a specific page, e.g., '/home'
        myBottomBarCtrl.selectedIndBottomBar.value = 0;
        Get.to(HomePage());
        return false; // Do not allow the default back button behavior
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,

        ///=======================================================================
        ///==================== Body ========================================
        ///=======================================================================

        //drawer: Thedrawer(),
        //backgroundColor: Colors.transparent,
        appBar: simplAppbar(false, "search_teacher".tr),

        ///=======================================================================
        ///==================== Body ========================================
        ///=======================================================================

        body: Obx(
          () => Container(
            //height: h(7),
            color: Color.fromARGB(99, 209, 200, 182),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(sp(8)),
                  width: w(97),
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    controller: TextEditingController(
                        text:
                            searchController.searchWords.value.searchWord != ""
                                ? searchController.searchWords.value.searchWord
                                : ""),
                    // controller: _filter,
                    onChanged: (value) {
                      searchController.searchWords.value.searchWord = value;
                      searchController.from.value = 0;
                      searchController.shownItems.value = [Teacher()];
                      //searchController.getdata(false);
                      // buildQueryParams();
                    },

                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.blueGrey,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText:
                            searchController.searchWords.value.searchWord != ""
                                ? searchController.searchWords.value.searchWord
                                : "Search_hint".tr,
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        )),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: h(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(sp(10))),
                            padding: EdgeInsets.all(15),
                            //height: 150,
                            child: Center(
                                child: TextField(
                              controller:
                                  dateinput, //editing controller of this TextField
                              decoration: InputDecoration(
                                  icon: Icon(Icons
                                      .calendar_today), //icon of text field
                                  hintText: "date".tr //label text of field
                                  ),
                              readOnly:
                                  true, //set it true, so that user will not able to edit text
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(
                                        2000), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2101));

                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  //you can implement different kind of Date Format here according to your requirement

                                  setState(() {
                                    dateinput.text =
                                        formattedDate; //set output date to TextField value.
                                  });
                                } else {
                                  print("Date is not selected");
                                }
                              },
                            ))),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: h(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(sp(10))),
                            padding: EdgeInsets.all(15),
                            child: Center(
                                child: TextField(
                              controller:
                                  timeinput, //editing controller of this TextField
                              decoration: InputDecoration(
                                  icon: Icon(Icons.timer), //icon of text field
                                  hintText: "Time".tr //label text of field
                                  ),
                              readOnly:
                                  true, //set it true, so that user will not able to edit text
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );

                                if (pickedTime != null) {
                                  print(pickedTime
                                      .format(context)); //output 10:51 PM
                                  DateTime parsedTime = DateFormat.jm().parse(
                                      pickedTime.format(context).toString());
                                  //converting to DateTime so that we can further format on different pattern.
                                  print(
                                      parsedTime); //output 1970-01-01 22:53:00.000
                                  String formattedTime =
                                      DateFormat('HH:mm:ss').format(parsedTime);
                                  print(formattedTime); //output 14:59:00
                                  //DateFormat() is from intl package, you can format the time on any pattern you need.

                                  setState(() {
                                    timeinput.text =
                                        formattedTime; //set the value of text field.
                                  });
                                } else {
                                  print("Time is not selected");
                                }
                              },
                            ))),
                      ),
                    )
                  ],
                ),
                Obx(
                  () => searchController.isLoading.isTrue
                      ? LoadingFlipping.circle(
                          // borderColor: clickIconColor,
                          borderSize: 3.0,
                          size: sp(20),
                          // backgroundColor: Color(0xff112A04),
                          duration: Duration(milliseconds: 500),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: w(90),
                            child: ElevatedButton(
                              child: Text('search'.tr,
                                  style: TextStyle(fontSize: sp(17))),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFFFD8C00))),
                              onPressed: () async {
                                //Get.to(()=>MainProfilePage());
                                // buildQueryParams();
                                searchController.queryparmater.value =
                                    (buildQueryParams());
                                searchController.getteacherFilter();
                                loginController.checkFreeSession(
                                    currentUserController.currentUser.value.id);
                              },
                            ),
                          ),
                        ),
                ),
                Text('filter'.tr),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          toggleContainerState(containerText[index], index);
                          // handleContainerClick(index);
                          searchController.queryparmater.value =
                              (buildQueryParams());
                          print(searchController.queryparmater.value);
                        },
                        child: SizedBox(
                          height: h(10),
                          child: ContainerCard(
                            text: containerText[index].tr,
                            isClicked: containerClicked[index],
                            variable: containerVariables[index],
                            myicons: myicons[index],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: MybottomBar(),
      ),
    );
  }
}
