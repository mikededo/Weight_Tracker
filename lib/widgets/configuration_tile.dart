import 'package:flutter/material.dart';

import 'tile.dart';

class ConfigurationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;

  const ConfigurationTile({
    @required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Tile(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.headline5,
              ),
              subtitle != null
                  ? Text(
                      subtitle,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    )
                  : SizedBox(),
            ],
          ),
          trailing ?? SizedBox()
        ],
      ),
    );
  }
}
