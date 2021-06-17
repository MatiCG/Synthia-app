import 'package:flutter/material.dart';

class RightToLeft {
  final Widget screen;

  RightToLeft({
    required this.screen,
  });

  PageRouteBuilder get transition {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0.0);
        final end = Offset.zero;
        final curve = Curves.decelerate;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
