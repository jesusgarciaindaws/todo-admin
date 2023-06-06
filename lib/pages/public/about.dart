import 'package:flutter/material.dart';
import 'package:anxeb_flutter/anxeb.dart' as anxeb;
import 'package:todo_admin/middleware/global.dart';
import 'package:todo_admin/middleware/page_meta.dart';
import 'package:todo_admin/middleware/session.dart';
import 'package:todo_admin/middleware/application.dart';

class AboutPage extends anxeb.PageWidget<Application, PageMeta> {
  AboutPage({Key key}) : super('_about', key: key, path: 'about');

  @override
  PageMeta meta() => PageMeta(roles: ['*'], icon: Icons.info);

  @override
  createState() => _AboutState();

  @override
  String title({anxeb.GoRouterState state}) => 'Acerca de Nodrix';
}

class _AboutState extends anxeb.PageView<AboutPage, Application, PageMeta> {
  final ImageProvider _fullBrand = const AssetImage('assets/images/brand/color-vertical.png');

  anxeb.DeviceInfo _info;

  @override
  Future init() async {
    _info = anxeb.Device.info;
  }

  @override
  void setup() async {
    await precacheImage(_fullBrand, context);
  }

  @override
  void prebuild() {}

  @override
  Widget content() {
    const url = 'https://nodrix.com';

    return anxeb.GradientContainer(
      scope: scope,
      gradient: Global.gradients.white,
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 260.0,
                    ),
                    child: Image(image: _fullBrand),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: () async {
                        anxeb.Device.launchUrl(scope: scope, url: url);
                      },
                      child: Text(
                        'nodrix.com',
                        style: TextStyle(
                            color: application.settings.colors.link, fontSize: 17, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 18),
                    child: Text(
                      anxeb.translate('pages.public.about.version', args: {
                        'version': _info?.package?.version ?? 'n/a',
                        'rev': _info?.package?.buildNumber ?? 'n/a'
                      }),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      Global.settings.codeName.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.indigo, fontSize: 18),
                    ),
                  ),
                  Visibility(
                    visible: widget?.info?.state?.subloc == '/about',
                    child: anxeb.TextButton(
                      caption: 'Volver',
                      onPressed: () => go('/login'),
                      icon: Icons.arrow_back,
                      iconColor: application.mainColor,
                      textColor: application.mainColor,
                      size: anxeb.ButtonSize.small,
                      width: 120,
                      type: anxeb.ButtonType.frame,
                      margin: const EdgeInsets.only(top: 26),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Session get session => application.session;
}
