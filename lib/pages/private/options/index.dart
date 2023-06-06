import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/page_meta.dart';
import 'package:todo_admin/middleware/session.dart';
import 'package:todo_admin/middleware/application.dart';

class OptionsPage extends anxeb.PageWidget<Application, PageMeta> {
  OptionsPage({Key key}) : super('options', key: key, path: 'options');

  @override
  PageMeta meta() => PageMeta(icon: Icons.settings);

  @override
  createState() => _OptionsState();

  @override
  String title({anxeb.GoRouterState state}) => 'Opciones';
}

class _OptionsState extends anxeb.PageView<OptionsPage, Application, PageMeta> {
  @override
  Future init() async {}

  @override
  void setup() async {}

  @override
  void prebuild() {}

  @override
  Widget content() {
    return Container();
  }

  Session get session => application.session;
}
