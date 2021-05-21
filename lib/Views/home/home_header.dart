import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Controllers/screens/home.dart';
import 'package:synthiapp/Widgets/button.dart';
import 'package:synthiapp/Widgets/header_section.dart';
import 'package:synthiapp/config/config.dart';

/// HomeHeader is the first section on the HomePage.
/// Used to display the user's name and his profile picture.
/// Also use to show the today's day
class HomeHeader extends StatelessWidget {
  final HomeController controller;

  HomeHeader({
    required this.controller,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final DateTime date = DateTime.now();
    final DateFormat formatter = DateFormat('d MMMM y');

    return HeaderSection(
      title: 'Bonjour ${controller.getUserFirstname()}',
      subtitle: '${formatter.format(date)}',
      trailing: Container(
        height: 75,
        width: 75,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            'Compte',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                        SynthiaButton(
                          text: 'Se déconnecter',
                          onPressed: () {
                            user.signOut();
                            Navigator.pop(context);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: SynthiaButton(
                            text: 'Supprimer votre compte',
                            textColor: Colors.red[900],
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(controller.getUserPhotoPath()),
          ),
        ),
      ),
    );
  }
}
