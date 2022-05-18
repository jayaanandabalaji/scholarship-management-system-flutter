import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholarships/models/scholarship.dart';
import 'package:scholarships/screens/firm/add%20scholarship.dart';
import 'package:scholarships/screens/userProfile.dart';
import 'package:scholarships/utils/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/singlescholarship.dart';

class firmDashboard extends StatefulWidget {
  const firmDashboard({Key? key}) : super(key: key);

  @override
  State<firmDashboard> createState() => _firmDashboardState();
}

Future getRole() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var role = prefs.getString("role");
  return role;
}

class _firmDashboardState extends State<firmDashboard> {
  var role;
  @override
  void initState() {
    super.initState();
    getRole().then((value) => role = value);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xffF0F5FC),
      floatingActionButton: FloatingActionButton(
        backgroundColor: settings.primaryColor,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => addScholarship()));
        },
        child: Icon(Icons.add),
      ),
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
                                      .where("organizationId",
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser!.uid)
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
                                "Scholarships given",
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
                      "Your scholarships : ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('scholarships')
                            .where("organizationId",
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
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
                                for (var scholarship in docs)
                                  singleScholarship(
                                    scholarship: scholarship,
                                    scholarshipId: scholarship.id,
                                    role: role,
                                  )
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
