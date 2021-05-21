import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Widgets/app_bar.dart';
import 'package:synthiapp/Widgets/build_avatar.dart';
import 'package:synthiapp/Widgets/list.dart';

class InvitationsPage extends StatefulWidget {
  InvitationsPage() : super();

  @override
  _InvitationsPageState createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  List<DocumentSnapshot<Object?>>? data = [];

  @override
  void initState() {
    super.initState();

    SynthiaFirebase().fetchInvitations().then((value) {
      setState(() {
        data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: SynthiaAppBar(
        title: 'Réunions invitation',
        closeIcon: Icons.close,
        returnValue: data,
      ),
      body: SynthiaList(
        itemCount: data?.length ?? 0,
        itemBuilder: (index) {
          return InvitationTile(
            data: data!,
            index: index,
          );
        },
      ),
    );
  }
}

class InvitationTile extends StatefulWidget {
  final List<DocumentSnapshot> data;
  final int index;

  InvitationTile({
    required this.data,
    required this.index,
  }) : super();

  @override
  _InvitationTileState createState() => _InvitationTileState();
}

class _InvitationTileState extends State<InvitationTile> {
  String masterEmail = '';
  String masterPhotoUrl = 'assets/avatars/blank.png';
  String meetingTitle = '';
  String meetingFullDate = '';
  String invitationDate = '';

  // Use to remove the inviation
  dismissInvitation(DocumentSnapshot data) {
    FirebaseFirestore.instance
        .collection('invitations')
        .doc(data.id)
        .delete()
        .then((value) {
      print('Inviation deleted');
    }).onError((error, stackTrace) {
      print('An error occured when deleting the invitation');
    });
  }

  acceptInvitation(DocumentSnapshot data) {
    SynthiaFirebase myFunctions = SynthiaFirebase();
    bool check =
        myFunctions.checkSnapshotDocument(data, keys: ['meeting', 'user']);

    if (check) {
      DocumentReference meeting =
          (data.data()! as Map<String, dynamic>)['meeting'];
      DocumentReference user = (data.data()! as Map<String, dynamic>)['user'];

      FirebaseFirestore.instance.doc(meeting.path).update({
        'members': FieldValue.arrayUnion([user])
      }).then((value) {
        print('User accept invitation successfully');
        dismissInvitation(data);
      });
    } else {
      print('Error');
    }
  }

  @override
  void initState() {
    super.initState();

    var myFunctions = SynthiaFirebase();

    if (myFunctions
        .checkSnapshotDocument(widget.data[widget.index], keys: ['master'])) {
      var user =
          (widget.data[widget.index].data()! as Map<String, dynamic>)['master'];

      SynthiaFirebase().fetchUserRefFullName(user).then((value) {
        setState(() {
          masterEmail = value;
        });
      });
      SynthiaFirebase().fetchUserRefPhotoUrl(user).then((value) {
        setState(() {
          masterPhotoUrl = value;
        });
      });

      if (myFunctions.checkSnapshotDocument(widget.data[widget.index],
          keys: ['meeting'])) {
        DocumentReference meeting = (widget.data[widget.index].data()!
            as Map<String, dynamic>)['meeting'];

        meeting.get().then((value) {
          if (myFunctions
              .checkSnapshotDocument(value, keys: ['schedule', 'title'])) {
            Timestamp date =
                (value.data()! as Map<String, dynamic>)['schedule'];
            setState(() {
              meetingTitle = (value.data()! as Map<String, dynamic>)['title'];
              meetingFullDate = DateFormat('d MMMM y à').add_Hm().format(date.toDate());
            });
          }
        });
      }

      if (myFunctions.checkSnapshotDocument(widget.data[widget.index],
          keys: ['timestamp'])) {
        Timestamp time = (widget.data[widget.index].data()!
            as Map<String, dynamic>)['timestamp'];

        setState(() {
          invitationDate = DateFormat('d MMMM').format(time.toDate());
        });
      }
      /*
      if (checkSnapshotDocument(await ref.get(), keys: ['photoUrl'])) {
      return ((await ref.get()).data()! as Map<String, dynamic>)['photoUrl'];
    }
    return '';
      */
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm"),
                content:
                    const Text("Are you sure you wish to delete this item?"),
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
        if (direction == DismissDirection.startToEnd) {
          acceptInvitation(widget.data[widget.index]);
        } else {
          dismissInvitation(widget.data[widget.index]);
        }
        widget.data.removeAt(widget.index);

        if (widget.data.length <= 0) Navigator.pop(context);
      },
      key: ValueKey(widget.data[widget.index].id),
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          child: BuildAvatar(
            isRounded: true,
            path: masterPhotoUrl,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(meetingTitle),
            Text(invitationDate),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: masterEmail, style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' vous à invité à une réunion. Elle aura lieu le '),
                TextSpan(text: meetingFullDate, style: TextStyle(fontWeight: FontWeight.bold)),
              ]
            )
          ),
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
          child: Icon(Icons.delete_forever, color: Colors.white,),
        ),
      ),
    );
  }
}
