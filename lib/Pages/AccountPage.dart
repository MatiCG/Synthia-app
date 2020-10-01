import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.black,
            ),
            onPressed: () {
              isEditing = isEditing ? false : true;
            },
          )
        ],
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
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
              style: TextStyle(fontSize: 12, color: Colors.grey),
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
          Card(
            elevation: 10,
            color: Colors.blueAccent,
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
            text: isEditing ? 'Sauvegarder' : 'Se deconnecter',
            icon: isEditing ? Icons.save_alt : Icons.power_settings_new,
            action: isEditing
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
                      }
                    });
                    setState(() {
                      isEditing = false;
                    });
                  }
                : () async {
                    await _auth.signOut();
                    onSignOut();
                  },
            backgroundColor: isEditing ? Colors.blueGrey : Colors.red.shade600,
          ),
        ],
      ),
    );
  }
}