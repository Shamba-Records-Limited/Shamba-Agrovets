import 'package:flutter/material.dart';

class PageRouter extends PageRouteBuilder {
  final Widget page;
  final AxisDirection direction;

  PageRouter(this.page, {this.direction = AxisDirection.left})
    : super(
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeInOutCubic;

          final offsetTween = Tween<Offset>(
            begin: _getBeginOffset(direction),
            end: Offset.zero,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(offsetTween),
            child: FadeTransition(
              opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
              child: child,
            ),
          );
        },
      );

  static Offset _getBeginOffset(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.right:
        return const Offset(-1, 0);
      case AxisDirection.left:
      return const Offset(1, 0);
    }
  }
}
