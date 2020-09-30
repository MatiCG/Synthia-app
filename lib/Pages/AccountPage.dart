import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import '../Models/User.dart';

class AccountPage extends StatefulWidget {
  AccountPage({this.onSignOut}) : super();

  final VoidCallback onSignOut;
  @override
  Account createState() => Account(onSignOut: onSignOut);
}

class Account extends State<AccountPage> {
  Account({this.onSignOut});

  FirebaseAuth auth = FirebaseAuth.instance;
  final VoidCallback onSignOut;
  TextEditingController username = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController job = TextEditingController();
  TextEditingController phonenumber = TextEditingController();

  List<String> icons = [
    'assets/name.png',
    'assets/company.png',
    'assets/work.png',
    'assets/phone.png'
  ];
  List<String> titles = [
    'Pseudonyme',
    'Entreprise',
    'Poste',
    'Numéro de téléphone'
  ];

  User _user = User(); // = User('SaDD6a9IY2VgnjDVgHfb68gPoJf1');
  String fullname = 'none';
  bool edit = false;

  @override
  void initState() {
    super.initState();
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
                edit = edit ? false : true;
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
        ));
  }

  ListView createFields(List<TextEditingController> controllers,
      List<String> icons, List<String> titles, List<String> values, bool edit) {
    int length = icons.length;

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: length,
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
//      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
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
              [username, company, job, phonenumber],
              icons,
              titles,
              [
                _user.getUsername(),
                _user.getCompany(),
                _user.getJob(),
                _user.getPhoneNumber()
              ],
              edit),
          const SizedBox(height: 25.0),
//          Expanded(child: Container()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              elevation: 5,
              color: edit ? Colors.blueGrey : Colors.red.shade600,
              margin: const EdgeInsets.fromLTRB(64.0, 32.0, 64.0, 8.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: ListTile(
                leading: Icon(
                  edit ? Icons.save_alt : Icons.power_settings_new,
                  color: Colors.white,
                ),
                title: Text(
                  edit ? 'Sauvegarder' : 'Se deconnecter',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: edit
                    ? () {
                        username.text.isNotEmpty
                            ? _user.setUsername(username.text)
                            : null;
                        company.text.isNotEmpty
                            ? _user.setCompany(company.text)
                            : null;
                        job.text.isNotEmpty ? _user.setJob(job.text) : null;
                        phonenumber.text.isNotEmpty
                            ? _user.setPhoneNumber(phonenumber.text)
                            : null;
                        setState(() {
                          edit = false;
                        });
                      }
                    : () async {
                        try {
                          await auth.signOut();
                          onSignOut();
                        } catch (e) {
                          print(e);
                        }
                      },
              ),
            ),
          )
        ],
      ),
    );
  }
}
