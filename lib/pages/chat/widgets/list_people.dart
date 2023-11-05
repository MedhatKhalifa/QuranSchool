import 'package:flutter/material.dart';

import '../models/userChat_model.dart';

class ChatBodyWidget extends StatelessWidget {
  final dynamic? UserChats;

  const ChatBodyWidget({
    required this.UserChats,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: buildChats(),
        ),
      );

  Widget buildChats() => ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final UserChat = UserChats[index];

          return Container(
            height: 75,
            child: ListTile(
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => ChatPage(UserChat: UserChat),
                // ));
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(UserChat.image),
              ),
              title: Text(UserChat.name),
            ),
          );
        },
        itemCount: UserChats.docs.length,
      );
}
