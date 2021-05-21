import 'package:flutter/material.dart';

class UpToDown {
  final Widget screen;

  UpToDown({
    required this.screen,
  });

  PageRouteBuilder get transition {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => this.screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1);
        var end = Offset.zero;
        var curve = Curves.decelerate;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
