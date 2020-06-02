import 'package:flutter/material.dart';

class ColoredProgressBar extends StatelessWidget {
  final double progress;

  const ColoredProgressBar(this.progress)
      : assert(progress <= 1 && progress >= 0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        LayoutBuilder(
          builder: (_, constraints) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3.0),
              ),
              width: constraints.maxWidth,
              height: 4.0,
            );
          },
        ),
        LayoutBuilder(
          builder: (_, constraints) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3.0),
              ),
              width: constraints.maxWidth,
              height: 4,
            );
          },
        ),
        LayoutBuilder(
          builder: (_, constraints) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(3.0),
              ),
              width: constraints.maxWidth * progress,
              height: 4,
            );
          },
        ),
      ],
    );
  }
}
