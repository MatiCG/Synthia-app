import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Models/screens/home.dart';
import 'package:synthiapp/Widgets/textfield.dart';

class HandleMembers extends StatefulWidget {
  final Meeting? meeting;
  final List? members;

  const HandleMembers({this.meeting, this.members}) : super();

  @override
  _HandleMembersState createState() => _HandleMembersState();
}

class _HandleMembersState extends State<HandleMembers> {
  String displayMessage = '';
  SynthiaTextFieldItem newMember = SynthiaTextFieldItem(
    title: 'Nom du membre',
    type: types.email,
    hint: 'email@example.com',
  );

  @override
  void initState() {
    super.initState();

    setState(() {
      newMember.setTrailing = IconButton(
          icon: const Icon(
            Icons.add,
            color: Colors.red,
          ),
          onPressed: () async {
            int invitations = 0;
            final userRef = await SynthiaFirebase()
                .fetchUserReferenceByEmail(newMember.controller.text);
            if (userRef != null) {
              if (widget.meeting != null) {
                invitations = await SynthiaFirebase()
                    .fetchUserInvitations(userRef, widget.meeting!.document!);
              }
              final myMembers = widget.meeting?.members ?? widget.members!;

              final users = myMembers
                  .where((element) =>
                      (element as DocumentReference).id == userRef.id)
                  .toList();
              print('ok');
              if (users.isEmpty && invitations == 0) {
                if (widget.meeting != null && invitations <= 0) {
                  await SynthiaFirebase().sendInvitation(
                    targetRef: userRef,
                    masterRef: widget.meeting!.members![0] as DocumentReference,
                    meetingRef: widget.meeting!.document!,
                  );
                }
                setState(() {
                  if (widget.meeting == null) {
                    widget.members!.add(userRef);
                  }
                  displayMessage =
                      '${newMember.controller.text} va recevoir une invitation pour rejoindre la réunion';
                });
              } else {
                setState(() {
                  displayMessage =
                      '${newMember.controller.text} est déjà présent ou a déjà reçu une invitation !';
                });
              }
            } else {
              setState(() {
                displayMessage = "${newMember.controller.text} n'existe pas";
              });
            }
            newMember.controller.clear();
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              children: const [
                Text('Ajouter des membres',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                      "Une fois la réunion créée, chacun des membres que vous avez ajouté recevra une invitation à rejoindre la réunion. Ils seront libre de l'accepter ou non.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      )),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 8.0),
              child: SynthiaTextField(
                field: newMember,
              ),
            ),
            if (displayMessage.isNotEmpty)
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                        text: '${displayMessage.split(' ')[0].trim()} ',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        )),
                    TextSpan(
                      text:
                          displayMessage.split(' ').sublist(1).join(' ').trim(),
                    ),
                  ])),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
/*
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Widgets/build_avatar.dart';
import 'package:synthiapp/Widgets/textfield.dart';

class HandleMembers extends StatefulWidget {
  final List members;

  const HandleMembers(this.members) : super();

  @override
  _HandleMembersState createState() => _HandleMembersState();
}

class _HandleMembersState extends State<HandleMembers> {
  List<Map<String, dynamic>?> userData = [];
  SynthiaTextFieldItem newMember = SynthiaTextFieldItem(
    title: 'Nom du membre',
    type: types.email,
    hint: 'email@example.com',
  );

  Future getEmails() async {
    final List<String> emails = [];

    await Future.wait(
      widget.members.map((e) async {
        final Map<String, dynamic>? data = (await FirebaseFirestore.instance
                .collection('users')
                .doc((e as DocumentReference).id)
                .get())
            .data();
        if (data != null) {
          emails.add(data['email'] as String);
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
        icon: const Icon(
          Icons.add,
          color: Colors.red,
        ),
        onPressed: () async {
          if (newMember.controller.text.isNotEmpty) {
            final value = await FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: newMember.controller.text)
                .get();

            if (value.docs.isNotEmpty) {
              final id = value.docs.first.id;
              final ref = FirebaseFirestore.instance.collection('users').doc(id);

              if (widget.members
                  .where((element) => element.id == ref.id)
                  .toList().isEmpty) {
                setState(() {
                  widget.members.add(ref);
                });
              } else {
                log('User already added');
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
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
                    children: const [
                      Text('Ajouter des members',
                      style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      )),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text("Une fois la réunion créer, chacun des membres que vous avez ajouter recevra une invitation à rejoindre la réunion. Ils seront libre de l'accepter ou non.",
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
                if (index >= userData.length) {
                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc((widget.members[index] as DocumentReference).id)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        final Map<String, dynamic>? data = (snapshot.data!
                                as DocumentSnapshot<Map<String, dynamic>>)
                            .data();
                        userData.add(data);
                        if (data == null) return const Text('data is null');
                        return ListTile(
                          leading: SizedBox(
                              width: 50,
                              height: 50,
                              child: BuildAvatar(
                                path: data['photoUrl'] as String?,
                                isRounded: true,
                              )),
                          title: Text(data['email'] as String),
                        );
                      }
                      return const Text('none');
                    },
                  );
                } else {
                  if (userData[index] == null) return const Text('none');
                  return ListTile(
                    leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: BuildAvatar(
                          path: userData[index]!['photoUrl'] as String?,
                          isRounded: true,
                        )),
                    title: Text(userData[index]!['email'] as String),
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
*/