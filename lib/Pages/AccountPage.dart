import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:synthiaapp/Widgets/ModificationDialog.dart';
import 'package:synthiaapp/Widgets/SynthiaButton.dart';
import '../Models/User.dart';

class AccountPage extends StatefulWidget {
  AccountPage({this.onSignOut}) : super();

  final VoidCallback onSignOut;
  @override
  Account createState() => Account(onSignOut: onSignOut);
}

class Account extends State<AccountPage> {
  Account({this.onSignOut});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User _user = User();
  final VoidCallback onSignOut;
  List<TextEditingController> controllers;
  List<String> icons;
  List<String> titles;
  bool isEditing;

  @override
  void initState() {
    super.initState();

    isEditing = false;
    titles = ['Pseudonyme', 'Entreprise', 'Poste', 'Numéro de téléphone'];
    icons = [
      'assets/name.png',
      'assets/company.png',
      'assets/work.png',
      'assets/phone.png'
    ];
    controllers = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController()
    ];
  }

  void setEditing(bool value) {
    setState(() {
      isEditing = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: _user.init(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return accountWidget();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  ListView createFields(List<String> icons, List<String> titles,
      List<String> values, bool edit, List<TextEditingController> controllers) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            width: 35.0,
            alignment: AlignmentDirectional.centerStart,
            child: Image.asset(icons[index]),
          ),
          title: Transform(
            transform: Matrix4.translationValues(16, 0.0, 0.0),
            child: Text(
              titles[index],
              style: TextStyle(
                  fontSize: 12, color: Color.fromRGBO(58, 66, 86, 1.0)),
            ),
          ),
          subtitle: Transform(
            transform: Matrix4.translationValues(16, 0.0, 0.0),
            child: edit == false
                ? Text(
                    values[index],
                    style: TextStyle(fontSize: 15),
                  )
                : TextField(
                    controller: controllers[index],
                    style: TextStyle(fontSize: 15),
                    decoration:
                        InputDecoration.collapsed(hintText: values[index]),
                  ),
          ),
        );
      },
    );
  }

  SingleChildScrollView accountWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
      child: Column(
        children: [
          Stack(children: [
            Card(
              elevation: 10,
              color: Color.fromRGBO(58, 66, 86, 0.9),
              margin: const EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset(
                          'assets/profile.png',
                          height: 75,
                          width: 75,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      _user.getFullName(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    margin: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                  ),
                  Container(
                    child: Text(
                      _user.getEmail(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                    margin: const EdgeInsets.fromLTRB(0, 4.0, 0, 32.0),
                  )
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () {
                  bool hasChange = false;
                  controllers.forEach((controller) {
                    if (controller.text.isNotEmpty) {
                      hasChange = true;
                    }
                  });

                  if (isEditing && hasChange) {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return ModificationDialog(
                            title: 'Modification en cours',
                            content:
                                'Vos modifications ne seront pas sauvegardée !',
                            controllers: controllers,
                            setEditing: setEditing,
                            context: context,
                          );
                        });
                  } else {
                    setEditing(!isEditing);
                  }
                },
                icon: Icon(
                  !isEditing ? Icons.edit : Icons.cancel,
                  color: Colors.white,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 25.0),
          createFields(
              icons,
              titles,
              [
                _user.getUsername(),
                _user.getCompany(),
                _user.getJob(),
                _user.getPhoneNumber()
              ],
              isEditing,
              controllers),
          SynthiaButton(
            top: 64.0,
            bottom: 32.0,
            text: isEditing ? 'Sauvegarder' : 'Se deconnecter',
            leadingIcon: isEditing ? Icons.save_alt : Icons.power_settings_new,
            onPressed: isEditing
                ? () {
                    List<Function> update = [
                      _user.setUsername,
                      _user.setCompany,
                      _user.setJob,
                      _user.setPhoneNumber
                    ];
                    controllers.forEach((e) {
                      if (e.text.isNotEmpty) {
                        update[controllers.indexOf(e)](e.text);
                        e.clear();
                      }
                    });
                    setEditing(false);
                  }
                : () async {
                    await _auth.signOut();
                    onSignOut();
                  },
            color: isEditing ? Colors.blueGrey : Colors.red.shade600,
          )
        ],
      ),
    );
  }
}
