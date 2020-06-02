import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/data/blocs/user_preferences_bloc/user_preferences_bloc.dart';
import 'package:weight_tracker/data/blocs/weight_db_bloc/weight_db_bloc.dart';
import 'package:weight_tracker/data/models/user_data.dart';
import 'package:weight_tracker/screens/home.dart';
import 'package:weight_tracker/widgets/default_page_layout.dart';

class LoadingDataScreen extends StatelessWidget {
  const LoadingDataScreen({Key key}) : super(key: key);

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
                return TypewriterAnimatedTextKit(
                  textAlign: TextAlign.left,
                  alignment: AlignmentDirectional.topStart,
                  text: [
                    "Hello ${data.name}! \nWe are glad you have choosen us \nin this journey!",
                    "Wait a second while we set everything!",
                  ],
                  textStyle: Theme.of(context).textTheme.bodyText1,
                  isRepeatingAnimation: false,
                  speed: Duration(milliseconds: 100),
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
