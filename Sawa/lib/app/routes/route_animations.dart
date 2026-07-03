import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScaleFadeTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutBack,
    );

    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.92, end: 1).animate(curvedAnimation),
        child: child,
      ),
    );
  }
}
