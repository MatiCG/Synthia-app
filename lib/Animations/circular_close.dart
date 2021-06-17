import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';

/// This is a animation for two widget.
/// It close the CLOSEWIDGET and land in the LANDINGWIDGET
///
/// ```dart
/// AnimatedSwitcher(
///   child: selectedWidget,
///   duration: Duration.zero,
///   reverseDuration: Duration(milliseconds: 600),
///   transitionBuilder: (child, animation) {
///     return FadeTransition(
///       opacity: Tween(begin: 1.0, end: 1.0).animate(animation),
///       child: child,
///     );
///   },
///   layoutBuilder: (currentChild, previousChildren) {
///     if (currentChild != null && previousChildren.length > 0) {
///       return CircularCloseAnimation(
///         duration: Duration(milliseconds: 600),
///         landingWidget: currentChild,
///        closeWidget: previousChildren[0],
///       );
///    }
///     return currentChild!;
///   },
/// )
/// ```
class CircularCloseAnimation extends StatefulWidget {
  const CircularCloseAnimation({
    required this.closeWidget,
    required this.landingWidget,
    this.duration = const Duration(seconds: 1),
  }) : super();

  /// Widget that close
  final Widget closeWidget;

  /// Widget where user is landing
  final Widget landingWidget;

  /// Duration of the animation
  final Duration duration;

  @override
  _CircularCloseAnimationState createState() => _CircularCloseAnimationState();
}

class _CircularCloseAnimationState extends State<CircularCloseAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void dispose() {
    if (animationController != null) animationController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration.zero,
      reverseDuration: widget.duration,
    );

    startAnimation();
  }

  Future startAnimation() async {
    if (animationController == null) return;

    await animationController!.forward();
    await animationController!.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double x = screenWidth / 2;
    final double y = screenHeight * 0.9;

    return AnimatedBuilder(
      animation: animationController!,
      builder: (context, child) {
        return Stack(
          children: [
            widget.landingWidget,
            CircularRevealAnimation(
              animation: CurvedAnimation(
                parent: animationController!,
                curve: Curves.easeInSine,
              ),
              minRadius: 5,
              maxRadius: screenHeight,
              centerOffset: Offset(x, y),
              child: widget.closeWidget,
            ),
          ],
        );
      },
    );
  }
}
