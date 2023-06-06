import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:anxeb_flutter/middleware/settings.dart';
import 'package:todo_admin/middleware/application.dart';

class ScaffoldBlock extends StatefulWidget {
  final anxeb.Scope scope;
  final String title;
  final List<Widget> actions;
  final Color color;
  final Future Function() onPullDown;
  final Widget Function() build;
  final Widget Function() bottom;

  const ScaffoldBlock({
    Key key,
    @required this.scope,
    this.title,
    this.actions,
    this.color,
    this.onPullDown,
    this.bottom,
    @required this.build,
  }) : super(key: key);

  @override
  createState() => _ScaffoldBlockState();
}

class _ScaffoldBlockState extends State<ScaffoldBlock> {
  anxeb.RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = anxeb.RefreshController(initialRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title == null
          ? null
          : AppBar(
              title: Text(widget.title),
              backgroundColor: widget.color ?? application.mainColor,
              actions: widget.actions,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              bottom: widget.bottom?.call(),
            ),
      body: anxeb.SmartRefresher(
        controller: _refreshController,
        enablePullDown: widget.onPullDown != null,
        enablePullUp: false,
        footer: null,
        header: anxeb.WaterDropHeader(
          completeDuration: const Duration(milliseconds: 0),
          waterDropColor: widget.scope.application.settings.colors.primary,
          complete: Container(),
          failed: Container(),
          refresh: Container(),
        ),
        onRefresh: () async {
          _refreshController.refreshCompleted();
          try {
            await widget?.onPullDown?.call();
          } catch (err) {
            widget.scope.alerts.error(err).show();
          }
        },
        child: widget.build(),
      ),
    );
  }

  Application get application => widget.scope.application;

  Settings get settings => widget.scope.application.settings;
}
