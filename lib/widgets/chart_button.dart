import 'package:flutter/material.dart';

class ChartButton extends StatefulWidget {
  final Color activeColor;
  final String text;
  final Function() onTap;

  ChartButton({
    @required this.text,
    @required this.activeColor,
    this.onTap,
  });

  @override
  _ChartButtonState createState() => _ChartButtonState();
}

class _ChartButtonState extends State<ChartButton> {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
       // widget.onTap();
        setState(() => _isActive = !_isActive);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        curve: Curves.slowMiddle,
        decoration: BoxDecoration(
          color: _isActive ? widget.activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(width: 1.0, color: widget.activeColor,),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 2.0,
          horizontal: 12.0,
        ),
        child: Text(
          widget.text,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
