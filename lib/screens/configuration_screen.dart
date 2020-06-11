import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:weight_tracker/util/pair.dart';
import 'package:weight_tracker/util/util.dart';
import 'package:weight_tracker/util/validators.dart';
import 'package:weight_tracker/widgets/weight_db_bloc_builder.dart';
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

class _ConfigurationScreenState extends State<ConfigurationScreen>
    with Validators {
  /// Switch values
  bool _metricUnits = true;

  void _sendEmail(String userMail, List<List<dynamic>> csvItems) async {}

  void _sendEmailWithCsv(List<List<dynamic>> csvItems) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String email = '';
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).accentColor,
      isScrollControlled: true,
      builder: (_) {
        return SingleChildScrollView(
          child: Container(
            color: Color(0xFF000014),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 28.0,
                  horizontal: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Enter your email',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(height: 18.0),
                    Form(
                      key: formKey,
                      child: TextFormField(
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Email',
                          hintText: 'example@example.com',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (!validateEmail(value)) {
                            return 'Enter a valid email';
                          }

                          return null;
                        },
                        onSaved: (value) => email = value,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            if (formKey.currentState.validate()) {
                              _sendEmail(email, csvItems);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                width: 1.0,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            child: Text(
                              'SEND',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    //String fileName = await CsvParser.parseToCsv(['Weight', 'Date'], csvItems);
  }

  Widget _buildCsvTile() {
    return ConfigurationTile(
      title: 'Export data',
      subtitle: 'Export data to a csv file',
      trailing: WeightDBBlocBuilder(
        onLoaded: (state) {
          List<List<dynamic>> csvItems = [];
          state.weightCollection.forEach((wd) => csvItems.add(wd.toCsv()));

          return Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor.withOpacity(0.85),
              borderRadius: BorderRadius.circular(50.0),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2),
                  color: Colors.black26,
                  blurRadius: 3,
                  spreadRadius: 1.5,
                ),
              ],
            ),
            child: InkWell(
              onTap: () => _sendEmailWithCsv(csvItems),
              child: Icon(MaterialCommunityIcons.file_export),
            ),
          );
        },
      ),
    );
  }

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
                resizeToAvoidBottomInset: true,
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
                      _buildCsvTile(),
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
