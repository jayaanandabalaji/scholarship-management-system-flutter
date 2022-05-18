import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import 'package:scholarships/models/scholarship.dart';
import 'package:scholarships/widgets/button.dart';

import '../../widgets/notify.dart';

class addScholarship extends StatefulWidget {
  const addScholarship({Key? key}) : super(key: key);

  @override
  State<addScholarship> createState() => _addScholarshipState();
}

class _addScholarshipState extends State<addScholarship> {
  final _formKey = GlobalKey<FormState>();
  quill.QuillController _controller = quill.QuillController.basic();
  final FocusNode editorFocusNode = FocusNode();
  TextEditingController lastDateController = new TextEditingController();
  TextEditingController titleController = new TextEditingController();
  var featuredImage;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Add Scholarship")),
      body: ListView(padding: EdgeInsets.all(30), children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(labelText: "Title"),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  // Pick an image
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    featuredImage = image!.path;
                  });
                },
                child: (featuredImage == null)
                    ? Row(
                        children: [
                          Text(
                            "Featured Image",
                            style: TextStyle(fontSize: 20),
                          ),
                          Icon(Icons.file_open)
                        ],
                      )
                    : Image.file(
                        File(featuredImage),
                        height: 100,
                      ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                child: Column(
                  children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: quill.QuillToolbar.basic(
                          controller: _controller,
                          showBackgroundColorButton: false,
                          showCameraButton: false,
                          showImageButton: false,
                          showSmallButton: false,
                          showVideoButton: false,
                          showClearFormat: false,
                          showListCheck: false,
                          showLink: false,
                        )),
                    Expanded(
                      child: Container(
                        child: quill.QuillEditor(
                          controller: _controller,
                          readOnly: false,
                          autoFocus: false,
                          expands: true,
                          focusNode: editorFocusNode,
                          scrollable: true,
                          scrollController: ScrollController(),
                          padding: EdgeInsets.all(10),
                          placeholder: "Desription",
                        ),
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  _selectDate(); // Call Function that has showDatePicker()
                },
                child: IgnorePointer(
                  child: new TextFormField(
                    controller: lastDateController,
                    decoration:
                        new InputDecoration(labelText: 'Last Date to apply'),
                    onSaved: (String? val) {},
                  ),
                ),
              ),
              SizedBox(height: 25),
              button(
                buttonText: "Add Now",
                OnTap: () async {
                  showLoaderDialog(context, "Adding scholarship");
                  final storageRef = FirebaseStorage.instance.ref();
                  log("File path : " + featuredImage);
                  log("name : " + "thumbnail/" + XFile(featuredImage).name);
                  final uploadTask = storageRef
                      .child("thumbnail/" + XFile(featuredImage).name)
                      .putFile(File(featuredImage));
                  uploadTask.snapshotEvents
                      .listen((TaskSnapshot taskSnapshot) async {
                    switch (taskSnapshot.state) {
                      case TaskState.running:
                        final progress = 100.0 *
                            (taskSnapshot.bytesTransferred /
                                taskSnapshot.totalBytes);
                        log("Upload is $progress% complete.");
                        break;
                      case TaskState.paused:
                        log("Upload is paused.");
                        break;
                      case TaskState.canceled:
                        log("Upload was canceled");
                        break;
                      case TaskState.error:
                        // Handle unsuccessful uploads
                        break;
                      case TaskState.success:
                        log("success");
                        final CollectionReference collection = FirebaseFirestore
                            .instance
                            .collection('scholarships');
                        var imageUrl = await storageRef
                            .child("thumbnail/" + XFile(featuredImage).name)
                            .getDownloadURL();
                        await collection.add(scholarship(
                                imageUrl: imageUrl,
                                applicationDeadline: lastDateController.text,
                                description: jsonEncode(
                                    _controller.document.toDelta().toJson()),
                                title: titleController.text,
                                organization: FirebaseAuth
                                    .instance.currentUser!.email!
                                    .replaceAll("@gmail.com", ""),
                                organizationId:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .toJson());
                        Navigator.pop(context);
                        _scaffoldKey.currentState!.showSnackBar(SnackBar(
                            content:
                                Text("Scholarship added successfully...")));
                        await Future.delayed(Duration(seconds: 2));
                        Navigator.pop(context);
                        break;
                    }
                  });
                },
                buttonWidth: 0.7,
              )
            ],
          ),
        )
      ]),
    );
  }

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2022),
        lastDate: new DateTime(2023));
    if (picked != null) {
      _showTimePicker(picked.day.toString() +
          "/" +
          picked.month.toString() +
          "/" +
          picked.year.toString());
    }
  }

  Future _showTimePicker(String date) async {
    TimeOfDay? picker =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picker != null) {
      lastDateController.text =
          date + " " + picker.hour.toString() + ":" + picker.minute.toString();
    }
  }
}
