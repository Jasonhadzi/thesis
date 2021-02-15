import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wolie_mobile/components/custom_rounded_container.dart';
import 'package:wolie_mobile/components/rounded_button.dart';
import 'package:wolie_mobile/models/store.dart';
import 'package:wolie_mobile/models/user.dart';
import 'package:wolie_mobile/screens/home/request_points_screen.dart';
import 'package:wolie_mobile/screens/home/request_stamps_screen.dart';
import 'package:wolie_mobile/screens/home/storespoints_list.dart';
import 'package:wolie_mobile/screens/services/database.dart';
import 'package:wolie_mobile/shared/loading.dart';

import '../../constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firestore = Firestore.instance;

  String promoType;

  bool success;

  StoreData storeDataModel;

  StoreUser storeUserModel;

  StorePoint storePointModel;

  UserData userDataModel;

  Future<String> getStoreUser(String storeUid) async {
    String campaignType;
    await _firestore
        .collection('users')
        .document(storeUid)
        .get()
        .then((DocumentSnapshot ds) {
      // use ds as a snapshot

      if (ds.exists) {
        storeUserModel = StoreUser(
            uid: storeUid,
            promoType: ds.data['promo_type'],
            email: ds.data['email'],
            fromStore: ds.data['from_store'],
            pointsGave: ds.data['points_gave'],
            pointsReceived: ds.data['points_received'],
            coffeesGave: ds.data['coffees_gave'],
            coffeesTreated: ds.data['coffees_treated'],
            hasTables: ds.data['has_tables']);

        campaignType = storeUserModel.promoType;
        print(campaignType);
        print(
            'Store Details: coffees gave: ${storeUserModel.coffeesGave},coffees treated: ${storeUserModel.coffeesTreated}');
      }
    });

    await _firestore
        .collection('stores')
        .document(storeUserModel.fromStore)
        .get()
        .then((DocumentSnapshot ds) {
      // use ds as a snapshot

      if (ds.exists) {
        storeDataModel = StoreData(
            title: ds.data['name'],
            stampCardReward: ds.data['stamp_card'] ?? 0,
            wolieValue: ds.data['wolie_v'] ?? 0,
            imageUrl: ds.data['imageUrl'] ?? '',
            hasPickup: ds.data['has_pickup'] ?? false);
        print(
            'title: ${storeDataModel.title}, stamp_card: ${storeDataModel.stampCardReward}, wolie_v:${storeDataModel.wolieValue}');
      }
    });

    return campaignType;
  }

  Future<StorePoint> getStoreInUserSubCollection(String userId) async {
    StorePoint storePoint;
    await Firestore.instance
        .collection('users')
        .document(userId)
        .collection('stores')
        .document(storeUserModel.fromStore)
        .get()
        .then((DocumentSnapshot docs) {
      if (docs.exists) {
        storePoint = StorePoint(
            name: storeDataModel.title,
            points: docs.data['points'],
            hasPoints: storeUserModel.promoType == '2' ? true : false,
            currentCoffeeNumber: docs.data['current_coffee_number'],
            totalCoffees: docs.data['total_coffees'],
            storeReward: storeDataModel.stampCardReward);

        if (storePoint.currentCoffeeNumber == null ||
            storePoint.totalCoffees == null) {
          print('user is from previous version');

          Firestore.instance
              .collection('users')
              .document(userId)
              .collection('stores')
              .document(storeUserModel.fromStore)
              .setData({
            'name': storeDataModel.title,
            'points': docs.data['points'],
            'current_coffee_number': 0,
            'has_points': storeUserModel.promoType == '2' ? true : false,
            'total_coffees': 0,
            'store_reward': storeDataModel.stampCardReward,
            'imageUrl': storeDataModel.imageUrl,
          });

          storePoint = StorePoint(
            name: storeDataModel.title,
            points: docs.data['points'],
            currentCoffeeNumber: 0,
            hasPoints: storeUserModel.promoType == '2' ? true : false,
            totalCoffees: 0,
            storeReward: storeDataModel.stampCardReward,
          );
        }

        print('got StorePoint Model: ${storePoint.points}');
        print(
            'current coffee: ${storePoint.currentCoffeeNumber} , total coffees: ${storePoint.totalCoffees}, store reward: ${storePoint.storeReward}');
      } else {
        print('first time user coming');

        Firestore.instance
            .collection('users')
            .document(userId)
            .collection('stores')
            .document(storeUserModel.fromStore)
            .setData({
          'name': storeDataModel.title,
          'points': 0,
          'current_coffee_number': 0,
          'has_points': storeUserModel.promoType == '2' ? true : false,
          'total_coffees': 0,
          'store_reward': storeDataModel.stampCardReward,
          'imageUrl': storeDataModel.imageUrl
        });

        storePoint = StorePoint(
          name: storeDataModel.title,
          points: 0,
          currentCoffeeNumber: 0,
          totalCoffees: 0,
          hasPoints: storeUserModel.promoType == '2' ? true : false,
          storeReward: storeDataModel.stampCardReward,
        );
        print('created StorePoint Model: ${storePoint.points}');
        print(
            'created current coffee: ${storePoint.currentCoffeeNumber} , total coffees: ${storePoint.totalCoffees}, store reward: ${storePoint.storeReward}');
      }
    });

    return storePoint;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    String storeUid;

    return StreamProvider<List<StorePoint>>.value(
      value: DatabaseService(uid: user.uid).storesPoints,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuilder<UserData>(
                  stream: DatabaseService(uid: user.uid).userData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      UserData userData = snapshot.data;
                      print(userData.name);

                      userDataModel = userData;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Welcome ${userData.name}',
                            style: TextStyle(fontSize: 25.0),
                          ),
                        ),
                      );
                    } else {
                      return Loading();
                    }
                  }),
              Expanded(
                  child: CustomRoundedContainer(child: StoresPointsList())),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 5.0, left: 40.0, right: 40.0),
                child: RoundedButton(
                  buttonTitle: "Scan QRcode",
                  color: Colors.blueAccent[200],
                  onPressed: () async {
                    try {
                      storeUid = await BarcodeScanner.scan();
                      //TODO uncomment this line
                      //for points
                      //storeUid = 'JpDJiKSxE2gvRSe4czvyip35O9i2';
                      //for stamps
                      //storeUid = 'wt6y9jkxW0PVwgRXkMTsbAe1LAF2';
                      // When the user taps the button, navigate to a named route
                      // and provide the arguments as an optional parameter.

                      promoType = await getStoreUser(storeUid);
                      storePointModel =
                          await getStoreInUserSubCollection(user.uid);

                      print(storePointModel.name);
                      print('promotype: $promoType sucess $success');

                      //1: stamps, 2:points

                      switch (promoType) {
                        case '1':
                          {
                            Navigator.pushNamed(
                              context,
                              RequestStampsScreen.routeName,
                              arguments: PassingArguments(
                                storeDataModel: storeDataModel,
                                storeUserModel: storeUserModel,
                                storePointModel: storePointModel,
                                userDataModel: userDataModel,
                              ),
                            );
                          }
                          break;
                        case '2':
                          {
                            Navigator.pushNamed(
                              context,
                              RequestPointsScreen.routeName,
                              arguments: PassingArguments(
                                storeDataModel: storeDataModel,
                                storeUserModel: storeUserModel,
                                storePointModel: storePointModel,
                                userDataModel: userDataModel,
                              ),
                            );
                          }
                      }
                    } catch (e) {
                      print(e);
                      Alert(
                              context: context,
                              title: 'Something went Wrong',
                              type: AlertType.error,
                              desc: e.toString())
                          .show();
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
