import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/blocs/slider_bloc/slider_bloc.dart';
import '../util/validators.dart';
import '../widgets/add_user_stepper.dart';
import '../widgets/default_page_layout.dart';
import '../widgets/screen_header.dart';

class AddUserScreen extends StatefulWidget {
  static const String routeName = '/add_user_screen';
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> with Validators {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultPageLayout(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ScreenHeader(
                text: 'Welcome!',
                withCloseIcon: false,
              ),
              BlocProvider<SliderBloc>(
                create: (_) => SliderBloc(180.0),
                child: AddUserStepper(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
