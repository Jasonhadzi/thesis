import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolie_mobile/constants.dart';
import 'package:wolie_mobile/models/store.dart';
import 'package:wolie_mobile/models/user.dart';
import 'package:wolie_mobile/screens/customer/request_list.dart';
import 'package:wolie_mobile/screens/services/database.dart';

class CustomerHome extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final storeUser = Provider.of<StoreUser>(context) ?? StoreUser();

    print('from Store: ${storeUser.fromStore}');
    return StreamProvider<List<UserRequest>>.value(
      value: DatabaseService(storeId: storeUser.fromStore).userRequests,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Wolie',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 21.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text('logout'),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, left: 20.0, right: 20.0, bottom: 0.0),
              child: Text(
                'User Requests:',
                style: kStoresListTextStyle,
              ),
            ),
            Expanded(child: RequestList()),
          ],
        ),
      ),
    );
  }
}
