import 'package:flutter/material.dart';

Column buildButtonColumn(BuildContext context, IconData icon, String label) {
  Color color = Theme.of(context).primaryColor;

  return new Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      new Icon(
        icon,
        color: color,
      ),
      new Container(
        margin: const EdgeInsets.only(top: 8.0),
        child: new Text(
          label,
          style: new TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      )
    ],
  );
}

Widget buildButtons(BuildContext context,) {
  return new Container(
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildButtonColumn(context, Icons.cached, '刷新'),
        buildButtonColumn(context, Icons.share, '分享'),
      ],
    ),
  );
}
