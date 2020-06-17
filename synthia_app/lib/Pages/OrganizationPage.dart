import 'package:flutter/material.dart';

class OrganizationPage extends StatefulWidget {
  OrganizationPage() : super();

  @override
  Organization createState() => Organization();
}

class Organization extends State<OrganizationPage> {
 @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Text('Organization Page'),
    );
  }
}