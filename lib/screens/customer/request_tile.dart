import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolie_mobile/models/store.dart';
import 'package:wolie_mobile/models/user.dart';
import 'package:wolie_mobile/screens/services/database.dart';

class RequestTile extends StatelessWidget {
  final UserRequest request;

  RequestTile({this.request});

  @override
  Widget build(BuildContext context) {
    final storeUser = Provider.of<StoreUser>(context);

    print(storeUser.pointsGave);

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Container(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: storeUser.hasTables
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Table Number:'),
                        Text(
                          '${request.tableNumber}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  : null,
              title: Text('${request.name} is requesting:'),
              subtitle: Text('Status: ${request.status}'),
              trailing: Text('${request.quantity} ${request.description} '),
            ),
            Divider(
              indent: 20.0,
              endIndent: 20.0,
              color: Colors.black,
              thickness: 1.3,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 2.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      onPressed: () async {
                        await DatabaseService(storeId: storeUser.fromStore)
                            .updateStatusInDB(docId: request.docId, newValues: {
                          'status': 'rejected',
                          'date': DateTime.now()
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                      color: Colors.redAccent,
                      child:
                          const Text('Reject', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                      onPressed: () async {
                        switch (request.description) {
                          case 'free coffee':
                            {
                              await DatabaseService()
                                  .updateUserDataInSubCollection(
                                      collectionName: 'users',
                                      selectedDoc: request.userId,
                                      subCollection: 'stores',
                                      subDocId: storeUser.fromStore,
                                      newValues: {
                                    'name': request.storeName,
                                    'store_reward': request.storeReward,
                                    'current_coffee_number':
                                        request.newCoffeeNumber,
                                    'total_coffees': (request.newTotalCoffees +
                                        request.quantity),
                                  });

                              await DatabaseService().updateUserDataInDB(
                                  collectionName: 'users',
                                  selectedDoc: storeUser.uid,
                                  newValues: {
                                    'coffees_treated':
                                        storeUser.coffeesTreated +
                                            request.quantity
                                  });
                            }
                            break;
                          case 'stamp(s)':
                            {
                              await DatabaseService()
                                  .updateUserDataInSubCollection(
                                      collectionName: 'users',
                                      selectedDoc: request.userId,
                                      subCollection: 'stores',
                                      subDocId: storeUser.fromStore,
                                      newValues: {
                                    'name': request.storeName,
                                    'store_reward': request.storeReward,
                                    'current_coffee_number':
                                        request.newCoffeeNumber,
                                    'total_coffees': request.newTotalCoffees,
                                  });

                              await DatabaseService().updateUserDataInDB(
                                  collectionName: 'users',
                                  selectedDoc: storeUser.uid,
                                  newValues: {
                                    'coffees_gave':
                                        storeUser.coffeesGave + request.quantity
                                  });
                            }
                            break;
                          case '€':
                            {
                              await DatabaseService()
                                  .updateUserDataInSubCollection(
                                      collectionName: 'users',
                                      selectedDoc: request.userId,
                                      subCollection: 'stores',
                                      subDocId: storeUser.fromStore,
                                      newValues: {
                                    'name': request.storeName,
                                    'has_points': true,
                                    'points': request.newUserPoints,
                                  });

                              await DatabaseService().updateUserDataInDB(
                                  collectionName: 'users',
                                  selectedDoc: storeUser.uid,
                                  newValues: {
                                    'points_gave': storeUser.pointsGave +
                                        (request.quantity * request.storeReward)
                                  });
                            }
                            break;
                          case 'redeem points':
                            {
                              await DatabaseService()
                                  .updateUserDataInSubCollection(
                                      collectionName: 'users',
                                      selectedDoc: request.userId,
                                      subCollection: 'stores',
                                      subDocId: storeUser.fromStore,
                                      newValues: {
                                    'name': request.storeName,
                                    'has_points': true,
                                    'points': request.newUserPoints,
                                  });

                              await DatabaseService().updateUserDataInDB(
                                  collectionName: 'users',
                                  selectedDoc: storeUser.uid,
                                  newValues: {
                                    'points_received':
                                        storeUser.pointsReceived +
                                            request.quantity
                                  });
                            }
                            break;
                        }

                        await DatabaseService(storeId: storeUser.fromStore)
                            .updateStatusInDB(docId: request.docId, newValues: {
                          'status': 'accepted',
                          'date': DateTime.now()
                        });
                      },
                      color: Colors.greenAccent,
                      child:
                          const Text('Accept', style: TextStyle(fontSize: 20)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
