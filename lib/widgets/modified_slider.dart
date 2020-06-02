import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/blocs/slider_bloc/slider_bloc.dart';
import '../data/blocs/slider_bloc/slider_event.dart';

class ModifiedSlider extends StatelessWidget {
  final double _min;
  final double _max;
  final bool withText;
  final bool middleText;

  ModifiedSlider({double min, double max, bool withText, bool middleText})
      : assert(min < max),
        this._min = min ?? 0,
        this._max = max ?? 100,
        this.withText = withText ?? true,
        this.middleText = middleText ?? true;

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
                  withText
                      ? Text(
                          'Set your height',
                          style: Theme.of(context).textTheme.headline5,
                        )
                      : SizedBox(),
                  middleText
                      ? SizedBox()
                      : Text(
                          '${height.toStringAsFixed(0)} cm',
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
                    .add(SliderBlocModified(value));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _min.toStringAsFixed(0),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  middleText
                      ? Text(
                          height.toStringAsFixed(0),
                          style: Theme.of(context).textTheme.headline5,
                        )
                      : SizedBox(),
                  Text(
                    _max.toStringAsFixed(0),
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
