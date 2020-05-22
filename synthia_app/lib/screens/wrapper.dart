import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synthiaapp/screens/authenticate/authenticate.dart';
import 'package:synthiaapp/screens/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);
    //return Home ou AUthenticate
    return Authenticate();
  }
}
