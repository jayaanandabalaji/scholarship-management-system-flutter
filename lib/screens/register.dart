import 'package:image_picker/image_picker.dart';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scholarships/screens/login.dart';
import 'package:scholarships/screens/student/studentDashboard.dart';
import 'package:scholarships/utils/settings.dart';
import 'package:scholarships/widgets/button.dart';

import '../services/authService.dart';
import '../widgets/notify.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({Key? key}) : super(key: key);

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentFormKey = GlobalKey<FormState>();
  final _firmFormKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  var authHandler = new Auth();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedTabbar = 0;
  var incomeProofImage;
  TextEditingController nameController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  TextEditingController incomeController = new TextEditingController();
  TextEditingController firmController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text(
            "Register",
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
                DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                            onTap: (index) {
                              print(index);
                              setState(() {
                                _selectedTabbar = index;
                              });
                            },
                            unselectedLabelColor: settings.primaryColor,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  settings.primaryColor,
                                  settings.primaryColor
                                ]),
                                color: settings.primaryColor),
                            tabs: [
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("Student"),
                                ),
                              ),
                              Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("organization"),
                                ),
                              ),
                            ]),
                        Builder(builder: (_) {
                          if (_selectedTabbar == 0) {
                            return studentform();
                          } else {
                            return FirmForm();
                          }
                        })
                      ],
                    )),
                SizedBox(
                  height: 20,
                ),
                button(
                  buttonText: "Register",
                  OnTap: () async {
                    if (_selectedTabbar == 0) {
                      _studentFormKey.currentState!.validate();
                    }
                    if (_selectedTabbar == 1) {
                      _firmFormKey.currentState!.validate();
                    }
                    if (_formKey.currentState!.validate()) {
                      if ((_selectedTabbar == 0 &&
                              _studentFormKey.currentState!.validate()) ||
                          (_selectedTabbar == 1 &&
                              _firmFormKey.currentState!.validate())) {
                        showLoaderDialog(context, "Registering");
                        var user;
                        if (_selectedTabbar == 0) {
                          user = await authHandler.studentSignUp(
                              emailController.text,
                              passwordController.text,
                              nameController.text,
                              ageController.text,
                              incomeController.text);
                        }

                        if (_selectedTabbar == 1) {
                          user = await authHandler.firmSignUp(
                            emailController.text,
                            passwordController.text,
                            firmController.text,
                          );
                        }

                        if (user.runtimeType == String) {
                          _scaffoldKey.currentState!.showSnackBar(
                              new SnackBar(content: new Text(user)));
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => studentDashboard()));
                        }
                      }
                    }
                  },
                  buttonWidth: 0.8,
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => authscreen()));
                  },
                  child: Text(
                    "Already have an account? Login",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget studentform() {
    return Form(
      key: _studentFormKey,
      child: Column(
        children: [
          SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: nameController,
            validator: (text) {
              if (text == "") {
                return "Please enter your name";
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: "Name", icon: Icon(Icons.account_circle)),
          ),
          SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: ageController,
            validator: (text) {
              if (text == "") {
                return "Please enter your age";
              }
              if (int.parse(text ?? "") > 18) {
                return "Sorry, students under the age of 18 can only register";
              }
              return null;
            },
            decoration: InputDecoration(labelText: "Age"),
          ),
          SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: incomeController,
            validator: (text) {
              if (text == "") {
                return "Please enter your Total annual Family income";
              }
              if (int.parse(text ?? "") > 300000) {
                return "Sorry, students whose total family income is less than 3 lakhs can register";
              }
              return null;
            },
            decoration: InputDecoration(
                labelText: "Total annual Family income",
                icon: Icon(Icons.currency_rupee)),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              final ImagePicker _picker = ImagePicker();
              final XFile? image =
                  await _picker.pickImage(source: ImageSource.gallery);

              if (image != null) {
                setState(() {
                  incomeProofImage = image;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: (incomeProofImage == null)
                  ? Row(
                      children: [
                        Text(
                          "Upload income proof",
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                            onPressed: () async {}, icon: Icon(Icons.upload))
                      ],
                    )
                  : Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                      child: Row(children: [
                        Text(incomeProofImage.name),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(Icons.check_circle, color: Colors.green)
                      ]),
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget FirmForm() {
    return Form(
      key: _firmFormKey,
      child: Column(children: [
        SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: firmController,
          validator: (text) {
            if (text == "") {
              return "Please enter your firm name";
            }
            return null;
          },
          decoration: InputDecoration(
              labelText: "organization Name", icon: Icon(Icons.account_circle)),
        )
      ]),
    );
  }
}
