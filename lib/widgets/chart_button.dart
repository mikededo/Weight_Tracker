import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/data/blocs/chart_display_bloc/chart_button_bloc.dart';

class ChartButton extends StatelessWidget {
  final int id;
  final Color activeColor;
  final String text;
  final Function() onTap;

  ChartButton({
    @required this.id,
    @required this.text,
    @required this.activeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: BlocBuilder<ChartButtonBloc, int>(
        builder: (_, selectedId) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 50),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(left: 12.0),
            decoration: BoxDecoration(
              color: selectedId == id ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
                width: 1.0,
                color: activeColor,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 2.0,
              horizontal: 12.0,
            ),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        },
      ),
    );
  }
}
