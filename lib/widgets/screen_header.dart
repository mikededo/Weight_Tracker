import 'package:flutter/material.dart';

class ScreenHeader extends StatelessWidget {
  final String text;
  final bool withCloseIcon;

  const ScreenHeader({@required this.text, this.withCloseIcon = true})
      : assert(text != null);

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
            text,
            style: Theme.of(context).textTheme.headline1,
          ),
          withCloseIcon
              ? InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    size: 24.0,
                    color: Colors.white,
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
