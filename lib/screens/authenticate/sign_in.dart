import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wolie_mobile/components/rounded_button.dart';
import 'package:wolie_mobile/screens/authenticate/reset_password.dart';
import 'package:wolie_mobile/screens/services/auth.dart';
import 'package:wolie_mobile/shared/loading.dart';

import '../../constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  //final Function toggleStoreView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email;
  String password;
  //String storeID;
  bool loading = false;
  //int selectedRadioTile;
  String error = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //selectedRadioTile = 2;
  }

//  void setSelectedRadioValue(int val) {
//    setState(() {
//      selectedRadioTile = val;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    //final isStore = Provider.of<Store>(context);
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Sign In Screen'),
              actions: <Widget>[
//                FlatButton.icon(
//                  onPressed: () {
//                    widget.toggleStoreView();
//                  },
//                  icon: Icon(Icons.store),
//                  label: Text('Store'),
//                ),
                FlatButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: Icon(Icons.person),
                  label: Text('Register'),
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
                          'Log In',
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
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                        FlatButton(
                          child: Text('Forgot Password'),
                          onPressed: () {
                            print('tapped');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetPassword()),
                            );
                          },
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

                              dynamic result = await _auth
                                  .signInWithEmailandPassword(email, password);

                              if (result == null) {
                                setState(() {
                                  error =
                                      'could not sign in with those credentials';
                                  loading = false;
                                });
                              }
                            }

//                      setState(() {
//                        showSpinner = true;
//                      });
//                      try {
//                        final user = await _auth.signInWithEmailAndPassword(
//                            email: email, password: password);
//                        if (user != null) {
//                          switch (selectedRadioTile) {
//                            case 1:
//                              {
//                                final snapShot = await Firestore.instance
//                                    .collection('store_users')
//                                    .document(storeID)
//                                    .get();
//
//                                if (snapShot == null || !snapShot.exists) {
//                                  // Document with id == docId doesn't exist.
//                                  print('try again');
//                                  Alert(
//                                          context: context,
//                                          title: "Wrong Store ID",
//                                          type: AlertType.error,
//                                          desc:
//                                              "Type the correct id, otherwise choose the Customer option")
//                                      .show();
//                                } else {
//                                  print("selected Store type");
//                                  Navigator.pushNamed(
//                                      context, CustomerScreen.id);
//                                }
//                              }
//                              break;
//                            case 2:
//                              {
//                                print("selected customer type");
//                                Navigator.pushNamed(context, MainScreen.id);
//                              }
//                              break;
//                          }
//                        }
//                        setState(() {
//                          showSpinner = false;
//                        });
//                      } catch (e) {
//                        print(e);
//                      }
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
