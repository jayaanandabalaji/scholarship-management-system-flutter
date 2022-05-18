import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholarships/utils/settings.dart';

class scholarshipApplicants extends StatefulWidget {
  final scholarship;
  final scholarshipId;
  const scholarshipApplicants(
      {required this.scholarship, required this.scholarshipId});

  @override
  State<scholarshipApplicants> createState() => _scholarshipApplicantsState();
}

class _scholarshipApplicantsState extends State<scholarshipApplicants> {
  var index = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Applicants"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text(
            widget.scholarship["title"],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('applications')
                      .where("scholarshipId", isEqualTo: widget.scholarshipId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      return Column(
                        children: [
                          for (var applicant in snapshot.data!.docs)
                            Container(
                              color: Colors.white,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => Dialog(
                                            child: Container(
                                              height: 300,
                                              padding: EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    "assets/user.png",
                                                    height: 80,
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  StreamBuilder<QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "students")
                                                          .where("id",
                                                              isEqualTo:
                                                                  applicant[
                                                                      "userId"])
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return CircularProgressIndicator();
                                                        } else {
                                                          return Column(
                                                            children: [
                                                              Text(
                                                                applicant[
                                                                    "name"],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Family Income: ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    snapshot.data!
                                                                            .docs[0]
                                                                        [
                                                                        "income"],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        color: settings
                                                                            .primaryColor),
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Age: ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Text(
                                                                    snapshot
                                                                        .data!
                                                                        .docs[0]
                                                                            [
                                                                            "age"]
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        color: settings
                                                                            .primaryColor),
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Email: ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        if (!await launchUrl(
                                                                            Uri.parse("mailto:${applicant["name"]}@gmail.com")))
                                                                          throw 'Could not launch';
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        applicant["name"] +
                                                                            "@gmail.com",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                17,
                                                                            color:
                                                                                settings.primaryColor),
                                                                      ))
                                                                ],
                                                              )
                                                            ],
                                                          );
                                                        }
                                                      })
                                                ],
                                              ),
                                            ),
                                          ));
                                },
                                child: Card(
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${index++}.",
                                          style: TextStyle(
                                              color: settings.primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Image.asset(
                                          "assets/user.png",
                                          height: 50,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(applicant["name"],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      );
                    }
                  })
            ],
          )
        ],
      ),
    );
  }
}
