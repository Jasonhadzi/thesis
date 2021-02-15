import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolie_mobile/models/user.dart';
import 'package:wolie_mobile/screens/authenticate/authenticate.dart';
import 'package:wolie_mobile/screens/view_controller.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    print('user: $user');

    //return either home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else if (user != null) {
      return ViewController();
    }
  }
}
