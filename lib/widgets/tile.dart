import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final Widget child;
  final double height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final bool hasBackground;

  Tile({
    @required this.child,
    this.height,
    this.margin,
    this.padding,
    this.hasBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0,
          ),
      margin: margin ?? null,
      height: height ?? null,
      width: double.infinity,
      decoration: BoxDecoration(
        color: hasBackground
            ? Theme.of(context).primaryColorLight
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: child,
    );
  }
}
