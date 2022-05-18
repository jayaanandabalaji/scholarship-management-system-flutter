import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholarships/screens/admin/admindashboard.dart';
import 'package:scholarships/screens/firm/firmDashboard.dart';
import 'package:scholarships/screens/login.dart';
import 'package:scholarships/screens/register.dart';
import 'package:scholarships/screens/student/studentDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({Key? key}) : super(key: key);

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  Future getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var role = prefs.getString("role");
    return role;
  }

  @override
  void initState() {
    super.initState();
    getRole().then((role) {
      Future.microtask(
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => (FirebaseAuth.instance.currentUser == null)
                  ? registerScreen()
                  : (role == "Organization")
                      ? firmDashboard()
                      : (role == "admin")
                          ? adminDashboard()
                          : studentDashboard())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/logo.png",
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    ));
  }
}
