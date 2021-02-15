import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wolie_mobile/components/rounded_button.dart';
import 'package:wolie_mobile/constants.dart';
import 'package:wolie_mobile/models/store.dart';
import 'package:wolie_mobile/models/user.dart';
import 'package:wolie_mobile/screens/services/database.dart';

class RequestPointsScreen extends StatefulWidget {
  static const routeName = '/requestPoints';
  @override
  _RequestPointsScreenState createState() => _RequestPointsScreenState();
}

class _RequestPointsScreenState extends State<RequestPointsScreen> {
  UserData userDataModel;
  StorePoint storePointModel;
  StoreUser storeUserModel;
  StoreData storeDataModel;
  UserRequest userRequest;

  double initBalance;
  var doubleBeforeConvert = 0.0;
  double _metal = 0.0;
  int _tableNumber = 0;
  double newBalance;
  double moneyToPointsValue;
  String currentUserDocumentID, currentStoreUserDocumentID;
  bool showSpinner = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Start listening to changes.
    myController.addListener(_printLatestValue);
    myTableNumberController.addListener(_printLatestValue);
  }

  final myController = TextEditingController();
  final myTableNumberController = TextEditingController();
  _printLatestValue() {
    print("Points text field: ${myController.text}");
    print('Table text fiels: ${myTableNumberController.text}');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
    myController.dispose();
    myTableNumberController.dispose();
  }

  void _back() {
    _clearValues();
    Navigator.pop(context);
  }

  _clearValues() {
    setState(() {
      newBalance = 0;
      myController.text = "";
      myTableNumberController.text = '';
      initBalance = 0;
      currentUserDocumentID = "";
      showSpinner = false;
      doubleBeforeConvert = 0.0;
    });
  }

  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  Widget build(BuildContext context) {
    final PassingArguments args = ModalRoute.of(context).settings.arguments;

    storeUserModel = args.storeUserModel;
    storeDataModel = args.storeDataModel;
    storePointModel = args.storePointModel;
    userDataModel = args.userDataModel;

    return GestureDetector(
      onTap: () {
        //hide the keyboard when the user taps everywhere else
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xffe7e9f0),
        appBar: AppBar(
          title: Text('Wolie'),
          backgroundColor: Colors.blueAccent[200],
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Store Name:',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      storeDataModel.title,
                      style: kDirectionsTextStyle,
                    ),
                    storeUserModel.hasTables
                        ? Column(
                            children: <Widget>[
                              SizedBox(
                                height: 18.0,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: 'Table Number: ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            "Enter your table number. If it's takeaway type 0.",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              // Text('StorePoint Balance: ${storePointModel.points}'),
//                  Text('User Init Balance: $initBalance'),
//                  Text('User New Balance: $newBalance'),
                              TextFormField(
                                validator: (val) => val.isEmpty
                                    ? 'Enter your table number'
                                    : null,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                controller: myTableNumberController,
                                decoration: kTextFieldDecoration.copyWith(
                                    hintText: 'Enter your table number'),
                              ),
                            ],
                          )
                        : SizedBox(
                            height: 20,
                          ),
                    RichText(
                      text: TextSpan(
                          text: 'Claim points: ',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Type the amount of € you paid.',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Redeem points: ',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Type the points you wish to redeem.',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (val) =>
                              val.isEmpty ? 'Enter a value' : null,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            BlacklistingTextInputFormatter(RegExp("[.]"))
                          ],
                          textAlign: TextAlign.center,
                          controller: myController,
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: RoundedButton(
                                  color: Colors.red,
                                  buttonTitle: 'Redeem points',
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      //we have valid form code
                                      initBalance =
                                          storePointModel.points.toDouble();

                                      doubleBeforeConvert =
                                          double.parse(myController.text);
                                      _metal = double.parse(doubleBeforeConvert
                                          .toStringAsFixed(2));
                                      storeUserModel.hasTables
                                          ? _tableNumber = int.parse(
                                              myTableNumberController.text)
                                          : _tableNumber = 0;
                                      print('table number: $_tableNumber');
                                      //moneyToPointsValue =
                                      //_metal * storeDataModel.wolieValue;
                                      print(_metal);

                                      newBalance = initBalance - _metal;

                                      if (_metal > initBalance) {
                                        showSpinner = false;
                                        Alert(
                                                context: context,
                                                title: "Not enough points",
                                                type: AlertType.error,
                                                desc:
                                                    "You don't have enough points, only: $initBalance")
                                            .show();
                                      } else {
                                        userRequest = UserRequest(
                                            name: userDataModel.name,
                                            quantity: _metal,
                                            status: 'pending',
                                            description: 'redeem points',
                                            userId: userDataModel.uid,
                                            newUserPoints: newBalance,
                                            storeName: storePointModel.name,
                                            tableNumber: _tableNumber);

                                        await DatabaseService(
                                                storeId:
                                                    storeUserModel.fromStore)
                                            .updateUsersRequestsData(
                                                userRequest: userRequest);
                                        _back();
                                      }
                                    }
                                  }),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: RoundedButton(
                                  color: Colors.green,
                                  buttonTitle: 'Claim points',
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      //we have valid form code
                                      initBalance =
                                          storePointModel.points.toDouble();
                                      doubleBeforeConvert = double.parse(
                                          myController.text
                                              .replaceAll(',', '.'));
                                      _metal = double.parse(doubleBeforeConvert
                                          .toStringAsFixed(2));
                                      storeUserModel.hasTables
                                          ? _tableNumber = int.parse(
                                              myTableNumberController.text)
                                          : _tableNumber = 0;
                                      print('table number: $_tableNumber');

                                      moneyToPointsValue =
                                          _metal * storeDataModel.wolieValue;
                                      print(moneyToPointsValue);
                                      newBalance =
                                          initBalance + moneyToPointsValue;

                                      userRequest = UserRequest(
                                          name: userDataModel.name,
                                          quantity: _metal,
                                          status: 'pending',
                                          description: '€',
                                          userId: userDataModel.uid,
                                          newUserPoints: newBalance,
                                          storeName: storePointModel.name,
                                          storeReward:
                                              storeDataModel.wolieValue,
                                          tableNumber: _tableNumber);

                                      await DatabaseService(
                                              storeId: storeUserModel.fromStore)
                                          .updateUsersRequestsData(
                                              userRequest: userRequest);

                                      _back();
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
