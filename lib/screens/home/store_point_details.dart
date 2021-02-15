import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wolie_mobile/components/rounded_button.dart';
import 'package:wolie_mobile/models/milestone.dart';
import 'package:wolie_mobile/models/store.dart';
import 'package:wolie_mobile/models/user.dart';
import 'package:wolie_mobile/screens/home/milestone_list.dart';
import 'package:wolie_mobile/screens/services/database.dart';

import '../../constants.dart';

class StorePointDetails extends StatefulWidget {
  static const routeName = '/milestonesScreen';
  @override
  _MilestonesScreenState createState() => _MilestonesScreenState();
}

class _MilestonesScreenState extends State<StorePointDetails> {
  StorePoint storePointModel, friendsStorePointModel;
  String friendsUid;
  bool result;
  bool hasPurchased;
  double doubleBeforeConvert;
  double value;
  String errorMessage;

  double functionF(dynamic userCoffeeCount, dynamic storeCoffeeReward) {
    double result;

    if (userCoffeeCount >= storeCoffeeReward) {
      result = 1.0;
    } else {
      double percentValue = (userCoffeeCount / storeCoffeeReward).toDouble();
      result = percentValue;
    }

    return result;
  }

  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myController.addListener(_printLatestValue);
  }

  _printLatestValue() {
    print("Points text field: ${myController.text}");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myController.dispose();
  }

  void _back() {
    myController.text = '';
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final PassingArguments args = ModalRoute.of(context).settings.arguments;

    storePointModel = args.storePointModel;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Wolie'),
        backgroundColor: Colors.blueAccent[200],
        elevation: 0.0,
      ),
      body: storePointModel.hasPoints
          ? StreamProvider<List<Milestone>>.value(
              value:
                  DatabaseService(storeId: storePointModel.storeId).milestones,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Milestones:',
                          style: kStoreTitleTextStyle,
                        ),
                        Text(
                          'Welcome to ${storePointModel.name} loyalty club. Collect points with every purchase in order to get gifts.',
                          style: kStoresListTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: MilestoneList(storePoint: storePointModel)),
                  Center(
                      child: Text(
                    'Your Points: ${double.parse(storePointModel.points.toStringAsFixed(2))}',
                    style: kPointsTitleTextStyle,
                  )),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Stamp Card:',
                        style: kStoreTitleTextStyle,
                      ),
                      Text(
                        'Welcome to ${storePointModel.name} loyalty club. Collect stamps with every purchase in order to get free coffees.',
                        style: kStoresListTextStyle,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
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
                            title: Text(storePointModel.name),
                            subtitle: Text(
                                'Total coffees: ${storePointModel.totalCoffees.toString()}'),
                            trailing: CircleAvatar(
                              radius: 25,
                              child: Icon(
                                Icons.local_drink,
                                color: functionF(
                                          storePointModel.currentCoffeeNumber,
                                          storePointModel.storeReward,
                                        ) ==
                                        1
                                    ? Colors.yellow[700]
                                    : Colors.brown,
                              ),
                              backgroundColor: functionF(
                                        storePointModel.currentCoffeeNumber,
                                        storePointModel.storeReward,
                                      ) ==
                                      1
                                  ? kCreditCardColor1
                                  : Colors.grey[300],
                            ),
                          ),
                        ),
                        new LinearPercentIndicator(
                          linearGradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [kCreditCardColor1, kCreditCardColor2]),
                          animation: true,
                          lineHeight: 20.0,
                          animationDuration: 2500,
                          percent: functionF(
                            storePointModel.currentCoffeeNumber,
                            storePointModel.storeReward,
                          ),
                          center: functionF(
                                    storePointModel.currentCoffeeNumber,
                                    storePointModel.storeReward,
                                  ) ==
                                  1
                              ? Text('Free Coffee!')
                              : Text(
                                  '${storePointModel.currentCoffeeNumber}/${storePointModel.storeReward}',
                                  style: new TextStyle(fontSize: 12.0),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                    child: Text(
                  'Your Current Coffees: ${storePointModel.currentCoffeeNumber}',
                  style: kPointsTitleTextStyle,
                )),
              ],
            ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(left: 28, right: 28, bottom: 28, top: 10),
        child: RoundedButton(
          buttonTitle: "Give your points/stamps to a friend",
          color: Colors.blueAccent[200],
          onPressed: () async {
            try {
              friendsUid = await BarcodeScanner.scan();
              //TODO uncomment this line

              //friend1 ta
              //friendsUid = 't2vGg2Xda8cf63iegM0snKS3Mto1';
              //friend2 t
              //friendsUid = 'sl7syixMFCOggi84d0ajcDDhDLj1';

              result = await DatabaseService()
                  .doesUserExist(collectionName: 'users', uid: friendsUid);
              print('waiting for result...');
              if (result) {
                print('user exists and is a customer');
                hasPurchased = await DatabaseService(
                        storeId: storePointModel.storeId)
                    .checkIfUserHasStoreInSubCollection(uidToCheck: friendsUid);

                if (hasPurchased) {
                  print('the user has purchased from the store');
                  //creating model for friend
                  friendsStorePointModel =
                      await DatabaseService(storeId: storePointModel.storeId)
                          .getFriendsStorePointData(friendUid: friendsUid);
                  print(
                      'friends store point model: ${friendsStorePointModel.points}');

                  Alert(
                      context: context,
                      title: "Type the amount you want to give",
                      content: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (val) =>
                                  val.isEmpty ? 'Enter a value' : null,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              textAlign: TextAlign.center,
                              controller: myController,
                            ),
                          ],
                        ),
                      ),
                      buttons: [
                        DialogButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              doubleBeforeConvert =
                                  double.parse(myController.text);
                              value = double.parse(
                                  doubleBeforeConvert.toStringAsFixed(2));
                              print('value: $value');
                              _back();

                              if (storePointModel.hasPoints) {
                                if (value > storePointModel.points) {
                                  Alert(
                                          context: context,
                                          title:
                                              "You don't have that many points",
                                          type: AlertType.error,
                                          desc:
                                              "You currently have ${storePointModel.points} points. Please try again.")
                                      .show();
                                } else {
                                  print('user has that much points');

                                  double newPoints =
                                      storePointModel.points - value;

                                  try {
                                    //give the points to the friend
                                    await DatabaseService()
                                        .updateUserDataInSubCollection(
                                            collectionName: 'users',
                                            selectedDoc: friendsUid,
                                            subCollection: 'stores',
                                            subDocId: storePointModel.storeId,
                                            newValues: {
                                          'points':
                                              friendsStorePointModel.points +
                                                  value,
                                        });
                                    //update the user's points
                                    await DatabaseService()
                                        .updateUserDataInSubCollection(
                                            collectionName: 'users',
                                            selectedDoc: user.uid,
                                            subCollection: 'stores',
                                            subDocId: storePointModel.storeId,
                                            newValues: {
                                          'points': newPoints,
                                          'total_points_traded': storePointModel
                                                  .totalPointsTraded +
                                              value,
                                        });

                                    Alert(
                                      context: context,
                                      title: "Success!",
                                      type: AlertType.success,
                                      desc: "Your transfer has completed!",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "COOL",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          width: 120,
                                        )
                                      ],
                                    ).show();
                                  } catch (e) {
                                    print(e);
                                    Alert(
                                            context: context,
                                            title: 'Something went Wrong',
                                            type: AlertType.error,
                                            desc: e.toString())
                                        .show();
                                  }
                                }
                              } else if (!storePointModel.hasPoints) {
                                if (value >
                                    storePointModel.currentCoffeeNumber) {
                                  Alert(
                                          context: context,
                                          title:
                                              "You don't have that many stamps",
                                          type: AlertType.error,
                                          desc:
                                              "You currently have ${storePointModel.currentCoffeeNumber} stamps. Please try again.")
                                      .show();
                                } else {
                                  print('user has that much stamps');

                                  int newCurrentNumber =
                                      storePointModel.currentCoffeeNumber -
                                          value;

                                  try {
                                    //give the points to the friend
                                    await DatabaseService()
                                        .updateUserDataInSubCollection(
                                            collectionName: 'users',
                                            selectedDoc: friendsUid,
                                            subCollection: 'stores',
                                            subDocId: storePointModel.storeId,
                                            newValues: {
                                          'current_coffee_number':
                                              friendsStorePointModel
                                                      .currentCoffeeNumber +
                                                  value,
                                        });
                                    //update the user's points
                                    await DatabaseService()
                                        .updateUserDataInSubCollection(
                                            collectionName: 'users',
                                            selectedDoc: user.uid,
                                            subCollection: 'stores',
                                            subDocId: storePointModel.storeId,
                                            newValues: {
                                          'current_coffee_number':
                                              newCurrentNumber,
                                          'total_coffees_traded':
                                              storePointModel
                                                      .totalCoffeesTraded +
                                                  value,
                                        });
                                    Alert(
                                      context: context,
                                      title: "Success!",
                                      type: AlertType.success,
                                      desc: "Your transfer has completed!",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "COOL",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          width: 120,
                                        )
                                      ],
                                    ).show();
                                  } catch (e) {
                                    print(e);
                                    Alert(
                                            context: context,
                                            title: 'Something went Wrong',
                                            type: AlertType.error,
                                            desc: e.toString())
                                        .show();
                                  }
                                }
                              }
                            }
                          },
                          child: Text(
                            "Give",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      ]).show();
                } else {
                  Alert(
                          context: context,
                          title: "Your friend is not registered to the store.",
                          type: AlertType.error,
                          desc:
                              "In order to be able to share with friends, they have to have made at least 1 purchase at the specific store.")
                      .show();
                }
              } else {
                Alert(
                        context: context,
                        title: "QR is not from a wolie user",
                        type: AlertType.error,
                        desc:
                            "The QR you scanned is not from a user's wolie card. Please try again.")
                    .show();
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
    );
  }
}
