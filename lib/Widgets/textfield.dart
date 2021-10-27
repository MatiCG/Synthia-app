import 'package:flutter/material.dart';

enum FieldsID {
  firstname,
  lastname,
  email,
  password,
  meetingTitle,
  meetingOrder,
  meetingDescription,
  meetingNotes,
}

enum types {
  defaultType,
  password,
  email,
}

class SynthiaTextFieldItem {
  final String title;
  final types type;
  final String hint;
  final bool passwordSubtitle;
  TextEditingController? textController;
  final FieldsID? id;
  Widget? trailing;

  SynthiaTextFieldItem({
    required this.title,
    this.type = types.defaultType,
    this.hint = '',
    this.textController,
    this.passwordSubtitle = false,
    this.id,
    this.trailing,
  });

  set setTrailing(Widget? widget) => trailing = widget;
  Widget? get setTrailing => trailing;
  TextEditingController get controller =>
      textController ?? TextEditingController();
}

class SynthiaTextField extends StatefulWidget {
  final SynthiaTextFieldItem field;
  EdgeInsetsGeometry padding;
  final Function(String? text)? onChange;

  SynthiaTextField({
    required this.field,
    this.padding = const EdgeInsets.all(0.0),
    this.onChange,
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
    if (widget.field.type == types.password) {
      isPassword = true;
    } else {
      isPassword = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmail;
    if (widget.field.type == types.email) {
      isEmail = true;
    } else {
      isEmail = false;
    }
    final Widget? iconPassword = widget.field.type != types.password
        ? null
        : IconButton(
            icon: Icon(hidePasswordIcon, color: Theme.of(context).accentColor),
            onPressed: () {
              setState(() {
                isPassword = !isPassword;
                hidePasswordIcon =
                    isPassword ? Icons.visibility : Icons.visibility_off;
              });
            },
          );

    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle(),
          TextFormField(
            controller: widget.field.controller,
            obscureText: isPassword,
            autocorrect: false,
            onChanged: widget.onChange,
            keyboardType:
                isEmail ? TextInputType.emailAddress : TextInputType.text,
            decoration: InputDecoration(
              hintText: widget.field.hint,
              suffixIcon: widget.field.trailing ?? iconPassword,
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xffB7B7B7),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 8.0,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(183, 183, 183, 1.0),
                ),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(183, 183, 183, 1.0),
                ),
              ),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez remplir ce champ';
              }
              switch (widget.field.type) {
                case types.email:
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'veuillez entrer une adresse e-mail valide';
                  }
                  break;
                case types.password:
                  if (value.length <= 6) {
                    return 'Votre mot de passe doit comporter 8 caractères minimun';
                  }
                  break;
                default:
                  return null;
              }
            },
          ),
          if (widget.field.type == types.password &&
              widget.field.passwordSubtitle)
            buildSubtitle(context)
        ],
      ),
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
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
