import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightDateTile extends StatelessWidget {
  final double weight;
  final DateTime date;

  const WeightDateTile({
    @required this.weight,
    @required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          '${weight.toStringAsFixed(1)}kg',
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
