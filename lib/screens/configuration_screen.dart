import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weight_tracker/data/database/user_configurations.dart';
import 'package:weight_tracker/util/util.dart';
import 'package:weight_tracker/widgets/screen_header.dart';
import 'package:weight_tracker/widgets/tile.dart';

class ConfigurationScreen extends StatefulWidget {
  static const String routeName = '/configuration_screen';

  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  /// Slider values
  final double _min = 50;
  final double _max = 225;
  double _height = 180;

  /// Switch values
  bool _switchOne = false;
  bool _switchTwo = false;
  bool _switchThree = false;

  void _loadConfigurations() {
    UserConfigurations.loadConfigurations().then(
      (config) {
        setState(
          () {
            _height = config.height.truncateToDouble();
          },
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    _loadConfigurations();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Set your height',
                            style: TextStyle(
                              color: textWhiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            '${_height.toStringAsFixed(0)} cm',
                            style: TextStyle(
                                color: textWhiteColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0),
                          ),
                        ],
                      ),
                    ),
                    Slider(
                      activeColor: Theme.of(context).accentColor,
                      inactiveColor:
                          Theme.of(context).accentColor.withOpacity(0.45),
                      value: _height,
                      min: _min,
                      max: _max,
                      divisions: (_max - _min).toInt(),
                      onChanged: (double value) => setState(
                        () => _height = value,
                      ),
                      onChangeEnd: (double value) => print(value),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _min.toStringAsFixed(0),
                            style: TextStyle(color: textWhiteColor),
                          ),
                          Text(
                            _max.toStringAsFixed(0),
                            style: TextStyle(color: textWhiteColor),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Tile(
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                  title: Text(
                    'Setting number 1',
                    style: Theme.of(context).textTheme.headline3,
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
                    style: Theme.of(context).textTheme.headline3,
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
                    style: Theme.of(context).textTheme.headline3,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          UserConfigurations.saveHeight(_height.toInt());
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
