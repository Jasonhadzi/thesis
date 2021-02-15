import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:wolie_mobile/constants.dart';
import 'package:wolie_mobile/models/milestone.dart';

class MilestoneTile extends StatelessWidget {
  final Milestone milestone;
  final double percentageResult;
  final double valueToHundred;

  MilestoneTile({this.milestone, this.percentageResult, this.valueToHundred});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              child: Icon(
                milestone.getIconFromType(),
                color: percentageResult == 1 ? Colors.yellow[700] : Colors.blue,
              ),
              backgroundColor:
                  percentageResult == 1 ? kCreditCardColor1 : Colors.grey[300],
            ),
            title: Text(milestone.milestoneName),
            trailing: Text('Points: ${milestone.milestonePoints}'),
          ),
          SizedBox(
            height: 5.0,
          ),
          new LinearPercentIndicator(
            linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kCreditCardColor1, kCreditCardColor2]),
            animation: true,
            lineHeight: 20.0,
            animationDuration: 2500,
            percent: percentageResult,
            center: percentageResult == 1
                ? Text('Redeem!')
                : Text(
                    '${valueToHundred.toStringAsFixed(2)}%',
                    style: new TextStyle(fontSize: 12.0),
                  ),
          ),
          Divider(
            thickness: 1.3,
          ),
        ],
      ),
    );
  }
}
