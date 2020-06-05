import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/util/pair.dart';
import 'package:weight_tracker/util/util.dart';
import 'package:weight_tracker/widgets/weight_preferences_configuration.dart';

import '../data/blocs/slider_bloc/slider_bloc.dart';
import '../data/blocs/user_preferences_bloc/user_preferences_bloc.dart';
import '../data/models/user_data.dart';
import '../data/models/add_weight_helper.dart';
import '../widgets/default_page_layout.dart';
import '../widgets/height_slider.dart';
import '../widgets/screen_header.dart';
import '../widgets/configuration_tile.dart';
import '../widgets/tile.dart';

class ConfigurationScreen extends StatefulWidget {
  static const String routeName = '/configuration_screen';

  final UserData lastConfiguration;

  ConfigurationScreen({this.lastConfiguration});

  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  /// Switch values
  bool _metricUnits = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPreferencesBloc, UserData>(
      builder: (context, UserData prefs) {
        if (prefs.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          _metricUnits = prefs.areMetric;
          return Builder(
            builder: (ctx) => BlocProvider<SliderBloc>(
              create: (_) => SliderBloc(prefs.rawHeight),
              child: Scaffold(
                body: DefaultPageLayout(
                  child: Column(
                    children: <Widget>[
                      ScreenHeader(
                        text: 'Settings',
                        onTap: () {
                          // If user does not save, we must revet changes
                          // Inital data should be reseted
                          BlocProvider.of<UserPreferencesBloc>(ctx).add(
                            UserPreferencesAddPreferences(
                                widget.lastConfiguration),
                          );
                          Navigator.of(ctx).pop();
                        },
                      ),
                      Tile(
                        margin: const EdgeInsets.only(
                          bottom: 6.0,
                          top: 16.0,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: HeightSlider(
                          min: 50,
                          max: 225,
                          withText: true,
                          middleText: false,
                          units: prefs.dataUnits,
                        ),
                      ),
                      WeightPreferencesConfiguration(
                        prefs: Pair<double, DateTime>(
                          first: prefs.initialWeight,
                          second: prefs.initialDate,
                        ),
                        units: prefs.dataUnits,
                        addType: AddWeightType.Initial,
                        text: 'Initial Weight',
                      ),
                      WeightPreferencesConfiguration(
                        prefs: Pair<double, DateTime>(
                          first: prefs.goalWeight,
                          second: prefs.goalDate,
                        ),
                        units: prefs.dataUnits,
                        addType: AddWeightType.Goal,
                        text: 'Goal Weight',
                      ),
                      ConfigurationTile(
                        title: 'Unit System',
                        subtitle: _metricUnits ? 'Metric' : 'Imperial',
                        trailing: Switch(
                          value: _metricUnits,
                          activeColor: Theme.of(context).accentColor,
                          onChanged: (newValue) {
                            BlocProvider.of<UserPreferencesBloc>(ctx).add(
                              UserPreferencesAddUnit(
                                _metricUnits ? Unit.Imperial : Unit.Metric,
                              ),
                            );
                            setState(() => _metricUnits = newValue);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: Builder(
                  builder: (ctx) => FloatingActionButton.extended(
                    onPressed: () {
                      BlocProvider.of<UserPreferencesBloc>(context).add(
                        UserPreferencesAddPreferences(
                          prefs.copyWith(
                            height: BlocProvider.of<SliderBloc>(ctx).state,
                            initialWeight: prefs.rawInitialWeight,
                            initialDate: prefs.initialDate,
                            weightGoal: prefs.rawGoalWeight,
                            goalDate: prefs.goalDate,
                          ),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    backgroundColor: Theme.of(context).accentColor,
                    label: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        'SAVE CONFIGURATION',
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              ),
            ),
          );
        }
      },
    );
  }
}
