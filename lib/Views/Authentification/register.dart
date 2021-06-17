import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/Authentification/home_auth.dart';
import 'package:synthiapp/Controllers/Authentification/register.dart';
import 'package:synthiapp/Widgets/button.dart';
import 'package:synthiapp/Widgets/textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    required this.streamController,
  }) : super();

  final StreamController<screenStatus> streamController;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterController _controller = RegisterController();
  bool isTermsChecked = false;

  @override
  Widget build(BuildContext context) {
    final double leftPadding = MediaQuery.of(context).size.width * 0.05;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 25,
            child: Stack(
              children: [
                buildCloseButton(context),
                buildPageTitle(context, leftPadding),
                buildForm(leftPadding),
                buildValidationButton(context),
              ],
            ),
          ),
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
          key: _controller.model.formKey,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _controller.model.fields.length + 1,
            itemBuilder: (context, index) {
              if (_controller.model.fields.length == index) {
                final double screenHeight = MediaQuery.of(context).size.width;

                return Row(
                  children: [
                    Checkbox(
                      value: isTermsChecked,
                      onChanged: (_) {
                        setState(() {
                          isTermsChecked = !isTermsChecked;
                        });
                      },
                    ),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: screenHeight * 0.035),
                          children: [
                            const TextSpan(text: "J'accepte le "),
                            TextSpan(
                              text: "Contrat d'utilisateur",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                            const TextSpan(text: ' et la '),
                            TextSpan(
                              text: 'Politique de confidentialité',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SynthiaTextField(
                  field: _controller.model.fields[index],
                ),
              );
            },
          ),
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

  Positioned buildPageTitle(BuildContext context, double leftPadding) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      top: 64,
      left: leftPadding,
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: screenHeight * 0.030),
          children: [
            const TextSpan(text: 'Créer votre compte '),
            TextSpan(
              text: 'SynthIA',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ],
        ),
      ),
    );
  }

  Align buildValidationButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: SynthiaButton(
          text: 'Démarrer',
          color: Theme.of(context).accentColor,
          textColor: Theme.of(context).primaryColor,
          onPressed: _controller.submit,
          enable: isTermsChecked,
        ),
      ),
    );
  }
}
