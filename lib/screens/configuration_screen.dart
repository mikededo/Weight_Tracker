import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/data/blocs/user_preferences_bloc/user_preferences_bloc.dart';
import 'package:weight_tracker/data/models/user_data.dart';

import '../data/blocs/slider_bloc/slider_bloc.dart';
import '../data/database/user_shared_preferences.dart';
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
          return BlocProvider<SliderBloc>(
            create: (_) => SliderBloc(state.height.toDouble()),
            child: Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      ScreenHeader(text: 'User Settings'),
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
              ),
              floatingActionButton: Builder(
                builder: (ctx) => FloatingActionButton.extended(
                  onPressed: () {
                    UserSharedPreferences.saveHeight(
                      BlocProvider.of<SliderBloc>(ctx).state.toInt(),
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
