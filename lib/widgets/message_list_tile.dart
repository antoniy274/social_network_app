import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app/models/chat_model.dart';

class MessageListTile extends StatelessWidget {
  final ChatModel chatModel;
  MessageListTile(this.chatModel);
  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft:Radius.circular(15),
              bottomLeft: chatModel.userID == currentUserID ? Radius.circular(15) : Radius.zero,
              topRight: Radius.circular(15),
              bottomRight: chatModel.userID == currentUserID ? Radius.zero : Radius.circular(15),
            )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 6),
          child: Column(
            crossAxisAlignment: chatModel.userID == currentUserID ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisAlignment: chatModel.userID == currentUserID ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text("By ${chatModel.userName}", style: TextStyle(color: Colors.black),),
              SizedBox(height: 4,),
              Text(chatModel.message, style: TextStyle(color: Colors.black),)
            ],
          ),
        ),),
    );
  }
}



