import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/application.dart';
import 'package:todo_admin/middleware/page_meta.dart';
import 'package:todo_admin/pages/public/about.dart';
import 'package:todo_admin/middleware/session.dart';

class HomePage extends anxeb.PageWidget<Application, PageMeta> {
  HomePage({Key key}) : super('home', key: key, path: 'home');

  @override
  PageMeta meta() => PageMeta(icon: Icons.home, subtitle: 'Bienvenido a Nodrix');

  @override
  List<anxeb.PageWidget<Application, PageMeta> Function()> childs() {
    return [
      () => AboutPage(),
    ];
  }

  @override
  createState() => _HomeState();

  @override
  String title({anxeb.GoRouterState state}) => 'Inicio';
}

class _HomeState extends anxeb.PageView<HomePage, Application, PageMeta> {
  final ImageProvider _wallpaper = const AssetImage('assets/images/common/home-wallpaper.jpg');

  @override
  void setup() async {
    await precacheImage(_wallpaper, context);
  }

  @override
  Future init() async {}

  @override
  void prebuild() {}

  @override
  dynamic drawer() => true;

  @override
  Widget content() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.1), BlendMode.screen),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          image: _wallpaper,
        ),
        gradient: LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          stops: const [0, 1],
          colors: [
            const Color(0xffffffff).withOpacity(0.0),
            const Color(0xfff1f1f1).withOpacity(0.5),
          ],
        ),
      ),
    );
  }

  Session get session => application.session;
}
