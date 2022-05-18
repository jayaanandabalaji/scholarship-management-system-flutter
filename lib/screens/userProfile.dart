import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scholarships/screens/splash.dart';
import 'package:scholarships/utils/settings.dart';
import 'package:scholarships/widgets/button.dart';

class userProfile extends StatefulWidget {
  const userProfile({Key? key}) : super(key: key);

  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  var _userProfilePic = FirebaseAuth.instance.currentUser!.photoURL;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Profile"),
      ),
      body: ListView(
        padding: EdgeInsets.all(30),
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: (_userProfilePic == null)
                    ? Image.asset("assets/user.png", height: 150)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(150),
                            child: Image.network(
                              _userProfilePic ?? "",
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ))),
              ),
              Container(
                height: 150,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(left: 70, bottom: 10),
                    child: InkWell(
                      onTap: () async {
                        final ImagePicker _picker = ImagePicker();
                        // Pick an image
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (image != null) {
                          final uploadTask = FirebaseStorage.instance
                              .ref()
                              .child("UserProfile/" + image.name)
                              .putFile(File(image.path));
                          uploadTask.snapshotEvents
                              .listen((TaskSnapshot taskSnapshot) async {
                            switch (taskSnapshot.state) {
                              case TaskState.running:
                                final progress = 100.0 *
                                    (taskSnapshot.bytesTransferred /
                                        taskSnapshot.totalBytes);
                                print("Upload is $progress% complete.");
                                break;
                              case TaskState.paused:
                                print("Upload is paused.");
                                break;
                              case TaskState.canceled:
                                print("Upload was canceled");
                                break;
                              case TaskState.error:
                                break;
                              case TaskState.success:
                                var imgeUrl = await FirebaseStorage.instance
                                    .ref()
                                    .child("UserProfile/" + image.name)
                                    .getDownloadURL();
                                log("uploaded");
                                log(imgeUrl);
                                setState(() {
                                  _userProfilePic = imgeUrl;
                                });
                                log("after setstate");
                                log(_userProfilePic ?? "");
                                FirebaseAuth.instance.currentUser!
                                    .updatePhotoURL(
                                        (_userProfilePic) as dynamic);
                                ;
                                break;
                            }
                          });
                        }
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.edit,
                            color: settings.primaryColor,
                          )),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          button(
              buttonText: "Logout",
              OnTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => splashscreen()),
                    (Route<dynamic> route) => route is splashscreen);
              },
              buttonWidth: 0.6)
        ],
      ),
    );
  }
}
