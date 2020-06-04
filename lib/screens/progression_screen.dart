import 'package:flutter/material.dart';

import '../widgets/default_page_layout.dart';
import '../widgets/screen_header.dart';

class ProgressionScreen extends StatelessWidget {
  static const String routeName = '/progression_string';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultPageLayout(
        child: Column(
          children: <Widget>[
            ScreenHeader(text: 'Progress',)
          ],
        )
      ),
    );
  }
}