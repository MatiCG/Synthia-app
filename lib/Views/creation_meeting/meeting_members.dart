import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:synthiapp/Views/creation_meeting/handle_members.dart';
import 'package:synthiapp/Widgets/build_avatar.dart';
import 'package:synthiapp/Widgets/list_members.dart';

class MeetingMembers extends StatefulWidget {
  final Meeting edit;

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
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: HandleMembers(
                  members: widget.edit.members,
                  meeting: widget.edit.document != null ? widget.edit : null,
                ),
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
          future: _firebase.fetchUserReferencePhotoUrl(
              widget.edit.members[index] as DocumentReference),
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
