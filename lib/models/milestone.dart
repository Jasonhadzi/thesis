import 'package:flutter/material.dart';

class Milestone {
  final String milestoneName;
  final String milestoneType;
  final dynamic milestonePoints;
  IconData icon;

  Milestone({this.milestoneName, this.milestonePoints, this.milestoneType});

  IconData getIconFromType() {
    if (milestoneType == 'star') {
      icon = Icons.star;
    } else if (milestoneType == 'food') {
      icon = Icons.fastfood;
    } else if (milestoneType == 'drink') {
      icon = Icons.local_drink;
    }
    return icon;
  }
}
