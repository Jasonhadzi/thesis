import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolie_mobile/constants.dart';
import 'package:wolie_mobile/models/store.dart';
import 'package:wolie_mobile/screens/home/store_point_details.dart';
import 'package:wolie_mobile/screens/home/storepoint_tile.dart';

class StoresPointsList extends StatefulWidget {
  @override
  _StoresPointsListState createState() => _StoresPointsListState();
}

class _StoresPointsListState extends State<StoresPointsList> {
  @override
  Widget build(BuildContext context) {
    final storePoints = Provider.of<List<StorePoint>>(context) ?? [];

    storePoints.forEach((storePoint) {
      print(storePoint.storeId);
      print(storePoint.name);
      print(storePoint.points);
      print(storePoint.totalCoffees);
      print(storePoint.currentCoffeeNumber);
      print(storePoint.storeReward);
    });

    if (storePoints.isEmpty) {
      print('empty');
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '• Look for the Wolie QR stand inside the store',
              style: kDirectionsTextStyle,
            ),
            Text(
              '• Scan the QR',
              style: kDirectionsTextStyle,
            ),
            Text(
              '• Claim your stamps or points!',
              style: kDirectionsTextStyle,
            )
          ],
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Your loyalty programs.',
              style: TextStyle(fontSize: 25.0),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: storePoints.length,
                itemBuilder: (context, index) {
                  return StorePointTile(
                    storePoint: storePoints[index],
                    onPressedPointsList: () {
                      print('tapped');
                      Navigator.pushNamed(
                        context,
                        StorePointDetails.routeName,
                        arguments: PassingArguments(
                            storePointModel: storePoints[index]),
                      );
                    },
                  );
                }),
          ),
        ],
      );
    }
  }
}
