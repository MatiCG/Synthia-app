import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/screens/home.dart';
import 'package:synthiapp/Views/Screens/invitations.dart';
import 'package:synthiapp/Widgets/grid_box.dart';
import 'package:synthiapp/config/config.dart';

class HomeGridBox extends StatefulWidget {
  final HomeController controller;

  HomeGridBox({
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
        widget.controller.getInvitations().then((value) {
          if (this.mounted) {
            setState(() {
              invitationLenght = value;
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SynthiaGridBox(
      leftBox: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.controller.getMeetingsOfTheDay().toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 60,
            ),
          ),
          Text(
            'réunions\naujourd\'hui',
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
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Statistiques',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            'Vous avez participer à ${widget.controller.getAllMeetings()} réunions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
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
            var result =
                await utils.futurePushScreen(context, InvitationsPage());

            if (result != null) {
              setState(() {
                invitationLenght = result.lenght;
              });
            }
          }
        },
        child: Hero(
          tag: 'invitations',
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Align(
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
                Text(
                  'Vous n\'avez pas d\'invitation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              if (invitationLenght > 0)
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Vous avez '),
                      TextSpan(text: invitationLenght.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      TextSpan(text: ' invitation${invitationLenght > 1 ? 's' : ''}'),
                    ],
                  ),
                  style: TextStyle(
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
