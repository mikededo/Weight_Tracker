import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/data/models/add_weight_helper.dart';
import 'package:weight_tracker/util/util.dart';

import '../data/blocs/weight_db_bloc/weight_db_bloc.dart';
import '../data/blocs/weight_counter_bloc/weight_counter_bloc.dart';
import '../data/blocs/user_preferences_bloc/user_preferences_bloc.dart';
import '../data/models/user_data.dart';
import '../data/models/weight.dart';
import '../widgets/calendar.dart';
import '../widgets/default_page_layout.dart';
import '../widgets/screen_header.dart';
import '../widgets/weight_value_tile.dart';

class AddWeightScreen extends StatefulWidget {
  static const String routeName = '/add_weight_screen.dart';

  final AddWeightHelper helper;

  AddWeightScreen({this.helper}) : assert(helper != null);

  @override
  _AddWeightScreenState createState() => _AddWeightScreenState();
}

class _AddWeightScreenState extends State<AddWeightScreen> {
  DateTime _selectedDate;

  Widget _buildCalendarCarousel(BuildContext context) {
    return Calendar(
      selectedDateTime: _selectedDate,
      onDayPressed: (DateTime date, _) {
        setState(() => _selectedDate = date);
      },
    );
  }

  void _saveWeight(double weight) {
    // Check if we need to convert it
    Unit units = BlocProvider.of<UserPreferencesBloc>(context).state.dataUnits;
    if (units == Unit.Imperial) {
      weight = UnitConverter.lbsToKg(weight);
    }

    if (widget.helper.addType != AddWeightType.Default) {
      String weightKey;
      String dateKey;

      if (widget.helper.addType == AddWeightType.Initial) {
        // Initial
        weightKey = UserData.UD_INITIAL_WEIGHT;
        dateKey = UserData.UD_INITIAL_DATE;
      } else {
        // Goal
        weightKey = UserData.UD_GOAL_WEIGHT;
        dateKey = UserData.UD_GOAL_DATE;
      }

      // Save weight
      BlocProvider.of<UserPreferencesBloc>(context).add(
        UserPreferencesUpdatePreference(
          weightKey,
          weight,
        ),
      );

      // Save initial date
      BlocProvider.of<UserPreferencesBloc>(context).add(
        UserPreferencesUpdatePreference(
          dateKey,
          _selectedDate,
        ),
      );
    } else {
      // Create the data and add it to the DB
      WeightData wd = WeightData(
        widget.helper.weightData == null ? null : widget.helper.weightData.id,
        weight: weight,
        date: UnitConverter.dateFromDateTime(_selectedDate),
      );
      BlocProvider.of<WeightDBBloc>(context).add(
        widget.helper.weightData == null
            ? WeightDBAdded(wd)
            : WeightDBUpdated(wd),
      );
    }
  }

  String _getScreenHeader() {
    if (widget.helper.addType == AddWeightType.Initial) {
      return 'Initial Weight';
    } else if (widget.helper.addType == AddWeightType.Goal) {
      return 'Goal Weight';
    } else {
      return 'New Weight';
    }
  }

  String _getButtonText() {
    if (widget.helper.addType == AddWeightType.Initial ||
        widget.helper.addType == AddWeightType.Goal) {
      return 'SET WEIGHT';
    } else if (widget.helper.weightData != null) {
      return 'UPDATE WEIGHT';
    } else {
      return 'ADD WEIGHT';
    }
  }

  double _getInitialWeight() {
    // Fetch last value from the weight bloc provider
    WeightData lastData = BlocProvider.of<WeightDBBloc>(context).lastWeight;

    WeightData inValue = widget.helper.weightData;

    if (widget.helper.units == Unit.Metric) {
      return inValue?.weight ?? lastData?.weight;
    } else {
      return UnitConverter.kgToLbs(inValue?.weight ?? lastData?.weight ?? 75);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedDate = widget.helper.weightData == null
        ? DateTime.now()
        : widget.helper.weightData.date;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WeightCounterBloc>(
      create: (_) => WeightCounterBloc(_getInitialWeight()),
      child: Scaffold(
        body: DefaultPageLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ScreenHeader(
                text: _getScreenHeader(),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Date',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                    left: 8.0,
                    bottom: 8.0,
                    top: 14.0,
                  ),
                  child: _buildCalendarCarousel(context),
                ),
              ),
              WeightValueTile(),
            ],
          ),
        ),
        floatingActionButton: Builder(
          builder: (ctx) => FloatingActionButton.extended(
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(_getButtonText()),
            ),
            backgroundColor: Theme.of(context).accentColor,
            onPressed: () {
              _saveWeight(BlocProvider.of<WeightCounterBloc>(ctx).state);

              Navigator.of(context).pop();
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
