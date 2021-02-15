import 'package:flutter/material.dart';
import 'package:wolie_mobile/models/store.dart';

class StorePointTile extends StatelessWidget {
  final StorePoint storePoint;
  final Function onPressedPointsList;

  StorePointTile({this.storePoint, this.onPressedPointsList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            child: ListTile(
              leading: ClipOval(
                child: Image.network(
                  storePoint.imageUrl,
                  fit: BoxFit.cover,
                  width: 50.0,
                  height: 50.0,
                ),
              ),
              title: Text(storePoint.name),
              subtitle: storePoint.hasPoints
                  ? Text(
                      'Total Points: ${double.parse(storePoint.points.toStringAsFixed(2))}')
                  : Text(
                      'Total Coffees: ${storePoint.totalCoffees.toString()}'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: onPressedPointsList,
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
