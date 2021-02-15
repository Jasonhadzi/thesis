import 'package:flutter/material.dart';

const kBackgroundColor = Color(0xffe7e9f0);
const kDisabledBackgroundColor = Color(0xff757575);
const kAppBarTitleStyle = TextStyle(
  color: Colors.black54,
  fontWeight: FontWeight.bold,
  fontSize: 21.0,
);

const kCreditCardShadowColor = Color(0xffb3e5fc);
const kCreditCardColor1 = Color(0xff64b5f6);
const kOrange = Color(0xffff8a73);
const kCreditCardColor2 = Color(0xff81d4fa);
const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kCardDetailsTextStyle = TextStyle(color: Colors.black, fontSize: 13.0);
const kCardUserDetailsTextStyle =
    TextStyle(color: Colors.black, fontSize: 20.0);
const kCardUserIDCodeTextStyle =
    TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500);

const kStoreTitleTextStyle =
    TextStyle(color: Colors.black, fontSize: 50.0, fontWeight: FontWeight.w700);
const kStoresListTextStyle =
    TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w300);
const kPointsTitleTextStyle =
    TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.w500);
const kDirectionsTextStyle = TextStyle(
  fontSize: 18.0,
);
