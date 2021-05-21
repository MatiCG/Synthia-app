import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Widgets/build_avatar.dart';
import 'package:synthiapp/Widgets/textfield.dart';

class HandleMembers extends StatefulWidget {
  final List<DocumentReference> members;

  HandleMembers(this.members) : super();

  @override
  _HandleMembersState createState() => _HandleMembersState();
}

class _HandleMembersState extends State<HandleMembers> {
  List<Map<String, dynamic>?> userData = [];
  SynthiaTextFieldItem newMember = SynthiaTextFieldItem(
    title: 'Nom du membre',
    type: types.EMAIL,
    hint: 'email@example.com',
  );

  Future getEmails() async {
    List<String> emails = [];

    await Future.wait(
      widget.members.map((e) async {
        Map<String, dynamic>? data = (await FirebaseFirestore.instance
                .collection('users')
                .doc(e.id)
                .get())
            .data();
        if (data != null) {
          emails.add(data['email']);
        }
      }),
    );

    return emails;
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      newMember.setTrailing = IconButton(
        icon: Icon(
          Icons.add,
          color: Colors.red,
        ),
        onPressed: () async {
          if (newMember.controller.text.isNotEmpty) {
            var value = await FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: newMember.controller.text)
                .get();

            if (value.docs.isNotEmpty) {
              var id = value.docs.first.id;
              var ref = FirebaseFirestore.instance.collection('users').doc(id);

              if (widget.members
                      .where((element) => element.id == ref.id)
                      .toList()
                      .length <=
                  0) {
                setState(() {
                  widget.members.add(ref);
                });
              } else {
                print('User already added');
              }
              newMember.controller.clear();
            }
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  left: 8,
                  right: 8,
                  child: Column(
                    children: [
                      Text('Ajouter des members',
                      style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      )),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('Une fois la réunion créer, chacun des membres que vous avez ajouter recevra une invitation à rejoindre la réunion. Ils seront libre de l\'accepter ou non.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        )),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.15,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SynthiaTextField(
                      field: newMember,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.members.length,
              itemBuilder: (context, index) {
                if (index >= this.userData.length) {
                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.members[index].id)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic>? data = (snapshot.data!
                                as DocumentSnapshot<Map<String, dynamic>>)
                            .data();
                        userData.add(data);
                        if (data == null) return Text('data is null');
                        return ListTile(
                          leading: SizedBox(
                              width: 50,
                              height: 50,
                              child: BuildAvatar(
                                path: data['photoUrl'],
                                isRounded: true,
                              )),
                          title: Text(data['email']),
                        );
                      }
                      return Text('none');
                    },
                  );
                } else {
                  if (userData[index] == null) return Text('none');
                  return ListTile(
                    leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: BuildAvatar(
                          path: userData[index]!['photoUrl'],
                          isRounded: true,
                        )),
                    title: Text(userData[index]!['email']),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
