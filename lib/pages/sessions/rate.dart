import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:quranschool/pages/home_page/view/home_page.dart';
import 'package:quranschool/pages/sessions/controller/session_control.dart';

class RateSession extends StatefulWidget {
  const RateSession({super.key});

  @override
  State<RateSession> createState() => _RateSessionState();
}

class _RateSessionState extends State<RateSession> {
  int rating = 0;
  String comment = '';

  final MySesionController mySesionController = Get.put(MySesionController());
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!mySesionController.feedbackEdit.value) {
      if (currentUserController.currentUser.value.userType == "student") {
        rating = mySesionController.selectedSession.value.studentRate!.toInt();
        comment = mySesionController.selectedSession.value.teacherOpinion!;
      } else if (currentUserController.currentUser.value.userType ==
          "teacher") {
        rating = mySesionController.selectedSession.value.teacherRank!.toInt();
        comment = mySesionController.selectedSession.value.review!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simplAppbar(true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !mySesionController.feedbackEdit.value
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        size: 40,
                        color: Colors.orange,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                        child: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          size: 40,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: 20),
            Text(
              'Comment'.tr,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            !mySesionController.feedbackEdit.value
                ? Text(
                    comment,
                    style: TextStyle(fontSize: 16),
                  )
                : Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          comment = value;
                        });
                      },
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'feedback'.tr,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
            SizedBox(height: 20),
            Visibility(
              visible: mySesionController.feedbackEdit.value,
              child: ElevatedButton(
                onPressed: () {
                  submitFeedback();
                },
                child: Text('Submit'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitFeedback() {
    // You can handle the submitted data here (e.g., send it to a server).

    // For demonstration purposes, we'll print the data.
    print('Rating: $rating');
    print('Comment: $comment');

    currentUserController.currentUser.value.userType == "teacher"
        ? mySesionController.updateSessiondata(
            mySesionController.selectedSession.value.id,
            'Done',
            true,
            rating,
            comment)
        : mySesionController.updateSessiondata(
            mySesionController.selectedSession.value.id,
            'Done',
            null,
            null,
            null,
            true,
            rating,
            comment);
    Get.to(HomePage());

    // You can add further logic here, like displaying a thank you message or navigating to another screen.
  }
}
