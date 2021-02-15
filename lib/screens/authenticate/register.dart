import 'package:flutter/material.dart';
import 'package:wolie_mobile/components/rounded_button.dart';
import 'package:wolie_mobile/screens/services/auth.dart';
import 'package:wolie_mobile/shared/loading.dart';

import '../../constants.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  //final Function toggleStoreView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    //final isStore = Provider.of<Store>(context);
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Register Screen'),
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
                  label: Text('Sign In'),
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
                          'Register',
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
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            name = value;
                          },
                          decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Enter your name'),
                        ),
                        SizedBox(
                          height: 8.0,
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
                          buttonTitle: 'Register',
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              //we have valid form code
                              setState(() {
                                loading = true;
                              });

                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      name, email, password);

                              if (result == null) {
                                setState(() {
                                  error = 'Please give a valid email';
                                  loading = false;
                                });
                              }
                            }

//                    try {
//                      final newUser =
//                          await _auth.createUserWithEmailAndPassword(
//                              email: email, password: password);
//
//                      final createdDate = formatDate(
//                          newUser.user.metadata.creationTime, [mm, '-', yyyy]);
//                      final uid = newUser.user.uid;
//
//                      print(createdDate);
//
//                      if (newUser != null) {
//                        Navigator.pushNamed(context, MainScreen.id);
//
//                        //write the new user in the database
//                        _firestore.collection('users').document().setData({
//                          'date_registered': createdDate,
//                          'uid': uid,
//                          'name': name,
//                          'balance': 0,
//                          'stores_registered': [
//                            'Mikel Karamanli',
//                            'Mikel Cantina'
//                          ],
//                        });
//                      }
//                      setState(() {
//                        showSpinner = false;
//                      });
//                    } catch (e) {
//                      print(e);
//                    }
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
