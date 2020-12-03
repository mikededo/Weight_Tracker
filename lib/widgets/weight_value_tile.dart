import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/data/blocs/user_preferences_bloc/user_preferences_bloc.dart';
import 'package:weight_tracker/util/util.dart';

import '../data/blocs/weight_counter_bloc/weight_counter_bloc.dart';
import '../data/blocs/weight_counter_bloc/weight_counter_event.dart';

class WeightValueTile extends StatelessWidget {
  void _incrementWeight(context) => BlocProvider.of<WeightCounterBloc>(context)
      .add(WeightCounterModified(0.1));

  void _decrementWeight(context) => BlocProvider.of<WeightCounterBloc>(context)
      .add(WeightCounterModified(-0.1));

  void _reWeightCounterSet(context) =>
      BlocProvider.of<WeightCounterBloc>(context)
          .add(WeightCounterValueReset());

  Widget _addWeightButtonConfig(
    BuildContext context, {
    String text,
    Function onTap,
  }) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(6.0),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 12.0,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      onTap: onTap,
    );
  }

  List<Widget> _buildAddWeightButtons(BuildContext context, String unitsText) {
    return [
      _addWeightButtonConfig(
        context,
        text: '-5' + unitsText,
        onTap: () => BlocProvider.of<WeightCounterBloc>(context).add(
          WeightCounterModified(-5.0),
        ),
      ),
      _addWeightButtonConfig(
        context,
        text: '-2.5' + unitsText,
        onTap: () => BlocProvider.of<WeightCounterBloc>(context).add(
          WeightCounterModified(-2.5),
        ),
      ),
      _addWeightButtonConfig(
        context,
        text: '+2.5' + unitsText,
        onTap: () => BlocProvider.of<WeightCounterBloc>(context).add(
          WeightCounterModified(2.5),
        ),
      ),
      _addWeightButtonConfig(
        context,
        text: '+5' + unitsText,
        onTap: () => BlocProvider.of<WeightCounterBloc>(context).add(
          WeightCounterModified(5.0),
        ),
      ),
    ];
  }

  void _displayErrorOnDecrement(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Weight cannot be less than 0!'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final Unit units =
        BlocProvider.of<UserPreferencesBloc>(context).state.dataUnits;
    String unitsText = units == Unit.Metric ? 'kg' : 'lb';

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            top: 24.0,
            bottom: 12.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(
                  'Weight [$unitsText]',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              InkWell(
                onTap: () => _reWeightCounterSet(context),
                child: Text(
                  'Reset',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Theme.of(context).primaryColorLight,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 45.0,
                width: 45.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Theme.of(context).accentColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 3.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 32.0,
                  ),
                  onTap: () {
                    double state =
                        BlocProvider.of<WeightCounterBloc>(context).state;
                    if (state == 0) {
                      _displayErrorOnDecrement(context);
                    } else {
                      _decrementWeight(context);
                    }
                  },
                ),
              ),
              Container(
                width: 175.0,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: BlocBuilder<WeightCounterBloc, double>(
                      builder: (context, double state) => Text(
                        // The state is the current weight
                        state.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 68.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 45.0,
                width: 45.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Theme.of(context).accentColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 3.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 32.0,
                  ),
                  onTap: () => _incrementWeight(context),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildAddWeightButtons(context, unitsText),
          ),
        ),
      ],
    );
  }
}
