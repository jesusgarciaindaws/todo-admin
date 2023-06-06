import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/application.dart';
import 'package:todo_admin/middleware/page_meta.dart';
import 'package:todo_admin/pages/public/about.dart';
import 'package:todo_admin/pages/public/login.dart';
import 'package:todo_admin/widgets/blocks/build.dart';

class PublicContainer extends anxeb.PageContainer<Application, PageMeta> {
  PublicContainer();

  @override
  List<anxeb.PageWidget<Application, PageMeta> Function()> pages() {
    return [
      () => AboutPage(),
      () => LoginPage(),
    ];
  }

  @override
  Future setup() async {}

  @override
  Widget build(BuildContext context, anxeb.GoRouterState state, Widget child) {
    return Stack(
      children: [
        child,
        Column(
          children: [
            Expanded(
              child: Container(),
            ),
            BuildBlock(application: application),
          ],
        ),
      ],
    );
  }
}
