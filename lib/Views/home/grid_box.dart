import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Controllers/screens/home.dart';
import 'package:synthiapp/Views/Screens/invitations.dart';
import 'package:synthiapp/Widgets/grid_box.dart';
import 'package:synthiapp/config/config.dart';

class HomeGridBox extends StatefulWidget {
  final HomeController controller;

  const HomeGridBox({
    required this.controller,
  }) : super();

  @override
  _HomeGridBoxState createState() => _HomeGridBoxState();
}

class _HomeGridBoxState extends State<HomeGridBox> {
  int invitationLenght = 0;

  @override
  void initState() {
    super.initState();

    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SynthiaFirebase().fetchStreamInvitations().listen((event) {
          widget.controller
              .getInvitationsFromSnapshot(event.docs)
              .then((value) {
            if (mounted) {
              setState(() {
                invitationLenght = value;
              });
            }
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SynthiaGridBox(
      leftBox: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.controller.getMeetingsOfTheDay().toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 60,
            ),
          ),
          const Text(
            "réunions\naujourd'hui",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
      topRightBox: _buildTopRightBox(context),
      bottomRightBox: _buildBottomRightBox(),
    );
  }

  Padding _buildBottomRightBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Statistiques',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder(
            future: widget.controller.getAllMeetings(),
            builder: (context, snapshot) {
              String text = "Vous n'avez pas participé à des réunions";

              if (snapshot.hasData) {
                text =
                    'Vous avez participer à ${snapshot.data} réunions';
              }

              return Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Padding _buildTopRightBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
        onTap: () async {
          if (invitationLenght > 0) {
            final result =
                await utils.futurePushScreen(context, const InvitationsPage());

            if (result != null) {
              setState(() {
                invitationLenght = result.lenght as int;
              });
            }
          }
        },
        child: Hero(
          tag: 'invitations',
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Invitations',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              if (invitationLenght <= 0)
                const Text(
                  "Vous n'avez pas d'invitation",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              if (invitationLenght > 0)
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Vous avez '),
                      TextSpan(
                          text: invitationLenght.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              ' invitation${invitationLenght > 1 ? 's' : ''}'),
                    ],
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
