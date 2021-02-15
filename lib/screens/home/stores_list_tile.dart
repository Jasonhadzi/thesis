import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wolie_mobile/components/rounded_button.dart';
import 'package:wolie_mobile/models/store.dart';

class StoresListTile extends StatelessWidget {
  final StoreData storeData;

  StoresListTile({this.storeData});

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
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: ClipOval(
                    child: Image.network(
                      storeData.imageUrl,
                      fit: BoxFit.cover,
                      width: 50.0,
                      height: 50.0,
                    ),
                  ),
                  title: Text(storeData.title),
                  subtitle: Text('Area: ${storeData.area}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Loyalty Program:'),
                      storeData.stampCardReward != 0
                          ? Text(
                              'Stamps',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Text(
                              'Points',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ],
                  ),
                ),
                storeData.hasPickup
                    ? RoundedButton(
                        color: Colors.green[300],
                        buttonTitle: 'Pickup Order Available',
                        onPressed: () {},
                      )
                    : Container(),
              ],
            ),
          ),
          Divider(
            thickness: 1.4,
          ),
        ],
      ),
    );
  }
}
