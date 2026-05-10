import 'package:flutter/material.dart';

class AuthModeTransition extends StatelessWidget {
  const AuthModeTransition({
    super.key,
    required this.isLogin,
    required this.signIn,
    required this.signUp,
    required this.duration,
  });

  final bool isLogin;
  final Widget signIn;
  final Widget signUp;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: duration,
      curve: Curves.ease,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: duration,
        switchInCurve: Curves.easeInSine,
        switchOutCurve: Curves.easeOutSine,
        transitionBuilder: (Widget child, Animation<double> animation) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInBack,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(curved),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.98, end: 1).animate(curved),
                child: child,
              ),
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<bool>(isLogin),
          child: isLogin ? signIn : signUp,
        ),
      ),
    );
  }
}
