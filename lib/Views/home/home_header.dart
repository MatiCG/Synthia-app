import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Controllers/screens/home.dart';
import 'package:synthiapp/Widgets/button.dart';
import 'package:synthiapp/Widgets/header_section.dart';
import 'package:synthiapp/Widgets/textfield.dart';
import 'package:synthiapp/config/config.dart';

/// HomeHeader is the first section on the HomePage.
/// Used to display the user's name and his profile picture.
/// Also use to show the today's day
class HomeHeader extends StatelessWidget {
  final HomeController controller;

  const HomeHeader({
    required this.controller,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final DateTime date = DateTime.now();
    final DateFormat formatter = DateFormat('d MMMM y');

    return HeaderSection(
      title: 'Bonjour ${controller.getUserFirstname()}',
      subtitle: formatter.format(date),
      trailing: SizedBox(
        height: 75,
        width: 75,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(24.0),
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
                              onPressed: () async {
                                await showDialog(
                                  useRootNavigator: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    final userEmail = user.data?.email;
                                    final textFieldItem =
                                        SynthiaTextFieldItem(
                                      title: 'Mot de passe',
                                      type: types.password,
                                    );
                                    if (userEmail == null) {
                                      Navigator.pop(context, false);
                                    }
                                    return Center(
                                      child: AlertDialog(
                                        title: const Text('Confirmer'),
                                        content: Column(
                                          children: [
                                            const Text(
                                                'Veuillez entrer votre mot de passe pour confirmer cette action'),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 32.0),
                                              child: SynthiaTextField(
                                                field: textFieldItem,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text('Annuler'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              user.signIn(
                                                email: userEmail!,
                                                password: textFieldItem
                                                    .controller.text,
                                              );
                                              await controller.deleteAccount();
                                              Navigator.of(context).pop(false);
                                            },
                                            child: const Text('Confirmer'),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                Navigator.pop(context);
                              }),
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
