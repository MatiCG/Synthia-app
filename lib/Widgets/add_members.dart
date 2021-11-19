import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Widgets/build_avatar.dart';

class AddMembers extends StatefulWidget {
  final List members;
  final Function()? onLeadingPress;
  final Function()? onTrailingPress;

  const AddMembers({
    required this.members,
    this.onLeadingPress,
    this.onTrailingPress,
  }) : super();

  @override
  _AddMembersState createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: -25.0,
      children: List.generate(
        widget.members.length >= 5 ? 6 + 1 : widget.members.length + 2,
        (index) {
          if (index == 0) {
            return _buildAddButton();
          } else if (index == 1) {
            return const SizedBox(width: 75);
          }
          return _buildIcons(index - 2);
        },
      ),
    );
  }

  Widget _buildIcons(int index) {
    if (index >= 4) return _buildCircularIndex();
    if (index <= 3 && index == widget.members.length - 1) {
      return InkWell(
        onTap: widget.onTrailingPress,
        child: _buildUserCircularIcon(index),
      );
    }
    return _buildUserCircularIcon(index);
  }

  Widget _buildCircularIndex() {
    return InkWell(
      onTap: widget.onTrailingPress,
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
            '+${widget.members.length - 4}',
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
              widget.members[index] as DocumentReference),
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

  Widget _buildAddButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(),
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.black),
        onPressed: widget.onLeadingPress,
      ),
    );
  }
}
