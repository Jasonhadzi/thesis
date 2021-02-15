import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolie_mobile/models/store.dart';
import 'package:wolie_mobile/screens/customer/customer_home.dart';
import 'package:wolie_mobile/screens/home/home.dart';
import 'package:wolie_mobile/screens/services/database.dart';
import 'package:wolie_mobile/shared/loading.dart';

class ViewController extends StatefulWidget {
  @override
  _ViewControllerState createState() => _ViewControllerState();
}

class _ViewControllerState extends State<ViewController> {
  String role;
  String fromStore;
  dynamic coffeesGave;
  dynamic coffeesTreated;
  dynamic pointsGave;
  dynamic pointsReceived;
  bool loading = true;
  String userId;
  String promoType;

  void fetchUserData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userId = user.uid;
    await Firestore.instance
        .collection('users')
        .document(userId)
        .get()
        .then((DocumentSnapshot ds) {
      // use ds as a snapshot

      role = ds.data['role'];
      fromStore = ds.data['from_store'];
      print('role: $role');
      print('from Store: $fromStore');
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    print(role);

    if (loading) {
      return Loading();
    } else {
      switch (role) {
        case 'customer':
          {
            return Home();
          }
          break;
        case 'store':
          {
            return StreamProvider<StoreUser>.value(
              value: DatabaseService(storeId: userId).storeUser,
              child: CustomerHome(),
            );
          }
          break;
      }
    }
  }
}
