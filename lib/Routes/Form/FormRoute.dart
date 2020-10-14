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
                        icon: Icon(Icons.delete_forever_rounded,
                            color: Colors.red),
                        onPressed: () {
                          setState(() {
                            showSnackBar(widget.members[index] + ' removed!');
                            widget.members.removeAt(index);
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.admin_panel_settings),
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
/*
class _FormState extends State<MyForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _title;
  TextEditingController _description;
  TextEditingController _order;
  var emails = [];

  @override
  void initState() {
    super.initState();

    _title = TextEditingController();
    _description = TextEditingController();
    _order = TextEditingController();

    _auth.currentUser().then((user) {
      emails.add(user.email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
          builder: (context) => SafeArea(
                child: SingleChildScrollView(
                  child: Column(children: [
                    firstCard(context),
                    secondCard(context, emails, State()),
                  ]),
                ),
              )),
    );
  }
}

Widget firstCard(BuildContext context) {
  return AspectRatio(
    aspectRatio: 16 / 18,
    child: Card(
      elevation: 10,
      color: Colors.white,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Stack(children: [
        Positioned(
          top: 10,
          child: Container(
            child: Row(
              children: [
                Column(children: [
                  Text('titre',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(
                    height: 100,
                    width: 200,
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none,
                      ),
                      maxLength: 50,
                      maxLines: 4,
                    ),
                  )
                ]),
                Container(width: 5),
                Column(children: [
                  Text('description',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(
                    height: 100,
                    width: 200,
                    child: TextField(
                      maxLength: 100,
                      maxLines: 4,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  )
                ]),
              ],
            ),
          ),
        ),
        Positioned(
          top: 150,
          child: Column(children: [
            Text('ordre du jour',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(
              height: 500,
              width: 400,
              child: TextField(
                maxLength: 1000,
                maxLines: 7,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
              ),
            )
          ]),
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
            onDateChange: (date) {},
          ),
        )
      ]),
    ),
  );
}

Widget secondCard(BuildContext context, emails, State test) {
  return Container(
    child: Column(children: [
      Align(
        alignment: Alignment.topCenter,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Card(
            elevation: 10,
            child: ListView.builder(
              itemCount: emails.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(8.0),
                  color: Color.fromRGBO(58, 66, 86, 1.0),
                  child: ListTile(
                    trailing: IconButton(
                      icon:
                          Icon(Icons.delete_forever_rounded, color: Colors.red),
                      onPressed: () {
                        test.setState(() {
                          emails.removeAt(index);
                        });
                      },
                    ),
                    title: Text(emails[index],
                        style: TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
            margin: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Column(children: [
          SynthiaButton(
            color: Color.fromRGBO(58, 66, 86, 1.0),
            text: 'Créer la réunion',
            onPressed: () {},
          ),
          FlatButton(
            child: Text('annuler',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ]),
      )
    ]),
  );
}
*/
/*
class _FormState extends State<MyForm> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _title = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _odj = TextEditingController();
  DateTime _date = DateTime.now();

  FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = Firestore.instance;

  var emails = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
            builder: (scaContext) => SafeArea(
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 17,
                        child: Card(
                          child: Stack(children: [
                            Positioned(
                              top: 0,
                              child: Row(children: [
                                FlatButton.icon(
                                  icon: Icon(Icons.arrow_back),
                                  label: Text(''),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton.icon(
                                  icon: Icon(Icons.arrow_back),
                                  label: Text(''),
                                  onPressed: () async {
                                    // Valider data
                                    if (_title.text.isNotEmpty &&
                                        _desc.text.isNotEmpty &&
                                        _odj.text.isNotEmpty &&
                                        emails.length >= 2) {
                                      await databaseReference
                                          .collection('meetings')
                                          .document(Uuid().v1())
                                          .setData({
                                        'title': _title.text,
                                        'description': _desc.text,
                                        'schedule': _date.toString(),
                                        'order': _odj.text,
                                        'members': emails,
                                      });
                                      Navigator.pop(context);
                                    } else {
                                      Scaffold.of(scaContext).showSnackBar(
                                          SnackBar(content: Text('error')));
                                    }
                                  },
                                ),
                              ]),
                            ),
                            Positioned(
                              top: 50,
                              child: Column(children: [
                                titledescInput('titre', _title),
                                titledescInput('description', _desc)
                              ]),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: ordrejourInput())
                          ]),
                          color: Color.fromRGBO(58, 66, 86, 1.0),
                          elevation: 5,
                          margin: const EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: FutureBuilder(
                            future: auth.currentUser(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                // setState(() {
                                if (!emails.contains(snapshot.data.email)) {
                                  emails.add(snapshot.data.email);
                                }
                                // });
                                return Container(
                                  child: Column(children: [
                                    ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          emails != null ? emails.length : 0,
                                      itemBuilder: (context, index) {
                                        return Center(
                                            child: Text(emails[index]));
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Row(children: [
                                            Flexible(
                                              child: TextField(
                                                controller: _controller,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      32.0, 0.0, 0.0, 0.0),
                                              child: ClipOval(
                                                child: Material(
                                                  color: Colors
                                                      .blue, // button color
                                                  child: InkWell(
                                                    splashColor: Colors
                                                        .red, // inkwell color
                                                    child: SizedBox(
                                                        width: 56,
                                                        height: 56,
                                                        child: Icon(Icons.add)),
                                                    onTap: () async {
                                                      List<String> result;
                                                      try {
                                                        result = await auth
                                                            .fetchSignInMethodsForEmail(
                                                                email:
                                                                    _controller
                                                                        .text);
                                                        if (result.length > 0) {
                                                          // Compte existant
                                                          if (emails.contains(
                                                              _controller
                                                                  .text)) {
                                                            Scaffold.of(
                                                                    scaContext)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text('Cette personne participe deja à la réunion')));
                                                            return;
                                                          }
                                                          setState(() {
                                                            if (emails !=
                                                                null) {
                                                              emails.add(
                                                                  _controller
                                                                      .text);
                                                            }
                                                          });
                                                          Scaffold.of(
                                                                  scaContext)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      'ccompte ajouté')));
                                                        } else {
                                                          // Pas de compte
                                                          Scaffold.of(
                                                                  scaContext)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      'pas de compte')));
                                                        }
                                                      } catch (e) {
                                                        PlatformException
                                                            error = e;
                                                        Scaffold.of(scaContext)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(error
                                                                    .message)));
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            )
                                          ]),
                                        ),
                                      ),
                                    )
                                  ]),
                                  width: double.infinity,
                                );
                              } else {
                                return Text('loading');
                              }
                            },
                          ),
                          elevation: 5,
                          margin: const EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      )
                    ],
                  ),
                )));
  }

  Widget titledescInput(final String title, final TextEditingController controller) {
    return Wrap(
      children: [
        Container(
          child: Column(children: [
            Text(title, style: TextStyle(color: Colors.white)),
            SizedBox(
              width: 250,
              height: 55,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Center(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
      ],
    );
  }

  Future<Null> pickDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
//				widget.model.setMeetingSchedule(_date.toString());
      });
    }
  }

  Widget ordrejourInput() {
    return Wrap(children: [
      Container(
        child: Column(children: [
          Text('Ordre du jour',
              style: TextStyle(
                color: Colors.white,
              )),
          SizedBox(
            width: 250,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                controller: _odj,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
          )
        ]),
      ),
    ]);
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:synthiaapp/Models/User.dart';
import '../../Form/meetingInformation.dart';
import '../../Form/meetingSummary.dart';
import '../../Models/FormModel.dart';
import '../../Form/meetingListMembers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyForm extends StatefulWidget {
  MyForm() : super();

  @override
  Form createState() => Form();
}

class Form extends State<MyForm> {
  int _current = 0;
  bool _error = false;
  MeetingData model = MeetingData();
  User user = User();
  final databaseReference = Firestore.instance;

  Step customStep(title, content, index, error) {
    return Step(
        title: Text(_current == index ? title : ''),
        content: content,
        isActive: _current > index ? true : false,
        state: error == true && index == _current
            ? StepState.error
            : _current == index
                ? StepState.editing
                : _current > index ? StepState.complete : StepState.disabled);
  }

  List<Step> getSteps(BuildContext context) {
    List<Step> _steps = [
      customStep('What\'s it about ?', MeetingBasicInfo(model), 0, _error),
      customStep('Who is participating ?', MeetingMembers(model), 1, _error),
      customStep('Summary', MeetingSummary(model), 2, _error)
    ];
    return _steps;
  }

  void pushDataMeeting() async {
    await databaseReference
        .collection('meetings')
        .document(model.getMeetingId())
        .setData(model.getData());
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = getSteps(context);
    return Scaffold(
      appBar: AppBar(title: Text('Create your meeting')),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Stepper(
          type: StepperType.horizontal,
          steps: steps,
          currentStep: _current,
          onStepContinue: () {
            print(model.getData().toString());
            if (model.verify(_current) == false) {
              setState(() {
                _error = true;
                _current = _current;
              });
            } else {
              setState(() {
                _error = false;
                if (_current >= steps.length - 1) {
                  pushDataMeeting();
                  Navigator.pop(context);
                }
                _current < steps.length - 1
                    ? _current++
                    : _current = steps.length - 1;
              });
            }
          },
          onStepCancel: () {
            setState(() {
              _current > 0 ? _current-- : _current = 0;
            });
          },
          onStepTapped: (index) {
            setState(() {
              _current = index;
            });
          },
        ),
      ),
    );
  }
}
*/
