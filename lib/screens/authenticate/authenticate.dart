import 'package:flutter/material.dart';
import 'package:wolie_mobile/screens/authenticate/register.dart';
import 'package:wolie_mobile/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = false;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
      //showStoreSignIn = false;
    });
  }

//  void toggleStoreView() {
//    setState(() {
//      showStoreSignIn = true;
//    });
//  }

  @override
  Widget build(BuildContext context) {
//    if (showSignIn && !showStoreSignIn) {
//      return SignIn(toggleView: toggleView, toggleStoreView: toggleStoreView);
//    } else if (!showSignIn && !showStoreSignIn) {
//      return Register(toggleView: toggleView, toggleStoreView: toggleStoreView);
//    } else if (showStoreSignIn) {
//      return StoreSignIn(
//          toggleView: toggleView, toggleStoreView: toggleStoreView);
//    }

    if (!showSignIn) {
      return Register(toggleView: toggleView);
    } else if (showSignIn) {
      return SignIn(toggleView: toggleView);
    }
  }
}
