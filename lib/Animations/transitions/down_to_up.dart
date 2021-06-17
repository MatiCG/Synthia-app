import 'package:flutter/material.dart';

class UpToDown {
  final Widget screen;

  UpToDown({
    required this.screen,
  });

  PageRouteBuilder get transition {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1);
        final end = Offset.zero;
        final curve = Curves.decelerate;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
