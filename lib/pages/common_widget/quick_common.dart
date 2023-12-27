import 'package:flutter/material.dart';

class NewMessageIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(Icons.people), // Replace with your desired icon
        Positioned(
          right: -2,
          top: -2,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.green, // Change the color as needed
            ),
          ),
        ),
      ],
    );
  }
}
