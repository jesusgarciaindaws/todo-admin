import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/global.dart';
import 'package:todo_admin/middleware/page_meta.dart';
import 'package:todo_admin/middleware/session.dart';
import 'package:todo_admin/middleware/application.dart';

class ErrorPage extends anxeb.PageWidget<Application, PageMeta> {
  ErrorPage({Key key}) : super('error', key: key, path: 'error');

  @override
  createState() => _ErrorState();

  @override
  List<anxeb.PageWidget<Application, PageMeta> Function()> childs() {
    return [];
  }

  @override
  String title({anxeb.GoRouterState state}) => 'Error';
}

class _ErrorState extends anxeb.PageView<ErrorPage, Application, PageMeta> {
  @override
  Future init() async {}

  @override
  void setup() async {}

  @override
  void prebuild() {}

  @override
  Widget content() {
    return anxeb.GradientContainer(
      scope: scope,
      gradient: Global.gradients.white,
      child: Center(
        child: Container(
          padding: const EdgeInsets.only(left: 60, right: 60, top: 40, bottom: 80),
          color: Colors.red,
          child: Text('Error.\n${info.state.subloc}'),
        ),
      ),
    );
  }

  Session get session => application.session;
}
