import 'package:flutter/material.dart';

class DefaultPageLayout extends StatelessWidget {
  final Widget child;
  DefaultPageLayout({this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 20.0,
        ),
        child: child,
      ),
    );
  }
}
