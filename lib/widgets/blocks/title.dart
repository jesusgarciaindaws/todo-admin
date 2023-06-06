import 'package:flutter/material.dart';

import '../../middleware/global.dart';

class TitleBlock extends StatelessWidget {
  final String text;

  const TitleBlock({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: Global.styles.title,
        ),
      ],
    );
  }
}
