import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/application.dart';
import 'package:todo_admin/middleware/session.dart';

class HeaderBlock extends StatelessWidget {
  final anxeb.Scope scope;
  final Color color;
  final String title;
  final Future Function() action;
  final bool visible;
  final IconData Function() icon;

  const HeaderBlock({
    Key key,
    @required this.scope,
    @required this.color,
    @required this.action,
    @required this.icon,
    this.visible,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (visible == false) {
      return Container();
    }
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 40, top: 10),
        child: Row(
          children: [
            anxeb.IconButton(
              icon: icon?.call(),
              iconSize: 30,
              borderColor: color,
              innerColor: Colors.white.withOpacity(0.8),
              fillColor: color.withOpacity(0.9),
              borderWidth: 2,
              borderPadding: 3,
              size: 38,
              action: action,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 0, right: 10),
                child: Text(
                  title ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Application get application => scope.application;

  Session get session => application.session;
}
