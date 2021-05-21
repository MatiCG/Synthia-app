import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/right.dart';
import 'package:synthiapp/config/config.dart';

class Provider extends StatefulWidget {
  final Widget child;

  Provider({required this.child}) : super();

  @override
  _ProviderState createState() => _ProviderState();

  static _ProviderState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_Provider>()
            as _Provider)
        .providerData;
  }
}

class _ProviderState extends State<Provider> {
  @override
  void initState() {
    super.initState();

  }

  addUserRight(RightID right) {
    user.addNewRight(right.asString, upload: true);
  }

  removeUserRight(RightID right) {
    user.removeRight(right.asString, upload: true);
  }

  @override
  Widget build(BuildContext context) {
    return _Provider(
      providerData: this,
      child: widget.child,
    );
  }
}

class _Provider extends InheritedWidget {
  final _ProviderState providerData;

  _Provider({
    required this.providerData,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
