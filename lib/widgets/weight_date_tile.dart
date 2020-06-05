import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weight_tracker/util/util.dart';

class WeightDateTile extends StatelessWidget {
  final double weight;
  final DateTime date;
  final Unit unit;

  const WeightDateTile({
    @required this.weight,
    @required this.date,
    @required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          unit == Unit.Metric
              ? UnitConverter.kgToStringRich(weight)
              : UnitConverter.lbsToStringRich(weight),
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(height: 2.0),
        Text(
          DateFormat('d/M/yy').format(date),
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    );
  }
}
