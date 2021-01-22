import 'package:flutter/material.dart';
import 'package:synthiaapp/Controllers/login.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.authStatusController}) : super();

  final VoidCallback authStatusController;
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: buildBoxDecoration(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildHeader(),
              buildContent(),
              Expanded(child: Container()),
              buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build content elemnts for login page
  Column buildContent() {
    final String ask = _controller.getFormType() == 'login'
        ? 'Your first time ?'
        : 'Already an account';
    final String btnKey =
        _controller.getFormType() == 'login' ? 'need-account' : 'register';
    final String btnTitle =
        _controller.getFormType() == 'login' ? 'Sign up' : 'Sign in';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
          child: Column(
            children: [
              buildTextFormField(
                'email',
                'Email',
                (String value) {
                  return value.isEmpty ? 'Email can\'t be empty.' : null;
                },
                (value) {
                  _controller.setUserEmail(value);
                },
              ),
              Container(height: 20),
              buildTextFormField(
                'password',
                'Password',
                (String value) {
                  return value.isEmpty ? 'Password can\' t be empty.' : null;
                },
                (value) {
                  _controller.setUserPassword(value);
                },
                isPassword: true,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, right: 50, left: 200),
          child: Container(
            alignment: Alignment.bottomRight,
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: buildBoxDecorationButton(),
            child: FlatButton(
              onPressed: () async {
                await _controller.submitAuthentification(
                    _formKey, widget.authStatusController);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Validate',
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.lightBlueAccent,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 30),
          child: Container(
            alignment: Alignment.topRight,
            height: 20,
            child: Row(
              children: [
                Text(
                  ask,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                FlatButton(
                  padding: EdgeInsets.all(0),
                  key: new Key(btnKey),
                  onPressed: () {
                    _formKey.currentState.reset();
                    _controller.changeFormType();
                  },
                  child: Text(
                    btnTitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              _controller.getAuthErrorMsg(),
              style: TextStyle(
                color: Colors.red.shade200,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build footer elements for login page
  Padding buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(left: 100.0, right: 100.0, bottom: 50.0),
      child: Container(
        alignment: Alignment.bottomCenter,
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: buildBoxDecorationButton(),
        child: Container(
          child: Image(
            image: AssetImage('assets/logo.png'),
            height: 70,
          ),
        ),
      ),
    );
  }

  /// Build BoxDecoration for buttons element
  /// or image elements
  BoxDecoration buildBoxDecorationButton() {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.blue[300],
          blurRadius: 10.0,
          spreadRadius: 1.0,
          offset: Offset(
            5.0,
            5.0,
          ),
        ),
      ],
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
    );
  }

  /// Build header elements for login page
  Row buildHeader() {
    const String synthiaSlogan = 'Synthia\nSimpler meetings\nBetter synthesis';
    final String pageTitle =
        _controller.getFormType() == 'login' ? 'Sign in' : 'Sign up';

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, right: 30, left: 20),
          child: RotatedBox(
            quarterTurns: -1,
            child: Text(
              pageTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
          child: Container(
            child: Column(
              children: [
                Container(height: 60),
                Center(
                  child: Text(
                    synthiaSlogan,
                    style: TextStyle(
                      fontSize: 27,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build a textFormFields for login form
  /// Password to true if textfield input need to be hidden
  TextFormField buildTextFormField(
      String key, String label, Function validator, Function save,
      {isPassword = false}) {
    return TextFormField(
      key: Key(key),
      decoration: InputDecoration(
        border: InputBorder.none,
        fillColor: Colors.lightBlueAccent,
        focusedBorder: _setTextFormBorder(25.0, Colors.blue),
        enabledBorder: _setTextFormBorder(25.0, Colors.white),
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white70,
        ),
      ),
      style: TextStyle(
        color: Colors.white,
      ),
      obscureText: isPassword,
      autocorrect: false,
      validator: validator,
      onSaved: save,
    );
  }

  /// Set border for textform
  OutlineInputBorder _setTextFormBorder(double radius, Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
        color: color,
        width: 2,
      ),
    );
  }

  /// Build box decoration for main container
  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Colors.blueGrey[900], Colors.lightBlueAccent],
      ),
    );
  }
}
