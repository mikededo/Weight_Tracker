import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final WeightData wd;
  final bool saveAsInitialWeight;

  AddWeightScreen({this.wd, this.saveAsInitialWeight = false});

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

  void _saveWeight(BuildContext ctx, WeightData inValue) {
    double weight = BlocProvider.of<WeightCounterBloc>(ctx).state;
    if (widget.saveAsInitialWeight) {
      // Save weight
      BlocProvider.of<UserPreferencesBloc>(ctx).add(
        UserPreferencesUpdatePreference(
          UserData.UD_INITIAL_WEIGHT,
          weight,
        ),
      );

      // Save initial date
      BlocProvider.of<UserPreferencesBloc>(ctx).add(
        UserPreferencesUpdatePreference(
          UserData.UD_INITIAL_DATE,
          _selectedDate,
        ),
      );
    } else {
      // Create the data and add it to the DB
      WeightData wd = WeightData(
        inValue == null ? null : inValue.id,
        weight: weight,
        date: _selectedDate,
      );
      BlocProvider.of<WeightDBBloc>(ctx).add(
        inValue == null ? WeightDBAdded(wd) : WeightDBUpdated(wd),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedDate = widget.wd == null ? DateTime.now() : widget.wd.date;
  }

  @override
  Widget build(BuildContext context) {
    // Fetch last value from the weight bloc provider
    WeightData lastData = BlocProvider.of<WeightDBBloc>(context).lastWeight;

    WeightData inValue = widget.wd;
    return BlocProvider<WeightCounterBloc>(
      create: (_) => WeightCounterBloc(
        inValue?.weight ?? lastData?.weight,
      ),
      child: Scaffold(
        body: DefaultPageLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ScreenHeader(
                text: inValue != null
                    ? 'Update Weight'
                    : widget.saveAsInitialWeight
                        ? 'Initial Weight'
                        : 'New Weight',
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                child:
                    Text('Date', style: Theme.of(context).textTheme.headline5),
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
              child: Text(
                inValue == null ? 'ADD WEIGHT' : 'UPDATE WEIGHT',
              ),
            ),
            backgroundColor: Theme.of(context).accentColor,
            onPressed: () {
              _saveWeight(ctx, inValue);

              Navigator.of(context).pop();
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
