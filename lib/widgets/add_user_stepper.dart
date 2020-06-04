import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../data/blocs/slider_bloc/slider_bloc.dart';
import '../data/blocs/weight_db_bloc/weight_db_bloc.dart';
import '../data/blocs/user_preferences_bloc/user_preferences_bloc.dart';
import '../data/models/user_data.dart';
import '../data/models/weight.dart';
import '../util/validators.dart';
import '../screens/loading_data_screen.dart';
import '../widgets/tile.dart';

import 'modified_slider.dart';

class AddUserStepper extends StatefulWidget {
  @override
  AddUserStepperState createState() => AddUserStepperState();
}

class AddUserStepperState extends State<AddUserStepper> with Validators {
  bool _metricUnits = true;
  int _currentStep = 0;

  // Form values
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _nameValue = '';
  String _lastNameValue = '';
  double _weightValue = 0.0;
  double _goalWeightValue = 0.0;

  // Form Nodes
  final FocusNode _lastNameFN = FocusNode();
  final FocusNode _weightFN = FocusNode();
  final FocusNode _goalWeightFN = FocusNode();

  Step _buildStep({String text, List<Widget> children, int stepNum}) {
    return Step(
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1,
        softWrap: true,
      ),
      isActive: _isStepActive(stepNum),
      state: _getCurrentState(stepNum),
      content: Column(
        children: children,
      ),
    );
  }

  Widget _buildField({
    String hint,
    TextInputType keyboardType,
    FocusNode focusNode,
    FocusNode nextFocusNode,
    Function(String) onSaved,
    String Function(String) validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.zero,
        ),
        textCapitalization: TextCapitalization.words,
        style: Theme.of(context).textTheme.bodyText1,
        keyboardType: keyboardType,
        cursorColor: Theme.of(context).accentColor,
        onSaved: onSaved,
        focusNode: focusNode,
        validator: validator,
        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(
          _changeNode(focusNode),
        ),
      ),
    );
  }

  List<Step> _buildAddUserSteps() {
    return <Step>[
      _buildStep(
        text: 'Tell us about you!',
        stepNum: 0,
        children: <Widget>[
          _buildField(
            hint: 'Name',
            onSaved: (val) => _nameValue = val,
            validator: (value) {
              if (!validateString(value)) {
                return 'Name cannot be empty!';
              }

              return null;
            },
          ),
          _buildField(
            hint: 'Last name',
            focusNode: _lastNameFN,
            onSaved: (val) => _lastNameValue = val,
            validator: (value) {
              if (!validateString(value)) {
                return 'Last name cannot be empty!';
              }

              return null;
            },
          ),
        ],
      ),
      _buildStep(
        text: 'And what about weight goals?',
        stepNum: 1,
        children: <Widget>[
          _buildField(
            hint: 'Initial weight',
            keyboardType: TextInputType.numberWithOptions(
              signed: false,
              decimal: true,
            ),
            focusNode: _weightFN,
            onSaved: (val) => _weightValue = double.parse(val),
            validator: (value) {
              try {
                if (!validateDouble(double.parse(value))) {
                  return 'Enter your weight!';
                }

                return null;
              } catch (_) {
                return 'Enter your weight!';
              }
            },
          ),
          _buildField(
            hint: 'Goal weight',
            keyboardType: TextInputType.numberWithOptions(
              signed: false,
              decimal: true,
            ),
            focusNode: _goalWeightFN,
            onSaved: (val) => _goalWeightValue = double.parse(val),
            validator: (value) {
              try {
                if (!validateDouble(double.parse(value))) {
                  return 'Enter your goal weight!';
                }

                return null;
              } catch (_) {
                return 'Enter your goal weight!';
              }
            },
          ),
        ],
      ),
      _buildStep(
        text: 'To round up, how tall are you?',
        stepNum: 2,
        children: <Widget>[
          Tile(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
            ),
            child: ModifiedSlider(
              min: 50,
              max: 225,
              withText: false,
            ),
          ),
        ],
      ),
    ];
  }

  FocusNode _changeNode(FocusNode currentNode) {
    if (currentNode == null) {
      return _lastNameFN;
    } else if (currentNode == _lastNameFN) {
      // Go to next step
      _next();
      return _weightFN;
    } else if (currentNode == _weightFN) {
      return _goalWeightFN;
    } else {
      // _goalWeightFN
      _next();
      return null;
    }
  }

  StepState _getCurrentState(int stepNum) {
    if (_currentStep > stepNum) {
      return StepState.complete;
    } else if (_isStepActive(stepNum)) {
      return StepState.editing;
    } else {
      return StepState.indexed;
    }
  }

  bool _isStepActive(int stepNum) => _currentStep == stepNum;

  void _next() {
    _currentStep + 1 != 3 ? _goTo(_currentStep + 1) : _submitData();

    // Unfocus on last input form
    if (_currentStep == 2) {
      FocusScope.of(context).unfocus();
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      _goTo(_currentStep - 1);
    }
  }

  void _goTo(int step) => setState(() => _currentStep = step);

  void _submitData() async {
    if (!_formKey.currentState.validate()) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Some fields are not correct, revise them!'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(milliseconds: 1500),
          ),
        );
    } else {
      // Save all the elements
      _formKey.currentState.save();

      // Extract the height from the bloc
      int height = BlocProvider.of<SliderBloc>(context).state.floor();
      DateTime timestamp = DateTime.now();

      // Save the data
      // Add the started weight
      BlocProvider.of<WeightDBBloc>(context)
        ..add(
          WeightDBAdded(
            WeightData(
              null,
              weight: _weightValue,
              date: timestamp,
            ),
          ),
        );

      BlocProvider.of<UserPreferencesBloc>(context)
        ..add(
          UserPreferencesAddPreferences(
            UserData(
              name: _nameValue,
              lastName: _lastNameValue,
              height: height,
              initialWeight: _weightValue,
              weightGoal: _goalWeightValue,
              initialDate: timestamp,
            ),
          ),
        );

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LoadingDataScreen()));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _lastNameFN.dispose();
    _weightFN.dispose();
    _goalWeightFN.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile(
          title: Text(
            'Metric units?',
            style: Theme.of(context).textTheme.headline5,
          ),
          value: _metricUnits,
          onChanged: (bool val) => setState(() => _metricUnits = val),
        ),
        Form(
          key: _formKey,
          child: Stepper(
            steps: _buildAddUserSteps(),
            onStepContinue: _next,
            onStepCancel: _cancel,
            onStepTapped: _goTo,
            currentStep: _currentStep,
            controlsBuilder: (_, {onStepCancel, onStepContinue}) {
              return ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _currentStep == 0
                      ? null
                      : IconButton(
                          icon: Icon(
                            Feather.arrow_left_circle,
                            size: 30.0,
                          ),
                          onPressed: onStepCancel,
                          tooltip: 'Next step!',
                        ),
                  IconButton(
                    icon: Icon(
                      Feather.arrow_right_circle,
                      size: 30.0,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: onStepContinue,
                    tooltip: 'Next step!',
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
