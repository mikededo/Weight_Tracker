import 'package:flutter/material.dart';

class ScreenHeader extends StatelessWidget {
  final String text;

  const ScreenHeader({@required this.text}) : assert(text != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.075,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            this.text,
            style: Theme.of(context).textTheme.headline1,
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.close,
              size: 24.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
