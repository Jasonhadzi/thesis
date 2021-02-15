import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wolie_mobile/components/custom_rounded_container.dart';
import 'package:wolie_mobile/components/rounded_button.dart';
import 'package:wolie_mobile/models/store.dart';
import 'package:wolie_mobile/models/user.dart';
import 'package:wolie_mobile/screens/home/stores_list.dart';
import 'package:wolie_mobile/screens/services/database.dart';

import '../../constants.dart';

class StoresScreen extends StatefulWidget {
  @override
  _StoresScreenState createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  String value;

  final myController = TextEditingController();

  final _formKey2 = GlobalKey<FormState>();

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

    return StreamProvider<List<StoreData>>.value(
      value: DatabaseService().storeData,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Stores:',
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
              Expanded(child: CustomRoundedContainer(child: StoresList())),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding:
              const EdgeInsets.only(left: 28, right: 28, bottom: 28, top: 10),
          child: RoundedButton(
            buttonTitle: "Sugget a Store",
            color: Colors.blueAccent[200],
            onPressed: () async {
              try {
                Alert(
                    context: context,
                    title:
                        "Type the name of the store you want to suggest to join the wolie loyalty program.",
                    content: Form(
                      key: _formKey2,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: (val) =>
                                val.isEmpty ? 'Enter the store name' : null,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.center,
                            controller: myController,
                          ),
                        ],
                      ),
                    ),
                    buttons: [
                      DialogButton(
                        onPressed: () async {
                          if (_formKey2.currentState.validate()) {
                            value = myController.text;
                            print('value: $value');
                            _back();

                            try {
                              await DatabaseService(uid: user.uid)
                                  .addASuggestionInDB(storeName: value);
                              Alert(
                                context: context,
                                title: "Success!",
                                type: AlertType.success,
                                desc: "Your suggestion has sent!",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "OK",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pop(context),
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
                        },
                        child: Text(
                          "Suggest",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    ]).show();
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
      ),
    );
  }
}
