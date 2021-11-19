import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/screens/invitations.dart';
import 'package:synthiapp/Widgets/build_avatar.dart';

class InvitationTile extends StatefulWidget {
  final InvitationController controller;

  const InvitationTile({
    required this.controller,
  }) : super();

  @override
  _InvitationTileState createState() => _InvitationTileState();
}

class _InvitationTileState extends State<InvitationTile> {
  late InvitationController controller;

  _InvitationTileState();

  @override
  void initState() {
    super.initState();

    controller = widget.controller;
    controller.initInvitationTile();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Suppression'),
                content: const Text(
                    'Vous êtes sur le point de supprimer une invitation. La supression est définitive'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Continuer')),
                ],
              );
            },
          );
        }
        return true;
      },
      onDismissed: (direction) {
        final DocumentSnapshot<Object?>? invitation =
            controller.model.invitationSelected;

        if (invitation == null) return;
        if (direction == DismissDirection.startToEnd) {
          controller.acceptInvitation(invitation);
        } else {
          controller.dismissInvitation(invitation);
        }

        controller.model.removeCurrentInvitation();
        if ((controller.model.invitations?.length ?? 0) <= 0) {
          Navigator.pop(context);
        }
      },
      key: ValueKey(controller.model.invitationSelected?.id ?? ''),
      background: _slideLeft(),
      secondaryBackground: _slideRight(),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: SizedBox(
          height: 50,
          width: 50,
          child: BuildAvatar(
              isRounded: true, path: controller.model.masterPhotoUrl),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                controller.model.meetingTitle,
                style: const TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Text(controller.model.invitationDate,
                  style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text.rich(TextSpan(children: [
            TextSpan(
              text: controller.model.masterFullname,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
            const TextSpan(
              text: ' vous à invité à une réunion. Elle aura lieu le ',
            ),
            TextSpan(
              text: controller.model.meetingDate,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
          ])),
        ),
      ),
    );
  }

  Container _slideRight() {
    return Container(
        padding: const EdgeInsets.only(right: 15),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.red),
        alignment: Alignment.centerRight,
        child: const Text("Supprimer l'invitation",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white)));
  }

  Container _slideLeft() {
    return Container(
        padding: const EdgeInsets.only(left: 15),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.green),
        alignment: Alignment.centerLeft,
        child: const Text("Accepter l'invitation",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white)));
  }
}
