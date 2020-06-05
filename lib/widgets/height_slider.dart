import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/util/util.dart';

import '../data/blocs/slider_bloc/slider_bloc.dart';
import '../data/blocs/slider_bloc/slider_event.dart';

class HeightSlider extends StatelessWidget {
  final double _min;
  final double _max;
  final bool _withText;
  final bool _middleText;
  final Unit _unit;

  HeightSlider({
    double min,
    double max,
    bool withText,
    bool middleText,
    Unit units,
  })  : assert(min < max),
        this._min = min ?? 0,
        this._max = max ?? 100,
        this._withText = withText ?? true,
        this._middleText = middleText ?? true,
        this._unit = units ?? Unit.Metric;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SliderBloc, double>(
      builder: (_, double height) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _withText
                      ? Text(
                          'Set your height',
                          style: Theme.of(context).textTheme.headline5,
                        )
                      : SizedBox(),
                  _middleText
                      ? SizedBox()
                      : Text(
                          _unit == Unit.Metric
                              ? UnitConverter.cmToString(height)
                              : UnitConverter.feetToString(height),
                          style: Theme.of(context).textTheme.headline5,
                        ),
                ],
              ),
            ),
            Slider(
              activeColor: Theme.of(context).accentColor,
              inactiveColor: Theme.of(context).accentColor.withOpacity(0.45),
              value: height,
              min: _min,
              max: _max,
              divisions: (_max - _min).toInt(),
              onChanged: (double value) {
                BlocProvider.of<SliderBloc>(context)
                    .add(SliderBlocModified(value.floorToDouble()));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _unit == Unit.Metric
                        ? UnitConverter.cmToString(_min)
                        : UnitConverter.feetToString(_min),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  _middleText
                      ? Text(
                          _unit == Unit.Metric
                              ? UnitConverter.cmToString(height)
                              : UnitConverter.feetToString(height),
                          style: Theme.of(context).textTheme.headline5,
                        )
                      : SizedBox(),
                  Text(
                    _unit == Unit.Metric
                        ? UnitConverter.cmToString(_max)
                        : UnitConverter.feetToString(_max),
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
