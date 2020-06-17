import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  AccountPage() : super();

  @override
  Account createState() => Account();
}

class Account extends State<AccountPage> {
 @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Text('Account Page'),
    );
  }
}