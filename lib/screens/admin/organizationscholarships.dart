import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scholarships/widgets/singlescholarship.dart';

class orgScholarships extends StatefulWidget {
  final organization;
  const orgScholarships({required this.organization});

  @override
  State<orgScholarships> createState() => _orgScholarshipsState();
}

class _orgScholarshipsState extends State<orgScholarships> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.organization["firmName"]),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("scholarships")
                  .where("organizationId", isEqualTo: widget.organization["id"])
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  return Column(children: [
                    for (var scholarship in snapshot.data!.docs)
                      singleScholarship(
                          scholarship: scholarship,
                          scholarshipId: scholarship.id,
                          role: "admin")
                  ]);
                }
              })
        ],
      ),
    );
  }
}
