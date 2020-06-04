import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weight_tracker/data/blocs/weight_db_bloc/weight_db_bloc.dart';
import 'package:weight_tracker/data/models/add_weight_helper.dart';

import 'add_weight_screen.dart';
import 'configuration_screen.dart';
import '../data/blocs/user_preferences_bloc/user_preferences_bloc.dart';
import '../data/models/user_data.dart';
import '../widgets/bmi_tile.dart';
import '../widgets/history.dart';
import '../widgets/default_page_layout.dart';
import '../widgets/weight_progression.dart';

class Home extends StatelessWidget {
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    UserData prefsState = BlocProvider.of<UserPreferencesBloc>(context).state;

    return Scaffold(
      body: DefaultPageLayout(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.075,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Wrap(
                    spacing: 8.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesome.user_circle,
                        size: 28.0,
                        color: Colors.white,
                      ),
                      Text(
                        'Hello, ${prefsState.name}!',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      size: 28.0,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      Navigator.of(context).pushNamed(
                        ConfigurationScreen.routeName,
                        arguments: prefsState,
                      );
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 12.0),
            WeightProgression(),
            SizedBox(height: 12.0),
            BMITile(),
            SizedBox(height: 12.0),
            WeightHistory(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final WeightDBBloc bloc = BlocProvider.of<WeightDBBloc>(context);

          if (bloc.state is WeightDBLoadSuccess ||
              bloc.state is WeightDBLoadInProgress ||
              bloc.state is WeightDBInitial) {
            Navigator.pushNamed(
              context,
              AddWeightScreen.routeName,
              arguments: AddWeightHelper(weightData: bloc.lastWeight),
            );
          }

          bloc.close();
        },
        backgroundColor: Theme.of(context).accentColor,
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            'NEW WEIGHT',
            style: GoogleFonts.workSans().copyWith(
              color: Theme.of(context).scaffoldBackgroundColor,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
