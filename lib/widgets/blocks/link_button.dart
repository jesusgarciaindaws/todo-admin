import 'package:flutter/material.dart';
import '../../middleware/global.dart';

class LinkButtonBlock extends StatelessWidget {
  final String text;
  final Color color;
  final GestureTapCallback onTap;

  const LinkButtonBlock({
    Key key,
    this.text,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      key: GlobalKey(),
      color: Colors.transparent,
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(text,
              style: TextStyle(
                fontFamily: Global.styles.link.fontFamily,
                fontSize: Global.styles.link.fontSize,
                fontWeight: Global.styles.link.fontWeight,
                color: color ?? Global.styles.link.color,
              )),
        ),
      ),
    );
  }
}
