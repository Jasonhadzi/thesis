import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wolie_mobile/components/rounded_button.dart';
import 'package:wolie_mobile/models/store.dart';
import 'package:wolie_mobile/models/user.dart';
import 'package:wolie_mobile/screens/services/database.dart';

class CustomerScreen extends StatefulWidget {
  static String id = 'customer_screen';

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final _auth = FirebaseAuth.instance;
  String name, qrValue = '';
  final _firestore = Firestore.instance;
  UserData userModel;
  StorePoint storePointModel;
  StoreUser storeUserModel;
  StoreData storeDataModel;
  int initBalance;
  int _metal = 0;
  int newBalance;
  String currentUserDocumentID, currentStoreUserDocumentID;
  bool showSpinner = false;
  FirebaseUser loggedInUser;
  int _n = 1;
  int initCoffeeNumber;
  int newCoffeeNumber;
  int usertotalCoffees;
  int stampCardReward;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Start listening to changes.
    myController.addListener(_printLatestValue);
    _clearValues();
    getStoreUser();
  }

  Future _scanQR() async {
    try {
      name = await BarcodeScanner.scan();

      //name = 'sl7syixMFCOggi84d0ajcDDhDLj1';
      //name = 'i9Cg4mGoe4f2xcfj3o2hVo9YV5C2';
      userModel = UserData(uid: name);
      currentUserDocumentID = name;
      print(currentUserDocumentID);
      getStoreUser();
      print(storeUserModel.fromStore);
      print(storeDataModel.title);

      Firestore.instance
          .collection('users')
          .document(name)
          .collection('stores')
          .document(storeUserModel.fromStore)
          .get()
          .then((DocumentSnapshot docs) {
        if (docs.exists) {
          storePointModel = StorePoint(
            name: docs.data['name'],
            points: docs.data['points'],
            currentCoffeeNumber: docs.data['current_coffee_number'],
            totalCoffees: docs.data['total_coffees'],
            storeReward: storeDataModel.stampCardReward,
          );

          if (storePointModel.currentCoffeeNumber == null ||
              storePointModel.totalCoffees == null) {
            print('user is from previous version');

            Firestore.instance
                .collection('users')
                .document(name)
                .collection('stores')
                .document(storeUserModel.fromStore)
                .setData({
              'name': storeDataModel.title,
              'points': docs.data['points'],
              'current_coffee_number': 0,
              'total_coffees': 0,
              'store_reward': storeDataModel.stampCardReward,
            });

            storePointModel = StorePoint(
              name: storeDataModel.title,
              points: docs.data['points'],
              currentCoffeeNumber: 0,
              totalCoffees: 0,
              storeReward: storeDataModel.stampCardReward,
            );
          }

          print('got StorePoint Model: ${storePointModel.points}');
          print(
              'current coffee: ${storePointModel.currentCoffeeNumber} , total coffees: ${storePointModel.totalCoffees}, store reward: ${storePointModel.storeReward}');
        } else {
          print('first time user coming');

          Firestore.instance
              .collection('users')
              .document(name)
              .collection('stores')
              .document(storeUserModel.fromStore)
              .setData({
            'name': storeDataModel.title,
            'points': 0,
            'current_coffee_number': 0,
            'total_coffees': 0,
            'store_reward': storeDataModel.stampCardReward,
          });

          storePointModel = StorePoint(
            name: storeDataModel.title,
            points: 0,
            currentCoffeeNumber: 0,
            totalCoffees: 0,
            storeReward: storeDataModel.stampCardReward,
          );
          print('created StorePoint Model: ${storePointModel.points}');
          print(
              'created current coffee: ${storePointModel.currentCoffeeNumber} , total coffees: ${storePointModel.totalCoffees}, store reward: ${storePointModel.storeReward}');
        }
        setState(() {
          qrValue = name;
        });
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          qrValue = 'Camera access was denied';
        });
      } else {
        setState(() {
          qrValue = 'Unknown error $e';
        });
      }
    } on FormatException {
      setState(() {
        qrValue = 'You pressed the back button before scanning anything';
      });
    } catch (e) {
      setState(() {
        qrValue = 'Unknown error $e';
      });
    }
  }

  final myController = TextEditingController();
  _printLatestValue() {
    print("Second text field: ${myController.text}");
  }

  void getStoreUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);

        await _firestore
            .collection('users')
            .document(loggedInUser.uid)
            .get()
            .then((DocumentSnapshot ds) {
          // use ds as a snapshot

          if (ds.exists) {
            storeUserModel = StoreUser(
                uid: loggedInUser.uid,
                email: loggedInUser.email,
                fromStore: ds.data['from_store'],
                pointsGave: ds.data['points_gave'],
                pointsReceived: ds.data['points_received'],
                coffeesGave: ds.data['coffees_gave'],
                coffeesTreated: ds.data['coffees_treated']);

            currentStoreUserDocumentID = loggedInUser.uid;
            print(
                'coffees gave: ${storeUserModel.coffeesGave},coffees treated: ${storeUserModel.coffeesTreated}');
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
                title: ds.data['name'], stampCardReward: ds.data['stamp_card']);
            print(
                'title: ${storeDataModel.title}, stamp_card: ${storeDataModel.stampCardReward}');
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  _clearValues() {
    setState(() {
      newBalance = 0;
      myController.text = "";
      initBalance = 0;
      initCoffeeNumber = 0;
      newCoffeeNumber = 0;
      usertotalCoffees = 0;
      stampCardReward = 0;
      _n = 1;
      currentUserDocumentID = "";
      name = '';
      qrValue = '';
      showSpinner = false;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<User>(context);

    return GestureDetector(
      onTap: () {
        //hide the keyboard when the user taps everywhere else
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          backgroundColor: Color(0xffe7e9f0),
          appBar: AppBar(
            title: Text(
              'Wolie',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 21.0,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
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
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Scan Value:',
                  ),
                  Text(qrValue),
                  // Text('StorePoint Balance: ${storePointModel.points}'),
//                  Text('User Init Balance: $initBalance'),
//                  Text('User New Balance: $newBalance'),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: qrValue != '',
                    child: Column(
                      children: <Widget>[
//                        TextField(
//                          keyboardType: TextInputType.number,
//                          textAlign: TextAlign.center,
//                          controller: myController,
//                          decoration: InputDecoration(
//                              icon: Icon(Icons.monetization_on),
//                              border: OutlineInputBorder()),
//                        ),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          children: <Widget>[
//                            Expanded(
//                              child: RoundedButton(
//                                  color: Colors.red,
//                                  buttonTitle: 'take',
//                                  onPressed: () async {
//                                    setState(() {
//                                      showSpinner = true;
//                                      initBalance = storePointModel.points;
//                                      _metal = int.parse(myController.text);
//                                      newBalance = initBalance - _metal;
//                                    });
//
//                                    if (_metal > initBalance) {
//                                      showSpinner = false;
//                                      Alert(
//                                              context: context,
//                                              title: "Not enough balance",
//                                              type: AlertType.error,
//                                              desc:
//                                                  "You don't have enough balance, only: $initBalance")
//                                          .show();
//                                    } else {
//                                      await DatabaseService(
//                                              uid: userModel.uid,
//                                              storeId: storeUserModel.fromStore)
//                                          .updateStorePointData(
//                                              name: storePointModel.name,
//                                              points: newBalance);
//
//                                      DatabaseService().updateUserDataInDB(
//                                          collectionName: 'users',
//                                          selectedDoc:
//                                              currentStoreUserDocumentID,
//                                          newValues: {
//                                            'points_received':
//                                                storeUserModel.pointsReceived +
//                                                    _metal
//                                          });
//                                      _clearValues();
//                                    }
//                                  }),
//                            ),
//                            Expanded(
//                              child: RoundedButton(
//                                  color: Colors.green,
//                                  buttonTitle: 'give',
//                                  onPressed: () async {
//                                    setState(() {
//                                      showSpinner = true;
//                                      initBalance = storePointModel.points;
//                                      _metal = int.parse(myController.text);
//                                      newBalance = initBalance + _metal;
//                                    });
//
//                                    await DatabaseService(
//                                            uid: userModel.uid,
//                                            storeId: storeUserModel.fromStore)
//                                        .updateStorePointData(
//                                            name: storePointModel.name,
//                                            points: newBalance);
//                                    DatabaseService().updateUserDataInDB(
//                                        collectionName: 'users',
//                                        selectedDoc: currentStoreUserDocumentID,
//                                        newValues: {
//                                          'points_gave':
//                                              storeUserModel.pointsGave + _metal
//                                        });
//                                    _clearValues();
//                                  }),
//                            ),
//                          ],
//                        ),
                        Center(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new FloatingActionButton(
                                onPressed: minus,
                                child: new Icon(
                                    const IconData(0xe15b,
                                        fontFamily: 'MaterialIcons'),
                                    color: Colors.black),
                                backgroundColor: Colors.white,
                              ),
                              new Text('$_n',
                                  style: new TextStyle(fontSize: 60.0)),
                              new FloatingActionButton(
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
                                    buttonTitle: 'free coffee!',
                                    onPressed: () async {
                                      setState(() {
                                        showSpinner = true;
                                        initCoffeeNumber =
                                            storePointModel.currentCoffeeNumber;
                                        stampCardReward =
                                            storePointModel.storeReward;
                                        newCoffeeNumber =
                                            initCoffeeNumber - stampCardReward;

                                        print(_metal);
                                        print(newCoffeeNumber);
                                      });

                                      if (initCoffeeNumber <
                                          storePointModel.storeReward) {
                                        showSpinner = false;
                                        Alert(
                                                context: context,
                                                title:
                                                    "Not enough coffees collected",
                                                type: AlertType.error,
                                                desc:
                                                    "You have purchased only: $initCoffeeNumber.")
                                            .show();
                                      } else {
//                                        await DatabaseService(
//                                                uid: userModel.uid,
//                                                storeId:
//                                                    storeUserModel.fromStore)
//                                            .updateStorePointData(
//                                                name: storePointModel.name,
//                                                storeReward:
//                                                    storePointModel.storeReward,
//                                                currentCoffee: newCoffeeNumber,
//                                                totalCoffees: storePointModel
//                                                        .totalCoffees +
//                                                    1);

                                        DatabaseService().updateUserDataInDB(
                                            collectionName: 'users',
                                            selectedDoc:
                                                currentStoreUserDocumentID,
                                            newValues: {
                                              'coffees_treated': storeUserModel
                                                      .coffeesTreated +
                                                  1
                                            });
                                        _clearValues();
                                      }
                                    }),
                              ),
                              Expanded(
                                child: RoundedButton(
                                    color: Colors.green,
                                    buttonTitle: 'stamp',
                                    onPressed: () async {
                                      setState(() {
                                        showSpinner = true;
                                        initCoffeeNumber =
                                            storePointModel.currentCoffeeNumber;
                                        _metal = _n;
                                        newCoffeeNumber =
                                            initCoffeeNumber + _metal;
                                        usertotalCoffees =
                                            storePointModel.totalCoffees +
                                                _metal;
                                        print(_metal);
                                        print(newCoffeeNumber);
                                      });

//                                      await DatabaseService(
//                                              uid: userModel.uid,
//                                              storeId: storeUserModel.fromStore)
//                                          .updateStorePointData(
//                                        name: storePointModel.name,
//                                        storeReward:
//                                            storePointModel.storeReward,
//                                        currentCoffee: newCoffeeNumber,
//                                        totalCoffees: usertotalCoffees,
//                                      );
                                      DatabaseService().updateUserDataInDB(
                                          collectionName: 'users',
                                          selectedDoc:
                                              currentStoreUserDocumentID,
                                          newValues: {
                                            'coffees_gave':
                                                storeUserModel.coffeesGave +
                                                    _metal
                                          });
                                      _clearValues();
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.camera_alt),
            label: Text('Scan'),
            onPressed: _scanQR,
//                  () async {
//                name = 'i9Cg4mGoe4f2xcfj3o2hVo9YV5C2';
//                userModel = UserData(uid: name);
//                currentUserDocumentID = name;
//                print(currentUserDocumentID);
//                getStoreUser();
//                print(storeUserModel.fromStore);
//                print(storeDataModel.title);
//
//                Firestore.instance
//                    .collection('users')
//                    .document(name)
//                    .collection('stores')
//                    .document(storeUserModel.fromStore)
//                    .get()
//                    .then((DocumentSnapshot docs) {
//                  if (docs.exists) {
//                    storePointModel = StorePoint(
//                      name: docs.data['name'],
//                      points: docs.data['points'],
//                      currentCoffeeNumber: docs.data['current_coffee_number'],
//                      totalCoffees: docs.data['total_coffees'],
//                      storeReward: storeDataModel.stampCardReward,
//                    );
//
//                    if (storePointModel.currentCoffeeNumber == null ||
//                        storePointModel.totalCoffees == null) {
//                      print('user is from previous version');
//
//                      Firestore.instance
//                          .collection('users')
//                          .document(name)
//                          .collection('stores')
//                          .document(storeUserModel.fromStore)
//                          .setData({
//                        'name': storeDataModel.title,
//                        'points': docs.data['points'],
//                        'current_coffee_number': 0,
//                        'total_coffees': 0,
//                        'store_reward': storeDataModel.stampCardReward,
//                      });
//
//                      storePointModel = StorePoint(
//                        name: storeDataModel.title,
//                        points: docs.data['points'],
//                        currentCoffeeNumber: 0,
//                        totalCoffees: 0,
//                        storeReward: storeDataModel.stampCardReward,
//                      );
//                    }
//
//                    print('got StorePoint Model: ${storePointModel.points}');
//                    print(
//                        'current coffee: ${storePointModel.currentCoffeeNumber} , total coffees: ${storePointModel.totalCoffees}, store reward: ${storePointModel.storeReward}');
//                  } else {
//                    print('first time user coming');
//
//                    Firestore.instance
//                        .collection('users')
//                        .document(name)
//                        .collection('stores')
//                        .document(storeUserModel.fromStore)
//                        .setData({
//                      'name': storeDataModel.title,
//                      'points': 0,
//                      'current_coffee_number': 0,
//                      'total_coffees': 0,
//                      'store_reward': storeDataModel.stampCardReward,
//                    });
//
//                    storePointModel = StorePoint(
//                      name: storeDataModel.title,
//                      points: 0,
//                      currentCoffeeNumber: 0,
//                      totalCoffees: 0,
//                      storeReward: storeDataModel.stampCardReward,
//                    );
//                    print(
//                        'created StorePoint Model: ${storePointModel.points}');
//                    print(
//                        'created current coffee: ${storePointModel.currentCoffeeNumber} , total coffees: ${storePointModel.totalCoffees}, store reward: ${storePointModel.storeReward}');
//                  }
//                  setState(() {
//                    qrValue = name;
//                  });
//                });
//              }
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }
}
