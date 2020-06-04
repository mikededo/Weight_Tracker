import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../data/blocs/user_preferences_bloc/user_preferences_bloc.dart';
import '../data/blocs/weight_db_bloc/weight_db_bloc.dart';
import '../data/models/user_data.dart';
import '../screens/home.dart';
import '../widgets/default_page_layout.dart';

class LoadingDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultPageLayout(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: BlocBuilder<UserPreferencesBloc, UserData>(
            builder: (context, state) {
              if (!state.isEmpty) {
                UserData data = state;
                return Padding(
                  padding: const EdgeInsets.only(top: 132.0, bottom: 48.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 250,
                        child: TyperAnimatedTextKit(
                          textAlign: TextAlign.center,
                          alignment: AlignmentDirectional.topStart,
                          text: [
                            "Hello ${data.name}! \nWe are glad you have choosen us \nin this journey! \n\n Wait a second while we set everything!",
                          ],
                          textStyle: Theme.of(context).textTheme.bodyText1,
                          isRepeatingAnimation: false,
                          speed: Duration(milliseconds: 65),
                          onFinished: () {
                            Future.delayed(Duration(seconds: 1)).then(
                              (_) {
                                BlocProvider.of<WeightDBBloc>(context).add(
                                  WeightDBLoadOnStart(),
                                );
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  Home.routeName,
                                  (route) => false,
                                );
                              },
                            );
                          },
                        ),
                      ),
                      SpinKitRipple(
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  child: Text(
                    'Error on loading data',
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
