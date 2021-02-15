import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../constants.dart';

class CreditCard extends StatelessWidget {
  final String data;
  final String cardholderName;
  final String memberSinceDate;

  CreditCard({this.data, this.cardholderName, this.memberSinceDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, left: 13, right: 13, bottom: 5),
      margin: EdgeInsets.symmetric(vertical: 21, horizontal: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              //Colors.red[200]
              blurRadius: 5.0,
              color: kCreditCardShadowColor,
              offset: Offset(0, 5)),
        ],
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          colors: [
            kCreditCardColor1,
            kCreditCardColor2,

//            Color(0xffff8964),
//            Color(0xffff5d6e),
          ],
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "NAME: ",
                      style: kCardDetailsTextStyle,
                    ),
                    AutoSizeText(
                      cardholderName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "MEMBER SINCE: ",
                      style: kCardDetailsTextStyle,
                    ),
                    AutoSizeText(
                      memberSinceDate,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          QrImage(
            data: data,
            size: 180,
            version: QrVersions.auto,
            backgroundColor: Colors.white,
            errorStateBuilder: (cxt, err) {
              return Container(
                child: Center(
                  child: Text(
                    "Uh oh! Something went wrong... \n Show the code below to a crew member in the register.\n $data",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
