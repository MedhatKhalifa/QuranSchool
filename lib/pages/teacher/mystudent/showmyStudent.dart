import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:quranschool/core/theme.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:quranschool/pages/Auth/controller/login_controller.dart';
import 'package:quranschool/pages/chat/chat_details.dart';
import 'package:quranschool/pages/chat/controller/chat_controller.dart';
import 'package:quranschool/pages/chat/models/studentsubscription_model.dart';
import 'package:quranschool/pages/chat/models/userChat_model.dart';
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
      appBar: simplAppbar(true, " My Students "),
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
                        return Card(
                          child: ListTile(
                            onTap: () {
                              loginController.getStudentProfile(chatController
                                  .filteredFriends[index].friendtID);
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                chatController
                                    .filteredFriends[index].friendImage,
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
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
