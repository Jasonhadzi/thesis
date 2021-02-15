import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wolie_mobile/components/rounded_button.dart';
import 'package:wolie_mobile/screens/services/auth.dart';
import 'package:wolie_mobile/screens/services/database.dart';
import 'package:wolie_mobile/shared/loading.dart';

import '../../constants.dart';

class StoreSignIn extends StatefulWidget {
  final Function toggleView;
  final Function toggleStoreView;

  StoreSignIn({this.toggleView, this.toggleStoreView});

  @override
  _StoreSignInState createState() => _StoreSignInState();
}

class _StoreSignInState extends State<StoreSignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email;
  String password;
  String storeID;
  bool loading = false;
  int selectedRadioTile;
  String error = '';

  @override
  Widget build(BuildContext context) {
    //final isStore = Provider.of<Store>(context);

    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Sign In Store Screen'),
              actions: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    widget.toggleStoreView();
                  },
                  icon: Icon(Icons.store),
                  label: Text('Store'),
                ),
                FlatButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: Icon(Icons.arrow_back_ios),
                  label: Text('Back'),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Store Log In',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 48.0,
                        ),
                        TextFormField(
                          validator: (val) =>
                              val.isEmpty ? 'Enter an email' : null,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Enter your email'),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          validator: (val) => val.length < 6
                              ? 'Enter password 6+ chars long'
                              : null,
                          obscureText: true,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Enter your password'),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
//                        TextFormField(
//                          validator: (val) =>
//                              val.isEmpty ? 'Enter a store code' : null,
//                          textAlign: TextAlign.center,
//                          onChanged: (value) {
//                            storeID = value;
//                          },
//                          decoration: kTextFieldDecoration.copyWith(
//                              hintText: 'Store ID'),
//                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                        SizedBox(
                          height: 14.0,
                        ),
                        RoundedButton(
                          color: Colors.lightBlueAccent,
                          buttonTitle: 'Log In',
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              //we have valid form code
                              setState(() {
                                loading = true;
                              });

                              try {
//                                final bool = await DatabaseService()
//                                    .doesSpecificStoreWithCodeExist(
//                                        collectionName: 'stores',
//                                        storeCode: storeID);
//                                print(bool);
//
//                                if (bool) {
//                                  //store exists
//                                  print("store exists");
//                                } else {
//                                  print('try again');
//                                  Alert(
//                                          context: context,
//                                          title: "Wrong Store Code",
//                                          type: AlertType.error,
//                                          desc: "Type the correct store code")
//                                      .show();
//                                }

                                dynamic result =
                                    await _auth.signInWithEmailandPassword(
                                        email, password);

                                //isws na prepei na valw to sign in ama to store yparxei

                                if (result != null) {
                                } else if (result == null) {
                                  setState(() async {
                                    error =
                                        'could not sign in with those credentials';

                                    loading = false;
                                  });
                                }
                              } catch (e) {
                                print(e.toString());
                              }
                            }

//                            try {
//                              final user =
//                                  await _auth.signInWithEmailAndPassword(
//                                      email: email, password: password);
//                              if (user != null) {
//                                switch (selectedRadioTile) {
//                                  case 1:
//                                    {
//                                      final snapShot = await Firestore.instance
//                                          .collection('store_users')
//                                          .document(storeID)
//                                          .get();
//
//                                      if (snapShot == null ||
//                                          !snapShot.exists) {
//                                        // Document with id == docId doesn't exist.
//                                        print('try again');
//                                        Alert(
//                                                context: context,
//                                                title: "Wrong Store ID",
//                                                type: AlertType.error,
//                                                desc:
//                                                    "Type the correct id, otherwise choose the Customer option")
//                                            .show();
//                                      } else {
//                                        print("selected Store type");
//                                        Navigator.pushNamed(
//                                            context, CustomerScreen.id);
//                                      }
//                                    }
//                                    break;
//                                  case 2:
//                                    {
//                                      print("selected customer type");
//                                      Navigator.pushNamed(
//                                          context, MainScreen.id);
//                                    }
//                                    break;
//                                }
//                              }
//                            } catch (e) {
//                              print(e);
//                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
