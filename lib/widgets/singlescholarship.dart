import 'package:flutter/material.dart';
import 'package:scholarships/models/scholarship.dart';
import 'package:scholarships/screens/firm/applicants.dart';
import 'package:scholarships/screens/scholarshipDetails.dart';
import 'package:scholarships/utils/settings.dart';

class singleScholarship extends StatelessWidget {
  final scholarship;
  final scholarshipId;
  final role;
  const singleScholarship(
      {required this.scholarship,
      required this.scholarshipId,
      required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Color(0xffE0E0E0).withOpacity(0.8), blurRadius: 5)
          ]),
      child: GestureDetector(
        onTap: () {
          if (role == "Organization" || role == "admin") {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => scholarshipApplicants(
                    scholarship: scholarship, scholarshipId: scholarshipId)));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    scholarshipDetails(scholarship, scholarshipId)));
          }
        },
        child: Card(
          child: Container(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.network(
                      scholarship["imageUrl"],
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                    ),
                    Container(
                      height: 150,
                      child: Container(
                          alignment: Alignment.bottomLeft,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: settings.primaryColor.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "Apply before " +
                                    scholarship["applicationDeadline"]
                                        .substring(0, 9),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ))),
                    )
                  ],
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scholarship["title"],
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "- " + scholarship["organization"],
                          style: TextStyle(color: Colors.green),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
