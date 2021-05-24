import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/screens/invitations.dart';
import 'package:synthiapp/Widgets/build_avatar.dart';

class InvitationTile extends StatefulWidget {
  final InvitationController controller;

  InvitationTile({
    required this.controller,
  }) : super();

  @override
  _InvitationTileState createState() => _InvitationTileState(controller);
}

class _InvitationTileState extends State<InvitationTile> {
  final InvitationController controller;

  _InvitationTileState(this.controller);

  @override
  void initState() {
    super.initState();

    controller.initInvitationTile();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
          // TODO: Modify this dialog
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm"),
                content: const Text("DELETE THIS INVITATION ?"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("DELETE")),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("CANCEL"),
                  ),
                ],
              );
            },
          );
        }
        return true;
      },
      onDismissed: (direction) {
        DocumentSnapshot<Object?>? invitation =
            controller.model.invitationSelected;

        if (invitation == null) return;
        if (direction == DismissDirection.startToEnd) {
          controller.acceptInvitation(invitation);
        } else {
          controller.dismissInvitation(invitation);
        }

        controller.model.removeCurrentInvitation();
        if ((controller.model.invitations?.length ?? 0) <= 0) Navigator.pop(context);
      },
      key: ValueKey(controller.model.invitationSelected?.id ?? ''),
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          child: BuildAvatar(
              isRounded: true, path: controller.model.masterPhotoUrl),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(controller.model.meetingTitle, style: TextStyle(fontSize: 18)),
            Text(controller.model.invitationDate,
                style: TextStyle(fontSize: 12)),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text.rich(TextSpan(children: [
            TextSpan(
                text: controller.model.masterFullname,
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' vous à invité à une réunion. Elle aura lieu le '),
            TextSpan(
                text: controller.model.meetingDate,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ])),
        ),
      ),
      background: Container(
        alignment: Alignment.centerLeft,
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.check, color: Colors.white),
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.delete_forever,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
