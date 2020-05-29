import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_weight_screen.dart';
import 'configuration_screen.dart';
import '../widgets/bmi_tile.dart';
import '../widgets/history.dart';
import '../widgets/weight_line_chart.dart';

class Home extends StatelessWidget {
  static const String routeName = '/home';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 20.0,
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.075,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.solidUserCircle,
                      size: 28.0,
                      color: Colors.white,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        size: 28.0,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context)
                          .pushNamed(ConfigurationScreen.routeName),
                    )
                  ],
                ),
              ),
              SizedBox(height: 12.0),
              WeightLineChart(),
              SizedBox(height: 12.0),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: double.infinity,
                child: Text('Evolution'),
              ),
              SizedBox(height: 12.0),
              BMITile(),
              SizedBox(height: 12.0),
              WeightHistory(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.pushNamed(context, AddWeightScreen.routeName),
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
