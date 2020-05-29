import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final Widget child;
  final double height;
  final EdgeInsets margin;
  final EdgeInsets padding;

  Tile({
    @required this.child,
    this.height,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      margin: margin ?? null,
      height: height ?? null,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: child,
    );
  }
}
