import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wolie_mobile/components/rounded_button.dart';
import 'package:wolie_mobile/models/store.dart';
import 'package:wolie_mobile/models/user.dart';
import 'package:wolie_mobile/screens/services/database.dart';

class RequestStampsScreen extends StatefulWidget {
  static const routeName = '/requestStamps';

  @override
  _RequestStampsScreenState createState() => _RequestStampsScreenState();
}

class _RequestStampsScreenState extends State<RequestStampsScreen> {
  final _auth = FirebaseAuth.instance;
  String qrValue = '';
  final _firestore = Firestore.instance;
  UserData userDataModel;
  StorePoint storePointModel;
  StoreUser storeUserModel;
  StoreData storeDataModel;
  UserRequest userRequest;
  int initBalance;
  int _metal = 0;
  int newBalance;
  String currentUserID, currentStoreUserDocumentID;
  bool showSpinner = false;
  FirebaseUser loggedInUser;
  int _n = 1;
  int initCoffeeNumber;
  int newCoffeeNumber;
  int newTotalCoffees;
  int stampCardReward;

  void add() {
    setState(() {
      _n++;
    });
  }

  void minus() {
    setState(() {
      if (_n != 1) _n--;
    });
  }

  void _back() {
    _clearValues();
    Navigator.pop(context);
  }

  _clearValues() {
    setState(() {
      newBalance = 0;
      initBalance = 0;
      initCoffeeNumber = 0;
      newCoffeeNumber = 0;
      newTotalCoffees = 0;
      stampCardReward = 0;
      _n = 1;
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final PassingArguments args = ModalRoute.of(context).settings.arguments;

    storeUserModel = args.storeUserModel;
    storeDataModel = args.storeDataModel;
    storePointModel = args.storePointModel;
    userDataModel = args.userDataModel;

    return Scaffold(
        backgroundColor: Color(0xffe7e9f0),
        appBar: AppBar(
          title: Text('Wolie'),
          backgroundColor: Colors.blueAccent[200],
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Scan Value:',
                ),
                Text(storeDataModel.title),
                // Text('StorePoint Balance: ${storePointModel.points}'),
//                  Text('User Init Balance: $initBalance'),
//                  Text('User New Balance: $newBalance'),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    Center(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new FloatingActionButton(
                            heroTag: 'minus',
                            onPressed: minus,
                            child: new Icon(
                                const IconData(0xe15b,
                                    fontFamily: 'MaterialIcons'),
                                color: Colors.black),
                            backgroundColor: Colors.white,
                          ),
                          new Text('$_n', style: new TextStyle(fontSize: 60.0)),
                          new FloatingActionButton(
                            heroTag: 'add',
                            onPressed: add,
                            child: new Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: RoundedButton(
                                color: Colors.red,
                                buttonTitle: 'Free coffee',
                                onPressed: () async {
                                  newCoffeeNumber =
                                      storePointModel.currentCoffeeNumber -
                                          storePointModel.storeReward;

                                  if (storePointModel.currentCoffeeNumber <
                                      storePointModel.storeReward) {
                                    showSpinner = false;
                                    Alert(
                                            context: context,
                                            title:
                                                "Not enough coffees collected",
                                            type: AlertType.error,
                                            desc:
                                                "You have purchased only: ${storePointModel.currentCoffeeNumber} coffees.")
                                        .show();
                                  } else {
                                    print(
                                        'storeUsermodel value: ${storeUserModel.fromStore}');

                                    newTotalCoffees =
                                        storePointModel.totalCoffees;
                                    userRequest = UserRequest(
                                        name: userDataModel.name,
                                        quantity: 1,
                                        status: 'pending',
                                        description: 'free coffee',
                                        userId: userDataModel.uid,
                                        newTotalCoffees: newTotalCoffees,
                                        newCoffeeNumber: newCoffeeNumber,
                                        storeName: storePointModel.name,
                                        storeReward:
                                            storePointModel.storeReward);

                                    await DatabaseService(
                                            storeId: storeUserModel.fromStore)
                                        .updateUsersRequestsData(
                                            userRequest: userRequest);

                                    // print(storeUserModel.fromStore);
                                    //print(storePointModel.storeId);
                                    _back();
                                  }

                                  //_back();
                                }),
                          ),
                          Expanded(
                            child: RoundedButton(
                                color: Colors.green,
                                buttonTitle: 'Request stamp',
                                onPressed: () async {
                                  newCoffeeNumber =
                                      storePointModel.currentCoffeeNumber + _n;
                                  newTotalCoffees =
                                      storePointModel.totalCoffees + _n;

                                  userRequest = UserRequest(
                                      name: userDataModel.name,
                                      quantity: _n,
                                      status: 'pending',
                                      description: 'stamp(s)',
                                      userId: userDataModel.uid,
                                      newTotalCoffees: newTotalCoffees,
                                      newCoffeeNumber: newCoffeeNumber,
                                      storeName: storePointModel.name,
                                      storeReward: storePointModel.storeReward);

                                  await DatabaseService(
                                          storeId: storeUserModel.fromStore)
                                      .updateUsersRequestsData(
                                          userRequest: userRequest);
                                  _back();
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
