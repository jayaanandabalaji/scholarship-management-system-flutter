import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import '../models/firm.dart';
import '../models/students.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  String role = "";
  final FirebaseAuth auth = FirebaseAuth.instance;
  handleSignInEmail(String email, String password) async {
    var user;
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user!;
      User firebaseuser = user;

      FirebaseFirestore.instance
          .collection('students')
          .where('id', isEqualTo: firebaseuser.uid)
          .snapshots()
          .listen((QuerySnapshot querySnapshot) {
        log("length : " + querySnapshot.docs.length.toString());
        if (querySnapshot.docs.length == 1) {
          log("inside if");
          role = "student";
        }
        log("outside if");
      });
      if (role == "") {
        FirebaseFirestore.instance
            .collection('firms')
            .where('id', isEqualTo: firebaseuser.uid)
            .snapshots()
            .listen((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.length > 0) {
            role = "Organization";
          }
        });
      }
      await Future.delayed(Duration(milliseconds: 2000), () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        log("storing role");
        log("Role : " + role);
        await prefs.setString('role', role);
      });
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    log("returned");
    return user;
  }

  FirebaseSignUp(email, password) async {
    var user;
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = result.user!;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return user;
  }

  firmSignUp(email, password, name) async {
    final firebaseuser = await FirebaseSignUp(email, password);
    if (firebaseuser.runtimeType == String) {
    } else {
      User user = firebaseuser as dynamic;

      final CollectionReference collection =
          FirebaseFirestore.instance.collection('firms');
      log(user.uid);
      log(user.uid.runtimeType.toString());
      await collection.add(Firm(firmName: name, id: user.uid).toJson());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('role', 'Organization');
    }
    return firebaseuser;
  }

  studentSignUp(email, password, name, age, totalFamilyIncome) async {
    final firebaseuser = await FirebaseSignUp(email, password);
    if (firebaseuser.runtimeType == String) {
    } else {
      User user = firebaseuser as dynamic;

      final CollectionReference collection =
          FirebaseFirestore.instance.collection('students');

      await collection.add(Students(
              name: name,
              age: int.parse(age),
              income: totalFamilyIncome,
              id: user.uid,
              userProfileUrl: FirebaseAuth.instance.currentUser!.photoURL)
          .toJson());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('role', 'student');
    }
    return firebaseuser;
  }
}
