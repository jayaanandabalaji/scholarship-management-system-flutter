import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholarships/main.dart';
import 'package:scholarships/models/applications.dart';
import 'package:scholarships/models/scholarship.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:scholarships/utils/settings.dart';
import 'package:scholarships/widgets/button.dart';
import 'package:scholarships/widgets/notify.dart';
import 'package:shared_preferences/shared_preferences.dart';

class scholarshipDetails extends StatefulWidget {
  final Scholarship;
  final scholarShipId;
  const scholarshipDetails(this.Scholarship, this.scholarShipId);
  @override
  State<scholarshipDetails> createState() => _scholarshipDetailsState();
}

class _scholarshipDetailsState extends State<scholarshipDetails> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    quill.QuillController _controller = quill.QuillController(
      document: quill.Document.fromJson(
          jsonDecode(widget.Scholarship["description"])),
      selection: TextSelection.collapsed(offset: 0),
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.Scholarship["title"]),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: ListView(
              children: [
                Image.network(
                  widget.Scholarship["imageUrl"],
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Scholarship details",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      quill.QuillEditor(
                        controller: _controller,
                        showCursor: false,
                        expands: false,
                        focusNode: FocusNode(),
                        scrollable: true,
                        padding: EdgeInsets.all(0),
                        scrollController: ScrollController(),
                        autoFocus: false,
                        readOnly: true, // true for view only mode
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.date_range),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Apply before"),
                                ],
                              ),
                              Text(
                                widget.Scholarship["applicationDeadline"],
                                style: TextStyle(
                                    color: settings.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/user.png",
                            height: 60,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Organization : ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.Scholarship["organization"],
                                style: TextStyle(
                                    color: settings.primaryColor, fontSize: 17),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Center(
            child: button(
                buttonText: "Apply Now",
                OnTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Apply for scholarship"),
                        content: Text(
                            "Are you sure, do you want to apply for this scholarship? You personal details will be shared with the organization."),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              showLoaderDialog(this.context, "Applying");
                              CollectionReference collection = FirebaseFirestore
                                  .instance
                                  .collection("applications");
                              log("applying");
                              log(widget.scholarShipId);
                              log(FirebaseAuth.instance.currentUser!.uid);
                              log(FirebaseAuth.instance.currentUser!.email!
                                  .replaceAll("@gmail.com", ""));
                              await collection.add(application(
                                      userId: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      scholarshipId: widget.scholarShipId,
                                      name: FirebaseAuth
                                          .instance.currentUser!.email!
                                          .replaceAll("@gmail.com", ""))
                                  .toJson());
                              log("applied");
                              Navigator.pop(this.context);
                              _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                  content: Text("Applied successfully...")));
                            },
                            child: Text("Yes"),
                          ),
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    },
                  );
                },
                buttonWidth: 0.6),
          ))
        ],
      ),
    );
  }
}
