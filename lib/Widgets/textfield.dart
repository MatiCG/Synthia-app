import 'package:flutter/material.dart';

enum FieldsID {
  FIRSTNAME,
  LASTNAME,
  EMAIL,
  PASSWORD,
  MEETING_TITLE,
  MEETING_ORDER,
  MEETING_DESCRIPTION,
  MEETING_NOTES,
}

enum types {
  DEFAULT,
  PASSWORD,
  EMAIL,
}

class SynthiaTextFieldItem {
  final String title;
  final types type;
  final String hint;
  final bool passwordSubtitle;
  final TextEditingController controller = TextEditingController();
  final FieldsID? id;
  Widget? trailing;

  SynthiaTextFieldItem({
    required this.title,
    this.type = types.DEFAULT,
    this.hint = '',
    this.passwordSubtitle = false,
    this.id,
    this.trailing,
  });

  set setTrailing(Widget widget) => trailing = widget;
}

class SynthiaTextField extends StatefulWidget {
  final SynthiaTextFieldItem field;

  SynthiaTextField({
    required this.field,
  }) : super();

  @override
  _SynthiaTextFieldState createState() => _SynthiaTextFieldState();
}

class _SynthiaTextFieldState extends State<SynthiaTextField> {
  _SynthiaTextFieldState() : super();

  bool isPassword = false;
  IconData hidePasswordIcon = Icons.visibility;

  @override
  void initState() {
    super.initState();
    isPassword = widget.field.type == types.PASSWORD ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    bool isEmail = widget.field.type == types.EMAIL ? true : false;
    Widget? iconPassword = widget.field.type != types.PASSWORD
        ? null
        : IconButton(
            icon: Icon(
              hidePasswordIcon,
              color: Theme.of(context).accentColor),
            onPressed: () {
              setState(() {
                isPassword = !isPassword;
                hidePasswordIcon = isPassword
                  ? Icons.visibility
                  : Icons.visibility_off
              });
            },
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(),
        TextFormField(
          controller: widget.field.controller,
          obscureText: isPassword,
          autocorrect: false,
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
          decoration: InputDecoration(
            hintText: widget.field.hint,
            suffixIcon: widget.field.trailing == null ? iconPassword : widget.field.trailing,
            hintStyle: TextStyle(
              fontSize: 13,
              color: Color(0xffB7B7B7),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 8.0,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(183, 183, 183, 1.0),
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 1.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(183, 183, 183, 1.0),
                width: 1.0,
              ),
            ),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez remplir ce champ';
            }
            switch (widget.field.type) {
              case types.EMAIL:
                if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
                  return 'veuillez entrer une adresse e-mail valide';
                }
                break;
              case types.PASSWORD:
                if (value.length <= 6) {
                  return 'Votre mot de passe doit comporter 8 caractères minimun';
                }
                break;
              default:
                return null;
            }
          },
        ),
        if (widget.field.type == types.PASSWORD && widget.field.passwordSubtitle) buildSubtitle(context)
      ],
    );
  }

  Padding buildSubtitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        'Mot de passe oublié ?',
        style: TextStyle(
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        widget.field.title,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}