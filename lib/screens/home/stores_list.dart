import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolie_mobile/models/store.dart';
import 'package:wolie_mobile/screens/home/stores_list_tile.dart';

class StoresList extends StatefulWidget {
  @override
  _StoresListState createState() => _StoresListState();
}

class _StoresListState extends State<StoresList> {
  @override
  Widget build(BuildContext context) {
    final storeData = Provider.of<List<StoreData>>(context) ?? [];

    storeData.forEach((store) {
      print(store.title);
      print(store.area);
      print(store.wolieValue);
      print(store.stampCardReward);
      print(store.hasPickup);
    });

    return ListView.builder(
        itemCount: storeData.length,
        itemBuilder: (context, index) {
          return StoresListTile(storeData: storeData[index]);
        });
  }
}
