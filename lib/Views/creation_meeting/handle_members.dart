import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:synthiapp/Widgets/textfield.dart';
import 'package:synthiapp/config/config.dart';

class HandleMembers extends StatefulWidget {
  final Meeting? meeting;
  final List members;

  const HandleMembers({this.meeting, this.members = const []}) : super();

  @override
  _HandleMembersState createState() => _HandleMembersState();
}

class _HandleMembersState extends State<HandleMembers> {
  String displayedMsg = '';
  late SynthiaTextFieldItem field = SynthiaTextFieldItem(
    title: 'Email du membre',
    type: types.email,
    hint: 'email@example.com',
  );

  Future sendEmailTo(String email) async {
    const String username = 'synthia.assistant@gmail.com';
    const String password = 'epitecheipsynthia';

    log(widget.meeting.toString());
    // ignore: deprecated_member_use
    final smtpServer = gmail(username, password);
    final equivalentMessage = Message()
      ..from = const Address(username, 'Synthia')
      ..recipients.add(Address(email))
      ..subject = 'Invitation : Rejoingnez la réunin ${widget.meeting?.title}'
      ..text = '''
${widget.meeting?.master} vous a invité à rejoindre une réunion sur l'application synthIA. Vous pouvez la télécharger via ce lien: https://play.google.com/store/apps/details?id=com.synthia.synthiaapp&gl=FR'''
      ..html =
          "<p>${widget.meeting?.master} vous a invité à rejoindre une réunion sur l'application synthIA. Vous pouvez la télécharger via ce lien: https://play.google.com/store/apps/details?id=com.synthia.synthiaapp&gl=FR</p>";

    await send(equivalentMessage, smtpServer);
  }

  Future _handleBtnPressed() async {
    final String email = field.controller.text;
    final SynthiaFirebase firebase = SynthiaFirebase();
    final reference = await firebase.fetchUserReferenceByEmail(email);
    List members = widget.meeting?.members ?? widget.members;
    int invitations = 0;

    if (reference == null) {
      return utils.updateView(this, update: () {
        displayedMsg =
            "$email n'existe pas. Nous lui envoyons un email pour télécharger l'application";
        sendEmailTo(email);
      });
    }

    if (widget.meeting != null) {
      invitations = await firebase.fetchUserInvitations(
          reference, widget.meeting!.document!);
    }
    members = members
        .where((element) => (element as DocumentReference).id == reference.id)
        .toList();
    if (members.isEmpty && invitations == 0) {
      if (widget.meeting != null) {
        await firebase.sendInvitation(
          targetRef: reference,
          masterRef: widget.meeting!.members[0] as DocumentReference,
          meetingRef: widget.meeting!.document!,
        );
      }
      utils.updateView(
        this,
        update: () {
          displayedMsg =
              '$email va recevoir une invitation à rejoindre la réunion !';
          if (widget.meeting == null) {
            widget.members.add(reference);
          }
        },
      );
    } else {
      utils.updateView(this,
          update: () => displayedMsg =
              '$email est déja présent ou a déjà reçu une invitation');
    }
    field.controller.clear();
  }

  Widget _buildTrailingBtn() {
    return IconButton(
      icon: Icon(
        Icons.add,
        color: Theme.of(context).accentColor,
      ),
      onPressed: _handleBtnPressed,
    );
  }

  @override
  void initState() {
    super.initState();

    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {
          field.setTrailing = _buildTrailingBtn();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildTitle(),
          _buildContent(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 8.0),
            child: SynthiaTextField(
              field: field,
            ),
          ),
          if (displayedMsg.isNotEmpty) ...[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${displayedMsg.split(' ')[0].trim()} ',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            displayedMsg.split(' ').sublist(1).join(' ').trim(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildContent() {
    return const Padding(
      padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: Text(
        "Une fois la réunion créée, chacun des membres que vous avez ajouté recevra une invitation à rejoindre la réunion. Ils seront libres de l'accepter ou non.",
        textAlign: TextAlign.justify,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Ajouter des membres',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
    );
  }
}