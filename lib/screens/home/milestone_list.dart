import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolie_mobile/models/milestone.dart';
import 'package:wolie_mobile/models/store.dart';
import 'package:wolie_mobile/screens/home/milestone_tile.dart';

class MilestoneList extends StatelessWidget {
  final StorePoint storePoint;
  MilestoneList({this.storePoint});

  double functionF(dynamic userPoints, dynamic milestonePoints) {
    double result;

    if (userPoints >= milestonePoints) {
      result = 1.0;
    } else {
      double percentValue = (userPoints / milestonePoints).toDouble();
      result = percentValue;
    }

    return result;
  }

  double valueToHundred(double result) {
    double valueToHundred;

    valueToHundred = result * 100;

    return valueToHundred;
  }

  @override
  Widget build(BuildContext context) {
    final milestones = Provider.of<List<Milestone>>(context) ?? [];

    milestones.forEach((milestone) {
      print(milestone.milestoneName);
      print(milestone.milestonePoints);
      print(milestone.milestoneType);
    });

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView.builder(
          itemCount: milestones.length,
          itemBuilder: (context, index) {
            return MilestoneTile(
              milestone: milestones[index],
              percentageResult: functionF(
                  storePoint.points, milestones[index].milestonePoints),
              valueToHundred: valueToHundred(
                functionF(storePoint.points, milestones[index].milestonePoints),
              ),
            );
          }),
    );
  }
}
