import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Widgets/build_avatar.dart';
import 'package:synthiapp/Widgets/list.dart';

class ListMembers extends StatefulWidget {
  final List members;
  final bool editable;

  const ListMembers({required this.members, this.editable = true}) : super();

  @override
  _ListMembersState createState() => _ListMembersState();
}

class _ListMembersState extends State<ListMembers> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: SynthiaList(
        shrinkWrap: true,
        itemCount: widget.members.length,
        itemBuilder: (index) {
          final userRef = widget.members[index] as DocumentReference;

          return FutureBuilder(
            future: SynthiaFirebase().fetchUserRefData(userRef),
            builder: (context, snapshot) {
              final data = snapshot.data as Map?;
              if (snapshot.hasData && data != null) {
                return ListTile(
                  title: Text('${data['firstname']} ${data['lastname']}'),
                  subtitle: Text(data['email'] as String),
                  leading: BuildAvatar(
                    isRounded: true,
                    path: data['photoUrl'] as String,
                  ),
                  trailing: index == 0 || !widget.editable
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              widget.members.removeAt(index);
                            });
                          },
                        ),
                );
              }
              return Container();
            },
          );
        },
      ),
    );
  }
}
