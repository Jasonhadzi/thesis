import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolie_mobile/components/credit_card.dart';
import 'package:wolie_mobile/components/rounded_button.dart';
import 'package:wolie_mobile/constants.dart';
import 'package:wolie_mobile/models/user.dart';
import 'package:wolie_mobile/screens/services/auth.dart';
import 'package:wolie_mobile/screens/services/database.dart';
import 'package:wolie_mobile/shared/loading.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserData userDataModel;

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Your Personal Card:',
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
              StreamBuilder<UserData>(
                  stream: DatabaseService(uid: user.uid).userData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      UserData userData = snapshot.data;
                      print(userData.name);

                      userDataModel = userData;

                      return CreditCard(
                        data: userData.uid,
                        cardholderName: userData.name,
                        memberSinceDate: userData.registrationDate,
                      );
                    } else {
                      return Loading();
                    }
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Use this card with a friend in order to exchange points or stamps. \n\nTo give: Scan your friends' card. \n\nTo receive: Let your friend scan yours.",
                  style: kStoresListTextStyle,
                  textAlign: TextAlign.justify,
                ),
              ),
              RoundedButton(
                buttonTitle: 'Log out',
                color: Colors.blueAccent,
                onPressed: () async {
                  await _auth.signOut();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
