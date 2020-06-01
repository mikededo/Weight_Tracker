import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:weight_tracker/data/blocs/slider_bloc/slider_bloc.dart';
import 'package:weight_tracker/data/database/user_preferences.dart';
import 'package:weight_tracker/screens/home.dart';
import 'package:weight_tracker/widgets/default_page_layout.dart';
import 'package:weight_tracker/widgets/modified_slider.dart';
import 'package:weight_tracker/widgets/screen_header.dart';
import 'package:weight_tracker/widgets/tile.dart';

class AddUserScreen extends StatefulWidget {
  static const String routeName = '/add_user_screen';
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  GlobalKey _formKey = GlobalKey<FormState>();
  bool _metricUnits = true;
  int _currentStep = 0;

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

  Widget _buildField(
      {String hint, TextInputType keyboardType, Function(String) onSaved}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.zero,
        ),
        style: Theme.of(context).textTheme.bodyText1,
        keyboardType: keyboardType ?? null,
        cursorColor: Theme.of(context).accentColor,
        onSaved: onSaved,
      ),
    );
  }

  List<Step> _buildAddUserSteps() {
    return <Step>[
      _buildStep(
        text: 'Tell us about you!',
        stepNum: 0,
        children: <Widget>[
          _buildField(hint: 'Name'),
          _buildField(hint: 'Last name'),
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
          ),          
          _buildField(
            hint: 'Goal weight',
            keyboardType: TextInputType.numberWithOptions(
              signed: false,
              decimal: true,
            ),
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
  }

  void _cancel() {
    if (_currentStep > 0) {
      _goTo(_currentStep - 1);
    }
  }

  void _submitData() {
    int height = BlocProvider.of<SliderBloc>(context).state.floor();
    print(height);
    UserPreferences.saveHeight(height);
    Navigator.of(context).pushReplacementNamed(Home.routeName);
  }

  void _goTo(int step) => setState(() => _currentStep = step);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: DefaultPageLayout(
        child: Column(
          children: <Widget>[
            ScreenHeader(
              text: 'Welcome!',
              withCloseIcon: false,
            ),
            SwitchListTile(
              title: Text(
                'Metric units?',
                style: Theme.of(context).textTheme.headline5,
              ),
              value: _metricUnits,
              onChanged: (bool val) => setState(() => _metricUnits = val),
            ),
            Expanded(
              child: Form(
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
            ),
          ],
        ),
      ),
    );
  }
}
