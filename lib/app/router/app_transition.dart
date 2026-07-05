import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppTransition {
  const AppTransition._();

  static CustomTransitionPage<void> fade({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
