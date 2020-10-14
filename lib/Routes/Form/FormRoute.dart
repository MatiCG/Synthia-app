import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:synthiaapp/Widgets/SynthiaButton.dart';
import 'package:uuid/uuid.dart';

class MyForm extends StatefulWidget {
  MyForm() : super();

  _FormState createState() => _FormState();
}

class _FormState extends State<MyForm> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _order = TextEditingController();
  final Firestore databaseReference = Firestore.instance;

  List<String> _members = [];
  List<String> _time = [DateFormat('dd/MM/yyyy').format(DateTime.now())];

  void pushData(BuildContext scaffoldContext) async {
    if (_title.text.isNotEmpty &&
        _description.text.isNotEmpty &&
        _order.text.isNotEmpty &&
        _members.length > 1) {
      await databaseReference
          .collection('meetings')
          .document(Uuid().v1())
          .setData({
        'title': _title.text,
        'description': _description.text,
        'schedule': _time[0],
        'order': _order.text,
        'members': _members,
        'reportUrl': '',
      });
      Navigator.pop(context);
    } else {
      Scaffold.of(scaffoldContext)
          .showSnackBar(SnackBar(content: Text('error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              CardData(
                  title: _title,
                  description: _description,
                  order: _order,
                  time: _time),
              CardMembers(members: _members, context: context),
              NavigationButtons(callback: pushData, context: context),
            ]),
          ),
        );
      },
    ));
  }
}

class NavigationButtons extends StatelessWidget {
  NavigationButtons({
    @required this.callback,
    @required this.context
  }) : super();

  final Function callback;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SynthiaButton(
          text: 'Créer la réunion',
          color: Color.fromRGBO(58, 66, 86, 1.0),
          onPressed: () {
            callback(context);
          }),
      FlatButton(
        child: Text('annuler'),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ]);
  }
}

// ignore: must_be_immutable
class CardMembers extends StatefulWidget {
  CardMembers({
    @required this.members,
    @required this.context,
  }) : super();

  List<String> members;
  final BuildContext context;

  _CardMembersState createState() => _CardMembersState();
}

class _CardMembersState extends State<CardMembers> {
  final TextEditingController _member = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _auth.currentUser().then((user) {
      setState(() {
        widget.members.add(user.email);
      });
    });
  }

  showSnackBar(String msg) {
    Scaffold.of(widget.context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.white,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Column(children: [
        Container(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 0, bottom: 0),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
//            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.members != null ? widget.members.length : 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.members[index]),
                trailing: index != 0
                    ? IconButton(
                        icon: Icon(Icons.delete_forever,
                            color: Colors.red),
                        onPressed: () {
                          setState(() {
                            showSnackBar(widget.members[index] + ' removed!');
                            widget.members.removeAt(index);
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.admin_panel_settings_outlined),
                        onPressed: null,
                      ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: InputText(
            title: '',
            extanded: true,
            controller: _member,
            suffixIcon: Icon(Icons.add),
            onIconPressed: () async {
                List<String> result;
                try {
                  result = await FirebaseAuth.instance
                      .fetchSignInMethodsForEmail(email: _member.text);
                  if (result.length > 0 &&
                      !widget.members.contains(_member.text)) {
                        setState(() {
                          widget.members.add(_member.text);
                        });
                      _member.clear();
                  } else if (result.length <= 0) {
                    showSnackBar('Ce compte n\'existe pas.');
                  } else {
                    showSnackBar('${_member.text} participe déjà à la réunion');
                    _member.clear();
                  }
                } catch (e) {
                  PlatformException error = e;
                  showSnackBar(error.message);
                }
            },
          ),
        ),
      ]),
    );
  }
}

// ignore: must_be_immutable
class CardData extends StatefulWidget {
  CardData({
    @required this.title,
    @required this.description,
    @required this.order,
    @required this.time,
  }) : super();

  final TextEditingController title;
  final TextEditingController description;
  final TextEditingController order;
  List<String> time;

  _CardDataState createState() => _CardDataState();
}

class _CardDataState extends State<CardData> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.white,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Wrap(direction: Axis.horizontal, children: [
        Align(
          alignment: Alignment.topCenter,
          child: Wrap(
            children: [
              InputText(title: 'titre', controller: widget.title),
              InputText(title: 'description', controller: widget.description),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: InputText(title: 'ordre du jour', controller: widget.order, extanded: true),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: DatePicker(
            DateTime.now(),
            initialSelectedDate: DateTime.now(),
            deactivatedColor: Colors.red,
            locale: 'fr_FR',
            selectionColor: Color.fromRGBO(58, 66, 86, 1.0),
            selectedTextColor: Colors.white,
            onDateChange: (date) {
              setState(() {
                widget.time[0] = DateFormat('dd/MM/yyyy').format(date);
              });
            },
          ),
        )
      ]),
    );
  }
}

class InputText extends StatelessWidget {
  InputText({
    @required this.title,
    @required this.controller,
    this.textColor = Colors.black,
    this.suffixIcon,
    this.extanded = false,
    this.hint,
    this.onIconPressed,
  }) : super();

  final String title;
  final Color textColor;
  final TextEditingController controller;
  final Icon suffixIcon;
  final bool extanded;
  final String hint;
  final Function onIconPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(children: [
        Text(title,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
        Container(
          color: Colors.white,
          constraints: BoxConstraints(
            maxHeight: 144.0,
            maxWidth: extanded ? double.infinity : 175,
            minHeight: 48.0,
            minWidth: 100.0,
          ),
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
          child: TextField(
            controller: controller,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            autocorrect: true,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      color: Color.fromRGBO(58, 66, 86, 1.0),
                      icon: suffixIcon,
                      onPressed: onIconPressed,
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(
                    color: Color.fromRGBO(58, 66, 86, 1.0), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: Colors.grey, width: 1),
              ),
            ),
          ),
        )
      ]),
    );
  }
}