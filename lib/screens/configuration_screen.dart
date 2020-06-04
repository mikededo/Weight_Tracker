import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/util/pair.dart';
import 'package:weight_tracker/widgets/weight_preferences_configuration.dart';

import '../data/blocs/slider_bloc/slider_bloc.dart';
import '../data/blocs/user_preferences_bloc/user_preferences_bloc.dart';
import '../data/models/user_data.dart';
import '../data/models/add_weight_helper.dart';
import '../widgets/default_page_layout.dart';
import '../widgets/modified_slider.dart';
import '../widgets/screen_header.dart';
import '../widgets/tile.dart';

class ConfigurationScreen extends StatefulWidget {
  static const String routeName = '/configuration_screen';
  final UserData prefs;

  ConfigurationScreen({this.prefs});

  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  /// Switch values
  bool _switchOne = false;
  bool _switchTwo = false;
  bool _switchThree = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPreferencesBloc, UserData>(
      builder: (context, state) {
        if (state.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          print(state.goalDate);
          return BlocProvider<SliderBloc>(
            create: (_) => SliderBloc(state.height.toDouble()),
            child: Scaffold(
              body: DefaultPageLayout(
                child: Column(
                  children: <Widget>[
                    ScreenHeader(text: 'Settings'),
                    Tile(
                      margin: const EdgeInsets.only(
                        bottom: 6.0,
                        top: 16.0,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: ModifiedSlider(
                        min: 50,
                        max: 225,
                        withText: true,
                        middleText: false,
                      ),
                    ),
                    WeightPreferencesConfiguration(
                      prefs: Pair<double, DateTime>(
                        first: state.initialWeight,
                        second: state.initialDate,
                      ),
                      addType: AddWeightType.Initial,
                      text: 'Initial Weight',
                    ),
                    WeightPreferencesConfiguration(
                      prefs: Pair<double, DateTime>(
                        first: state.goalWeight,
                        second: state.goalDate,
                      ),
                      addType: AddWeightType.Goal,
                      text: 'Goal Weight',
                    ),
                    Tile(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListTile(
                        title: Text(
                          'Setting number 1',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        trailing: Switch(
                          value: _switchOne,
                          activeColor: Theme.of(context).accentColor,
                          onChanged: (newValue) =>
                              setState(() => _switchOne = newValue),
                        ),
                      ),
                    ),
                    Tile(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListTile(
                        title: Text(
                          'Setting number 2',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        trailing: Switch(
                          value: _switchTwo,
                          activeColor: Theme.of(context).accentColor,
                          onChanged: (newValue) =>
                              setState(() => _switchTwo = newValue),
                        ),
                      ),
                    ),
                    Tile(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListTile(
                        title: Text(
                          'Setting number 3',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        trailing: Switch(
                          value: _switchThree,
                          activeColor: Theme.of(context).accentColor,
                          onChanged: (newValue) =>
                              setState(() => _switchThree = newValue),
                        ),
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
                        widget.prefs.copyWith(
                          height:
                              BlocProvider.of<SliderBloc>(ctx).state.toInt(),
                          initialWeight: state.initialWeight,
                          initialDate: state.initialDate,
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
          );
        }
      },
    );
  }
}
