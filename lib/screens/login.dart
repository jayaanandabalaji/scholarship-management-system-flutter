import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholarships/screens/admin/admindashboard.dart';
import 'package:scholarships/screens/firm/firmDashboard.dart';
import 'package:scholarships/screens/register.dart';
import 'package:scholarships/screens/student/studentDashboard.dart';
import 'package:scholarships/widgets/button.dart';

import '../services/authService.dart';
import '../widgets/notify.dart';
import 'package:shared_preferences/shared_preferences.dart';

class authscreen extends StatefulWidget {
  const authscreen({Key? key}) : super(key: key);

  @override
  State<authscreen> createState() => _authscreenState();
}

class _authscreenState extends State<authscreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  var authHandler = new Auth();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text(
            "Login",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  style: TextStyle(),
                  validator: (String? text) {
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(text ?? "")) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: "Email", icon: Icon(Icons.email)),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  style: TextStyle(),
                  validator: (String? text) {
                    if (text == "") {
                      return "Please enter your password";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: "password", icon: Icon(Icons.password)),
                ),
                SizedBox(
                  height: 20,
                ),
                button(
                  buttonText: "Login",
                  OnTap: () async {
                    if (emailController.text == "admin@gmail.com" &&
                        passwordController.text == "Admin@1") {
                      showLoaderDialog(context, "Logging In");
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('role', 'admin');
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      UserCredential result =
                          await auth.signInWithEmailAndPassword(
                              email: "admin@gmail.com", password: "Admin@1");
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => adminDashboard()));
                    } else {
                      if (_formKey.currentState!.validate()) {
                        showLoaderDialog(context, "Logging in");
                        final user = await authHandler.handleSignInEmail(
                            emailController.text, passwordController.text);
                        log("logged in");
                        log(user.runtimeType.toString());
                        if (user.runtimeType == String) {
                          _scaffoldKey.currentState!.showSnackBar(
                              new SnackBar(content: new Text(user)));
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          var role = prefs.getString("role");
                          if (role == "Organization") {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => firmDashboard()));
                          } else {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => studentDashboard()));
                          }
                        }
                      }
                    }
                  },
                  buttonWidth: 0.8,
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => registerScreen()));
            },
            child: Text(
              "Dont have an account? Register",
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Dummy Login",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              button(
                  buttonText: "Admin",
                  OnTap: () {
                    emailController.text = "admin@gmail.com";
                    passwordController.text = "Admin@1";
                  },
                  buttonWidth: 0.25),
              button(
                  buttonText: "organization",
                  OnTap: () {
                    emailController.text = "organization@gmail.com";
                    passwordController.text = "organization@1";
                  },
                  buttonWidth: 0.25),
              button(
                  buttonText: "Student",
                  OnTap: () {
                    emailController.text = "student@gmail.com";
                    passwordController.text = "Student@1";
                  },
                  buttonWidth: 0.25),
            ],
          )
        ],
      ),
    ));
  }
}
