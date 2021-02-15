import 'package:flutter/material.dart';
import 'package:wolie_mobile/constants.dart';

class CustomRoundedContainer extends StatelessWidget {
  final Widget child;

  CustomRoundedContainer({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Colors.grey[300],
            spreadRadius: 5.0,
          ),
        ],
        color: Colors.white60,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: child,
    );
  }
}
