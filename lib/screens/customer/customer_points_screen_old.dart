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
      userModel = UserData(uid: name);
      currentUserDocumentID = name;
      print(currentUserDocumentID);
      getStoreUser();
      print(storeUserModel.fromStore);
      print(storeDataModel.title);

//                await DatabaseService(storeId: storeUserModel.fromStore)
//                    .getSpecificStorePointData(userId: name)

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
          );
          print('got StorePoint Model: ${storePointModel.points}');
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
          });

          storePointModel = StorePoint(
            name: storeDataModel.title,
            points: 0,
          );
          print('got StorePoint Model: ${storePointModel.points}');
        }
        setState(() {
          qrValue = name;
        });
      });
//                await DatabaseService()
//                    .getCurrentUserID(collectionName: 'users', uid: name)
//                    .then((QuerySnapshot docs) {
//                  if (docs.documents.isNotEmpty) {
//                    userModel = UserData(
//                      name: docs.documents[0].data['name'],
//                      uid: name,
//                      registrationDate:
//                          docs.documents[0].data['date_registered'],
//                    );
//
//                  } else {
//                    print('empty');
//                  }
//                });

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

//        await DatabaseService()
//            .getCurrentUserID(
//                collectionName: 'store_users', uid: loggedInUser.uid)
//            .then((QuerySnapshot docs) {
//          if (docs.documents.isNotEmpty) {
//            storeUserModel = StoreUser(
//                uid: loggedInUser.uid,
//                email: loggedInUser.email,
//                fromStore: docs.documents[0].data['from_store'],
//                pointsGave: docs.documents[0].data['points_gave'],
//                pointsReceived: docs.documents[0].data['points_received']);
//
//            currentStoreUserDocumentID = docs.documents[0].documentID;
//          }
//        });

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
                pointsReceived: ds.data['points_received']);

            currentStoreUserDocumentID = loggedInUser.uid;
          }
        });

        await _firestore
            .collection('stores')
            .document(storeUserModel.fromStore)
            .get()
            .then((DocumentSnapshot ds) {
          // use ds as a snapshot

          if (ds.exists) {
            storeDataModel = StoreData(title: ds.data['name']);
            print('title: ${storeDataModel.title}');
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
                        TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          controller: myController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.monetization_on),
                              border: OutlineInputBorder()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: RoundedButton(
                                  color: Colors.red,
                                  buttonTitle: 'take',
                                  onPressed: () async {
                                    setState(() {
                                      showSpinner = true;
                                      initBalance = storePointModel.points;
                                      _metal = int.parse(myController.text);
                                      newBalance = initBalance - _metal;
                                    });

                                    if (_metal > initBalance) {
                                      showSpinner = false;
                                      Alert(
                                              context: context,
                                              title: "Not enough balance",
                                              type: AlertType.error,
                                              desc:
                                                  "You don't have enough balance, only: $initBalance")
                                          .show();
                                    } else {
//                                      await DatabaseService(
//                                              uid: userModel.uid,
//                                              storeId: storeUserModel.fromStore)
//                                          .updateStorePointData(
//                                              name: storePointModel.name,
//                                              points: newBalance);

                                      DatabaseService().updateUserDataInDB(
                                          collectionName: 'users',
                                          selectedDoc:
                                              currentStoreUserDocumentID,
                                          newValues: {
                                            'points_received':
                                                storeUserModel.pointsReceived +
                                                    _metal
                                          });
                                      _clearValues();
                                    }
                                  }),
                            ),
                            Expanded(
                              child: RoundedButton(
                                  color: Colors.green,
                                  buttonTitle: 'give',
                                  onPressed: () async {
                                    setState(() {
                                      showSpinner = true;
                                      initBalance = storePointModel.points;
                                      _metal = int.parse(myController.text);
                                      newBalance = initBalance + _metal;
                                    });

//                                    await DatabaseService(
//                                            uid: userModel.uid,
//                                            storeId: storeUserModel.fromStore)
//                                        .updateStorePointData(
//                                            name: storePointModel.name,
//                                            points: newBalance);
                                    await DatabaseService().updateUserDataInDB(
                                        collectionName: 'users',
                                        selectedDoc: currentStoreUserDocumentID,
                                        newValues: {
                                          'points_gave':
                                              storeUserModel.pointsGave + _metal
                                        });
                                    _clearValues();
                                  }),
                            ),
                            Expanded(
                              child: RoundedButton(
                                color: Colors.blueAccent,
                                buttonTitle: 'Test',
                                onPressed: () {
                                  print('button pressed');
                                },
                              ),
                            )
                          ],
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
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }
}
