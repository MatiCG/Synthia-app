import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'auth.dart';
import 'Services/Mailer.dart';

class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email can\'t be empty.' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Password can\'t be empty.' : null;
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth, this.onSignIn}) : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum FormType {
  login,
  register
}

class _LoginPageState extends State<LoginPage> {
  static final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;
  String _authHint = '';

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        String userId = _formType == FormType.login
            ? await widget.auth.signIn(_email, _password)
            : await widget.auth.createUser(_email, _password);
        setState(() {
          _authHint = 'Signed In\n\nUser id: $userId';
        });
          if (_formType == FormType.register) {
            Map<String, dynamic> toJson() =>
            {
              "from": {
                'email': "synthia@no-reply.com",
              },
              "personalizations": [{
                "to": [{
                  "email": _email
                }],
                "dynamic_template_data": {
                  "name": _email.substring(0, _email.indexOf('@'))
                }
              }],
              "template_id": "d-f9371f5562984dcd8f2e21ca75423924"
            };
            Mailer mailer = new Mailer();
            await mailer.sendMail(toJson());
          }
        widget.onSignIn();
      }
      catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      _authHint = '';
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
      _authHint = '';
    });
  }

  Widget inputEmail() {
    return Padding(
        padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
        child: new TextFormField(
        key: new Key('email'),
        decoration: new InputDecoration(border: InputBorder.none,
          fillColor: Colors.lightBlueAccent,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          labelText: 'E-mail',
          labelStyle: TextStyle(
            color: Colors.white70,
          ),
        ),
        style: TextStyle(color: Colors.white),
        autocorrect: false,
        validator: EmailFieldValidator.validate,
        onSaved: (val) => _email = val,
      )
    );
  }

  Widget inputPassword() {
    return Padding(
        padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
        child: new TextFormField(
          key: new Key('password'),
          decoration: new InputDecoration(border: InputBorder.none,
            fillColor: Colors.lightBlueAccent,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.white,
                width: 2.0,
              ),
            ),
            labelText: 'Password',
            labelStyle: TextStyle(
              color: Colors.white70,
            ),
          ),
          style: TextStyle(color: Colors.white),
          obscureText: true,
          autocorrect: false,
          validator: PasswordFieldValidator.validate,
          onSaved: (val) => _password = val,
        )
    );
  }

  Widget submitButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 50, left: 200),
      child: Container(
        alignment: Alignment.bottomRight,
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blue[300],
              blurRadius: 10.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                5.0, // horizontal, move right 10
                5.0, // vertical, move down 10
              ),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: FlatButton(
          onPressed: validateAndSubmit,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'OK',
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
    );
  }

  Widget firstTime() {
    switch (_formType) {
      case FormType.login:
        return Padding(
          padding: const EdgeInsets.only(top: 30, left: 30),
          child: Container(
            alignment: Alignment.topRight,
            //color: Colors.red,
            height: 20,
            child: Row(
              children: <Widget>[
                Text(
                  'Your first time?',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                FlatButton(
                  padding: EdgeInsets.all(0),
                  key: new Key('need-account'),
                  onPressed: moveToRegister,
                  child: Text(
                    'Sign up',
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
        );
      case FormType.register:
        return Padding(
          padding: const EdgeInsets.only(top: 30, left: 30),
          child: Container(
            alignment: Alignment.topRight,
            //color: Colors.red,
            height: 20,
            child: Row(
              children: <Widget>[
                Text(
                  'Already an account',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                FlatButton(
                  padding: EdgeInsets.all(0),
                  key: new Key('register'),
                  onPressed: moveToLogin,
                  child: Text(
                    'Sign in',
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
        );
    }
    return null;
  }

  Widget hintText() {
    return new Container(
      //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: new Text(
            _authHint,
            key: new Key('hint'),
            style: new TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center)
    );
  }

  Widget verticalText() {
    switch (_formType) {
      case FormType.login:
        return Padding(
          padding: const EdgeInsets.only(top: 20, left: 30),
          child: RotatedBox(
              quarterTurns: -1,
              child: Text(
                'Sign in',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                ),
              )),
        );
      case FormType.register:
        return Padding(
          padding: const EdgeInsets.only(top: 20, left: 30),
          child: RotatedBox(
              quarterTurns: -1,
              child: Text(
                'Sign up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                ),
              )),
        );
    }
    return null;
  }

  Widget textLogin() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 40),
      child: Container(
        height: 200,
        width: 300,
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
            ),
            Center(
              child: Text(
                'Synthia\n'
                    'Simpler meetings\n'
                    'Better Synthesis',
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
    );
  }

  Widget logo() {
    return Padding(
        padding: const EdgeInsets.only(left:100.0, right: 100.0, top:100),
        child: Container(
          alignment: Alignment.bottomCenter,
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
              color: Colors.blue[300],
              blurRadius: 10.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                5.0, // horizontal, move right 10
                5.0, // vertical, move down 10
              ),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
            child: Container(
              child: Image(
                image: AssetImage('assets/logo.png'),
                height: 70,
              ),
            )
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueGrey[900], Colors.lightBlueAccent]),
        ),
        child: ListView(
          children: <Widget>[
            new Container(
              child: new Form(
                key: formKey,
                child: new Column(
              children: <Widget>[
                  Row(children: <Widget>[
                    verticalText(),
                     textLogin(),
                  ]),
                  inputEmail(),
                  inputPassword(),
                  submitButton(),
                  firstTime(),
                  hintText(),
                  logo(),
                ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}