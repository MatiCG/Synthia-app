import 'dart:async';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/Authentification/home_auth.dart';
import 'package:synthiapp/Controllers/Authentification/login.dart';
import 'package:synthiapp/Widgets/button.dart';
import 'package:synthiapp/Widgets/list.dart';
import 'package:synthiapp/Widgets/textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    required this.streamController,
  }) : super();

  final StreamController<screenStatus> streamController;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginController controller = LoginController(this);

  @override
  Widget build(BuildContext context) {
    final double leftPadding = MediaQuery.of(context).size.width * 0.05;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            buildCloseButton(context),
            buildPageTitle(context, leftPadding),
            buildForm(leftPadding),
            buildLegalMention(context),
            buildValidationButton(context),
          ],
        ),
      ),
    );
  }

  Positioned buildForm(double leftPadding) {
    return Positioned(
      width: MediaQuery.of(context).size.width * 0.9,
      top: 132,
      left: leftPadding,
      child: Center(
        child: Form(
          key: controller.formKey,
          child: SynthiaList(
            isScrollable: false,
            itemCount: controller.data.length,
            itemBuilder: (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: SynthiaTextField(
                  field: controller.data[index] as SynthiaTextFieldItem,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Positioned buildPageTitle(BuildContext context, double leftPadding) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      top: 64,
      left: leftPadding,
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: screenHeight * 0.030),
          children: [
            const TextSpan(text: 'Se connecter à '),
            TextSpan(
              text: 'SynthIA',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ],
        ),
      ),
    );
  }

  Positioned buildCloseButton(BuildContext context) {
    return Positioned(
      top: 0,
      child: IconButton(
        padding: const EdgeInsets.all(16.0),
        icon: const Icon(Icons.close),
        onPressed: () => widget.streamController.add(screenStatus.home),
      ),
    );
  }

  Align buildValidationButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SynthiaButton(
        text: 'Connexion',
        color: Theme.of(context).accentColor,
        textColor: Theme.of(context).primaryColor,
        onPressed: controller.submit,
      ),
    );
  }

  Positioned buildLegalMention(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.3,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Align(
          child: Column(
            children: [
              Text(
                controller.model.errorMsg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (controller.model.errorMsg.isEmpty) ...[
                const Text(
                  'En continuant vous acceptez notre',
                  style: TextStyle(
                    color: Color.fromRGBO(183, 183, 183, 1.0),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        log('Ouvrir la politique de confidentialité');
                      },
                    text: 'politique de confidentialité',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
