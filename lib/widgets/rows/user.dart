import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/application.dart';
import 'package:todo_admin/middleware/global.dart';
import 'package:todo_admin/middleware/session.dart';
import 'package:todo_admin/models/primary/user.dart';

class UserListRow extends StatefulWidget {
  final anxeb.Scope scope;
  final UserModel user;
  final GestureTapCallback onTap;
  final GestureTapCallback onDeleteTap;
  final int tick;

  const UserListRow({
    Key key,
    @required this.scope,
    @required this.user,
    this.onTap,
    this.tick,
    this.onDeleteTap,
  }) : super(key: key);

  @override
  createState() => _UserListRowState();
}

class _UserListRowState extends State<UserListRow> {
  @override
  Widget build(BuildContext context) {
    return anxeb.ListTitleBlock(
      padding: const EdgeInsets.only(
        right: 12,
        left: 2,
        top: 3,
        bottom: 4,
      ),
      margin: const EdgeInsets.only(top: 1, bottom: 8),
      scope: widget.scope,
      icon: Global.icons.loginState(user.login.state),
      iconPadding: const EdgeInsets.only(top: 3, right: 2, left: 8),
      iconScale: 1,
      iconColor: Global.colors.loginState(user.login.state),
      title: user.toString(),
      titleStyle: TextStyle(
        fontSize: 16,
        height: 1.30,
        fontWeight: FontWeight.w500,
        letterSpacing: -.3,
        color: settings.colors.primary,
      ),
      subtitle: Global.captions.loginState(user.login.state),
      titleTrailBody: anxeb.TextButton(
        caption: 'Eliminar',
        size: anxeb.ButtonSize.chip,
        enabled: user.id != session?.user?.id,
        icon: Icons.delete,
        fontSize: 11,
        margin: const EdgeInsets.only(bottom: 0, top: 2),
        iconSize: 11,
        color: application.settings.colors.danger,
        onPressed: widget.onDeleteTap,
        padding: const EdgeInsets.only(left: 8, right: 11, bottom: 2),
      ),
      subtitleTrailBody: Container(
        padding: const EdgeInsets.only(top: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            anxeb.ListStatsBlock(
              scope: widget.scope,
              text: Global.captions.userRole(user.role).toUpperCase(),
              fontSize: 13,
              icon: Icons.lock,
              iconPadding: const EdgeInsets.only(right: 2),
              scale: 1.6,
              color: settings.colors.primary,
            ),
            anxeb.ListStatsBlock(
              scope: widget.scope,
              text: user.login.email.toUpperCase(),
              fontSize: 13,
              icon: Icons.email,
              iconPadding: const EdgeInsets.only(right: 2),
              scale: 1.6,
              color: settings.colors.primary,
            ),
          ],
        ),
      ),
      subtitleTrailStyle: const TextStyle(
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
      chipColor: Global.colors.loginState(user.login.state),
      subtitleStyle: const TextStyle(
        fontSize: 12,
        height: 1.1,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      divisor: true,
      iconTrailScale: 0.6,
      onTap: widget.onTap,
      borderRadius: Global.settings.generalRadius,
    );
  }

  UserModel get user => widget.user;

  anxeb.Settings get settings => widget.scope.application.settings;

  Application get application => widget.scope.application;

  Session get session => application.session;
}
