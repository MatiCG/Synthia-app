import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Controllers/screens/detail_meeting.dart';
import 'package:synthiapp/Models/screens/home.dart';
import 'package:synthiapp/Views/Screens/creation_meeting.dart';
import 'package:synthiapp/Views/Screens/meeting_connexion.dart';
import 'package:synthiapp/Views/creation_meeting/handle_members.dart';
import 'package:synthiapp/Widgets/build_avatar.dart';
import 'package:synthiapp/Widgets/button.dart';
import 'package:synthiapp/Widgets/list_members.dart';
import 'package:synthiapp/config/config.dart';

class DetailMeetingProgress extends StatefulWidget {
  final DetailMeetingController controller;

  const DetailMeetingProgress({
    required this.controller,
  }) : super();

  @override
  _DetailMeetingProgressState createState() => _DetailMeetingProgressState();
}

class _DetailMeetingProgressState extends State<DetailMeetingProgress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: () async {
                final updatedMeeting = await utils.futurePushScreen(
                    context,
                    CreationMeetingPage(
                        edit: true, meeting: widget.controller.meeting));
                setState(() {
                  widget.controller.meeting = updatedMeeting as Meeting;
                });
              },
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          )),
      body: Column(
        children: [
          Wrap(
            children: [
              meetingText(widget.controller.meeting.title, 30, 20.0, 0.0,
                  bold: true),
              meetingDate(),
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.person_outline_outlined),
                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: ListMembers(
                            members: widget.controller.meeting.members!,
                          ),
                        );
                      },
                    );
                    setState(() {});
                  },
                ),
                trailing: const Icon(Icons.add),
                title: Wrap(
                  spacing: -25.0,
                  children: List.generate(
                    widget.controller.meeting.members!.length >= 5
                        ? 6
                        : widget.controller.meeting.members!.length,
                    (index) {
                      return _buildIcons(index);
                    },
                  ),
                ),
                onTap: () async {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: HandleMembers(
                          meeting: widget.controller.meeting,
                          members: widget.controller.meeting.members,
                        ),
                      );
                    },
                  );
                  setState(() {});
                },
              ),
            ],
          ),
          Expanded(child: Container()),
          Align(
            alignment: Alignment.bottomCenter,
            child: SynthiaButton(
              text: 'Commencer',
              enable: widget.controller.isTodaysDate(),
              color: Theme.of(context).accentColor,
              textColor: Theme.of(context).primaryColor,
              onPressed: () => utils.pushScreen(
                  context,
                  MeetingConnexion(
                    meeting: widget.controller.meeting,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcons(int index) {
    if (index >= 5) return _buildCircularIndex();
    if (index <= 4 && index == widget.controller.meeting.members!.length) {
      return InkWell(
        onTap: () {},
        child: _buildUserCircularIcon(index),
      );
    }
    return _buildUserCircularIcon(index);
  }

  Widget _buildCircularIndex() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 50,
        width: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Center(
          child: Text(
            '+${widget.controller.meeting.members!.length - 4}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCircularIcon(int index) {
    final SynthiaFirebase _firebase = SynthiaFirebase();

    return Container(
      height: 50,
      width: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Center(
        child: FutureBuilder(
          future: _firebase.fetchUserReferencePhotoUrl(
              widget.controller.meeting.members![index] as DocumentReference),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BuildAvatar(
                isRounded: true,
                path: snapshot.data as String? ?? 'assets/avatars/blank.png',
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  void _update() {
    setState(() {});
    FirebaseFirestore.instance
        .doc(widget.controller.meeting.document!.path)
        .update({
      'members': widget.controller.meeting.members,
    });
  }

  Widget meetingDate() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 15.0),
        child: Row(children: [
          const Icon(Icons.access_time, color: Colors.black, size: 12.0),
          Text(
            DateFormat.yMMMd('en_US')
                .add_jm()
                .format(widget.controller.meeting.date!),
            style: _textStyle(12, false),
          ),
        ]));
  }

  Widget meetingText(String text, double size, double padH, double padV,
      {required bool bold}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
        child: Text(
          text,
          style: _textStyle(size, bold),
        ));
  }

  TextStyle _textStyle(double fontSize, bool bold) {
    return TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Models/screens/creation_meeting.dart';
import 'package:synthiapp/Views/creation_meeting/handle_members.dart';
import 'package:synthiapp/Widgets/build_avatar.dart';
import 'package:synthiapp/Widgets/list_members.dart';

class MeetingMembers extends StatefulWidget {
  final MeetingCreation edit;

  const MeetingMembers({required this.edit}) : super();

  @override
  _MeetingMembersState createState() => _MeetingMembersState();
}

class _MeetingMembersState extends State<MeetingMembers> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: const Icon(Icons.person_outline_outlined),
        onPressed: () async {
          await showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: ListMembers(
                  members: widget.edit.members,
                ),
              );
            },
          );
          setState(() {});
        },
      ),
      trailing: const Icon(Icons.add),
      title: Wrap(
        spacing: -25.0,
        children: List.generate(
          widget.edit.members.length >= 5 ? 6 : widget.edit.members.length,
          (index) {
            return _buildIcons(index);
          },
        ),
      ),
      onTap: () async {
        await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: HandleMembers(
                members: widget.edit.members,
              ),
            );
          },
        );
        setState(() {});
      },
    );
  }

  Widget _buildIcons(int index) {
    if (index >= 5) return _buildCircularIndex();
    if (index <= 4 && index == widget.edit.members.length) {
      return InkWell(
        onTap: () {},
        child: _buildUserCircularIcon(index),
      );
    }
    return _buildUserCircularIcon(index);
  }

   Widget _buildCircularIndex() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 50,
        width: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Center(
          child: Text(
            '+${widget.edit.members.length - 4}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCircularIcon(int index) {
    final SynthiaFirebase _firebase = SynthiaFirebase();

    return Container(
      height: 50,
      width: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Center(
        child: FutureBuilder(
          future: _firebase.fetchUserReferencePhotoUrl(widget.edit.members[index]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BuildAvatar(
                isRounded: true,
                path: snapshot.data as String? ?? 'assets/avatars/blank.png',
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

*/