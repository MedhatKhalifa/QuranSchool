import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/db_links/db_links.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/Auth/controller/login_controller.dart';
import 'package:quranschool/pages/chat/chat_details.dart';
import 'package:quranschool/pages/chat/controller/chat_controller.dart';
import 'package:quranschool/pages/chat/models/studentsubscription_model.dart';
import 'package:quranschool/pages/chat/models/userChat_model.dart';
import 'package:quranschool/pages/common_widget/mybottom_bar/my_bottom_bar.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';

class ShowMyStudent extends StatefulWidget {
  const ShowMyStudent({Key? key}) : super(key: key);

  @override
  State<ShowMyStudent> createState() => _ShowMyStudentState();
}

class _ShowMyStudentState extends State<ShowMyStudent> {
  final ChatController chatController = Get.put(ChatController());
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());

  final LoginController loginController = Get.put(LoginController());

  // Add a TextEditingController for the search query
  final TextEditingController searchController = TextEditingController();

// Function to filter friends based on search query in username or name
  List<StudSubModel> filterFriends(String query) {
    return chatController.studSubdata
        .where((friend) =>
            friend.friendUsername.toLowerCase().contains(query.toLowerCase()) ||
            friend.friendtName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simplAppbar(false, " My Students "),
      body: Column(
        children: [
          // Add a TextField for search
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (query) {
                // Update the list of friends when the search query changes
                chatController.updateFilteredFriends(filterFriends(query));
              },
              decoration: InputDecoration(
                labelText: 'Search by username',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => chatController.isLoading.isTrue
                  ? Center(
                      child: LoadingBouncingGrid.circle(
                        borderColor: mybrowonColor,
                        backgroundColor: Colors.white,
                      ),
                    )
                  : ListView.builder(
                      itemCount: chatController.filteredFriends.length,
                      itemBuilder: (context, index) {
                        print(
                          db_url +
                              chatController.filteredFriends[index].friendImage,
                        );
                        return Card(
                          shadowColor: Colors.green,
                          color: chatController.filteredFriends[index].unreadMsg
                              ? const Color.fromARGB(255, 210, 238, 225)
                              : Colors.white,
                          child: ListTile(
                            onTap: () {
                              loginController.getStudentProfile(chatController
                                  .filteredFriends[index].friendtID);
                            },
                            leading: chatController
                                        .filteredFriends[index].friendImage !=
                                    ""
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      // 'https://quraanshcool.pythonanywhere.com/media/${chatController.filteredFriends[index].friendImage}',
                                      'http://18.156.95.47/media/${chatController.filteredFriends[index].friendImage}',
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: Image.asset(
                                        "assets/images/logo/logo.png",
                                        // width: sp(80),
                                        // height: sp(80),
                                        //color: Colors.red,
                                      ),
                                    ),
                                  ),
                            title: Text(
                              chatController.filteredFriends[index].friendtName,
                              style: TextStyle(
                                color: chatController
                                        .filteredFriends[index].unreadMsg
                                    ? Colors.black
                                    : Colors.grey,
                                fontWeight: chatController
                                        .filteredFriends[index].unreadMsg
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(
                              chatController
                                  .filteredFriends[index].friendUsername,
                              style: TextStyle(
                                color: chatController
                                        .filteredFriends[index].unreadMsg
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.message,
                                color: mybrowonColor,
                              ),
                              onPressed: () {
                                // Handle the button press, e.g., open a chat screen
                                // You can navigate to a new screen or perform any other action here.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatDetail(
                                      friendName: chatController
                                          .filteredFriends[index]
                                          .friendUsername,
                                      friendUid: chatController
                                          .filteredFriends[index].friendtID,
                                      currentuserName: currentUserController
                                          .currentUser.value.username,
                                      currentuserid: currentUserController
                                          .currentUser.value.id
                                          .toString(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MybottomBar(),
    );
  }
}
