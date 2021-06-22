import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/screens/invitations.dart';
import 'package:synthiapp/Views/invitations/invitation_tile.dart';
import 'package:synthiapp/Widgets/app_bar.dart';
import 'package:synthiapp/Widgets/list.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage() : super();

  @override
  _InvitationsPageState createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  InvitationController? controller;

  @override
  void initState() {
    super.initState();

    setState(() {
      controller = InvitationController(this);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) return const Scaffold();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: SynthiaAppBar(
        title: 'Réunions invitation',
        closeIcon: Icons.close,
        returnValue: controller!.model.invitations ?? [],
      ),
      body: SynthiaList(
        itemCount: controller!.model.invitations?.length ?? 0,
        itemBuilder: (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: InvitationTile(
                controller: controller!,
              ),
            ),
          );
        },
      ),
    );
  }
}
