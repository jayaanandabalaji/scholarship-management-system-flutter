import 'package:flutter/material.dart';
import 'package:scholarships/utils/settings.dart';

class button extends StatelessWidget {
  final buttonText;
  Function OnTap;
  final buttonWidth;
  button(
      {required this.buttonText,
      required this.OnTap,
      required this.buttonWidth});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: MediaQuery.of(context).size.width * buttonWidth,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(17.0))),
      textColor: Colors.white,
      color: settings.primaryColor,
      child: Text(
        buttonText,
        style: TextStyle(fontSize: 18),
      ),
      onPressed: () {
        OnTap();
      },
    );
  }
}
