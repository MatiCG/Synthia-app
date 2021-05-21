import 'package:flutter/material.dart';

class RightToLeft {
  final Widget screen;

  RightToLeft({
    required this.screen,
  });

  PageRouteBuilder get transition {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => this.screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1, 0.0);
        var end = Offset.zero;
        var curve = Curves.decelerate;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
