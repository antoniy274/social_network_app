import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreatePostScreen extends StatefulWidget {
  static const String id = "create_post_screen";

  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String _description = "";

  Future<void> _submit({required File image}) async{
    FocusScope.of(context).unfocus();
    if(_description.trim().isNotEmpty){
      late String imageUrl;
      //Write image to storage
      FirebaseStorage storage = FirebaseStorage.instance;
      await storage
          .ref("images/${UniqueKey().toString()}.png")
          .putFile(image)
          .then((taskSnapshot) async {
        imageUrl = await taskSnapshot.ref.getDownloadURL();
      });

      FirebaseFirestore.instance.collection("posts").add({
        "timestamp" : Timestamp.now(),
        "userID" : FirebaseAuth.instance.currentUser!.uid,
        "description": _description,
        "userName": FirebaseAuth.instance.currentUser!.displayName,
        "imageURL": imageUrl,
      }).then((docRef) => docRef.update({"postID" : docRef.id}));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final File imageFile = ModalRoute.of(context)!.settings.arguments as File;

    return Scaffold(
      appBar: AppBar(title: Text("Create Post"),),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
          },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width / 1.4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(image: FileImage(imageFile),
                  fit: BoxFit.cover
                  )
                ),
                ),
                TextField(
                  decoration: InputDecoration(hintText: "Enter a discription"),
                  textInputAction: TextInputAction.done,
                  inputFormatters: [LengthLimitingTextInputFormatter(255),],
                  onChanged: (value){
                    _description = value;
                  },
                  onEditingComplete: (){
                    _submit(image: imageFile);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
