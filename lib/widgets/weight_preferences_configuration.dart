import 'package:flutter/material.dart';

import '../data/models/add_weight_helper.dart';
import '../data/models/weight.dart';
import '../screens/add_weight_screen.dart';
import '../util/pair.dart';
import '../util/util.dart';

import 'configuration_tile.dart';
import 'weight_date_tile.dart';

class WeightPreferencesConfiguration extends StatelessWidget {
  final Pair<double, DateTime> prefs;
  final String text;
  final AddWeightType addType;
  final Unit units;

  const WeightPreferencesConfiguration({
    @required this.prefs,
    @required this.text,
    @required this.addType,
    @required this.units,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Create a dummy weight data value
        WeightData temp = WeightData(
          null,
          weight: units == Unit.Metric
              ? prefs.first
              : UnitConverter.lbsToKg(prefs.first),
          date: prefs.second,
        );

        Navigator.pushNamed(
          context,
          AddWeightScreen.routeName,
          arguments: AddWeightHelper(
            weightData: temp,
            addType: addType,
            units: units,
          ),
        );
      },
      child: ConfigurationTile(
        title: text,
        subtitle: 'Click to change it',
        trailing: WeightDateTile(
          weight: prefs.first,
          date: prefs.second,
          unit: units,
        ),
      ),
    );
  }
}
