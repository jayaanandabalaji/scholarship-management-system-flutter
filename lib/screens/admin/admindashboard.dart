import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholarships/models/scholarship.dart';
import 'package:scholarships/screens/admin/organizationscholarships.dart';
import 'package:scholarships/screens/firm/add%20scholarship.dart';
import 'package:scholarships/screens/userProfile.dart';
import 'package:scholarships/utils/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/singlescholarship.dart';
import 'package:flutter/material.dart';

class adminDashboard extends StatefulWidget {
  const adminDashboard({Key? key}) : super(key: key);

  @override
  State<adminDashboard> createState() => _adminDashboardState();
}

class _adminDashboardState extends State<adminDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xffF0F5FC),
      body: ListView(children: [
        Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(
                    Icons.account_circle_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => userProfile()));
                  },
                ),
              ),
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            children: [
              (FirebaseAuth.instance.currentUser!.photoURL == null)
                  ? Image.asset(
                      "assets/user.png",
                      height: 70,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: Image.network(
                          FirebaseAuth.instance.currentUser!.photoURL ?? "",
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover),
                    ),
              SizedBox(
                width: 25,
              ),
              Text(
                FirebaseAuth.instance.currentUser!.email!
                    .replaceAll("@gmail.com", ""),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        SizedBox(height: 30),
        Container(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: HSLColor.fromColor(settings.primaryColor)
                                .withLightness(0.55)
                                .toColor()),
                        child: Container(
                          height: 85,
                          width: 85,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('scholarships')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    } else {
                                      return Text(
                                        (snapshot.data!.docs as dynamic)
                                            .length
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
                                      );
                                    }
                                  }),
                              SizedBox(
                                height: 10,
                              ),
                              Flexible(
                                  child: Text(
                                "Available scholarships",
                                style: TextStyle(color: Colors.white),
                              ))
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: HSLColor.fromColor(settings.primaryColor)
                                .withLightness(0.55)
                                .toColor()),
                        child: Container(
                          height: 85,
                          width: 85,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "10",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Flexible(
                                  child: Text(
                                "Students applied",
                                style: TextStyle(color: Colors.white),
                              ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Organizations : ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('firms')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          var docs = snapshot.data?.docs as dynamic;

                          return Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                for (var firm in docs)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  orgScholarships(
                                                      organization: firm)));
                                    },
                                    child: Card(
                                      child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Row(children: [
                                            Image.asset(
                                              "assets/user.png",
                                              height: 60,
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Text(firm["firmName"],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ])),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        })
                  ],
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
              color: settings.primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        )
      ]),
    ));
  }
}
